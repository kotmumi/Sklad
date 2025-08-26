import UIKit
import AVFoundation

class ScannerViewController: UIViewController {
    
    private let captureSessionQueue = DispatchQueue(label: "capture.session.queue")
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var isSessionRunning = false
    private let googleSheetsManager = GoogleSheetsManager()
    
    private var items: [Item] = [] {
        didSet {
            print("Items updated, count: \(items.count)")
        }
    }
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadDataInBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.isTabBarHidden = false
        startCaptureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopCaptureSession()
    }
    
    private func setupUI() {
       
        view.backgroundColor = .black
        setupLaserGridAnimation()
//        // Close button
//        view.addSubview(closeButton)
//        NSLayoutConstraint.activate([
//            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
//        ])
        
        // Loading indicator
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupCaptureSession() {
        captureSessionQueue.async { [weak self] in
            guard let self = self else { return }
            
            let session = AVCaptureSession()
            
            // Setup camera input
            guard let videoDevice = AVCaptureDevice.default(for: .video),
                  let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
                  session.canAddInput(videoInput) else {
                self.showErrorOnMainThread(message: "Не удалось настроить камеру")
                return
            }
            session.addInput(videoInput)
            
            // Setup metadata output
            let metadataOutput = AVCaptureMetadataOutput()
            guard session.canAddOutput(metadataOutput) else {
                self.showErrorOnMainThread(message: "Не удалось настроить обработку QR-кодов")
                return
            }
            session.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: self.captureSessionQueue)
            metadataOutput.metadataObjectTypes = [.qr]
            
            // Setup preview layer on main thread
            DispatchQueue.main.async {
                let previewLayer = AVCaptureVideoPreviewLayer(session: session)
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.frame = self.view.layer.bounds
                self.view.layer.insertSublayer(previewLayer, at: 0)
                self.previewLayer = previewLayer
            }
            
            
            
            self.captureSession = session
            session.startRunning()
            self.isSessionRunning = true
            
        }
    }
    
    // MARK: - Data Loading
    private func loadDataInBackground() {
        loadingIndicator.startAnimating()
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.fetchData { result in
                DispatchQueue.main.async {
                    self?.loadingIndicator.stopAnimating()
                    
                    switch result {
                    case .success(let items):
                        self?.items = items
                        print("Данные успешно загружены")
                    case .failure(let error):
                        self?.showError(message: "Ошибка загрузки: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func setupLaserGridAnimation() {
        let gridView = UIView()
        gridView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gridView)
        gridView.alpha = 0
        // Расположение сетки в области сканирования
        NSLayoutConstraint.activate([
            gridView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gridView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gridView.widthAnchor.constraint(equalToConstant: 200),
            gridView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        // Горизонтальные линии
        for i in 0..<5 {
            let line = UIView()
            line.backgroundColor = UIColor.green.withAlphaComponent(0.3)
            line.translatesAutoresizingMaskIntoConstraints = false
            gridView.addSubview(line)
            
            NSLayoutConstraint.activate([
                line.leadingAnchor.constraint(equalTo: gridView.leadingAnchor),
                line.trailingAnchor.constraint(equalTo: gridView.trailingAnchor),
                line.heightAnchor.constraint(equalToConstant: 1),
                line.topAnchor.constraint(equalTo: gridView.topAnchor, constant: CGFloat(i) * 50)
            ])
            // Анимация альфа-канала
            UIView.animate(withDuration: 0.5, delay: 1, options: [.repeat, .autoreverse], animations: {
                line.alpha = 1.0
            }, completion: nil)
        }
        
    }
    
    private func fetchData(completion: @escaping (Result<[Item], Error>) -> Void) {
        let group = DispatchGroup()
        var mainItems: [Item] = []
        var writeItems: [String: Double] = [:]
        var fetchError: Error?
        
        // Загрузка основных данных
        group.enter()
        googleSheetsManager.fetchDataFromGoogleSheets(
            spreadsheetId: "1YDfMuU23ZiDN8HegT4OgMkWXp--Vv9o2QwXNqPDTHik",
            range: "'Остатки технопарка'"
        ) { result in
            defer { group.leave() }
            
            switch result {
            case .success(let response):
                mainItems = self.parseItems(from: response)
            case .failure(let error):
                fetchError = error
            }
        }
        
        // Загрузка данных для списания
        group.enter()
        googleSheetsManager.fetchDataFromGoogleSheets(
            spreadsheetId: "1PUZLv4J3XC9CGTmvmia_nEP0ZW12pZmciC1PA0hFnw4",
            range: "'Списание Июль 2025'"
        ) { result in
            defer { group.leave() }
            
            if case .success(let response) = result {
                writeItems = self.parseWriteCounts(from: response)
            }
        }
        
        group.notify(queue: .global(qos: .userInitiated)) {
            if let error = fetchError {
                completion(.failure(error))
                return
            }
            
            // Объединяем данные
            var finalItems = mainItems
            for (name, count) in writeItems {
                if let index = finalItems.firstIndex(where: { $0.name == name }) {
                    finalItems[index].writeCount += count
                }
            }
            
            completion(.success(finalItems))
        }
    }
    
    private func parseItems(from response: GoogleSheetResponse) -> [Item] {
        return response.values.compactMap { row in
            guard row.count > 9, row != response.values.first else { return nil }
            
            let quantityString = row[4].replacingOccurrences(of: ",", with: ".")
            guard let quantity = Double(quantityString.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)) else {
                return nil
            }
            
            return Item(
                name: row[1],
                actualName: row[2],
                price: row[5],
                totalPrice: row[6],
                quantity: quantity,
                writeCount: 0,
                unit: row[3],
                imageURL: nil,
                charRack: row[8],
                numberRack: row[9],
                row: nil,
                comment: nil
            )
        }
    }
    
    private func parseWriteCounts(from response: GoogleSheetResponse) -> [String: Double] {
        var counts: [String: Double] = [:]
        
        for i in 2..<response.values.count {
            let row = response.values[i]
            guard row.count > 2 else { continue }
            
            let name = row[0]
            let countString = row[2]
                .replacingOccurrences(of: ",", with: ".")
                .replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
            
            if let count = Double(countString) {
                counts[name] = (counts[name] ?? 0) + count
            }
        }
        
        return counts
    }
    
    // MARK: - Actions
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - Session Control
    private func startCaptureSession() {
        guard captureSession == nil else {
            captureSessionQueue.async { [weak self] in
                if let session = self?.captureSession, !(self?.isSessionRunning ?? false) {
                    session.startRunning()
                    self?.isSessionRunning = true
                }
            }
            return
        }
        
        setupCaptureSession()
    }
    
    private func stopCaptureSession() {
        captureSessionQueue.async { [weak self] in
            if let session = self?.captureSession, self?.isSessionRunning == true {
                session.stopRunning()
                self?.isSessionRunning = false
            }
        }
    }
    
    // MARK: - Error Handling
    private func showErrorOnMainThread(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.showError(message: message)
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func handleScannedCode(_ code: String) {
        guard let item = items.first(where: { $0.name == code }) else {
            showNotFoundAlert()
            return
        }
        
        let detailsVC = DetailsViewController(item: item)
        //present(detailsVC,animated: true)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    private func showNotFoundAlert() {
        let alert = UIAlertController(
            title: "Не найдено",
            message: "Элемент с таким кодом не найден",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.startCaptureSession()
        })
        present(alert, animated: true)
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                       didOutput metadataObjects: [AVMetadataObject],
                       from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first,
              let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
              let stringValue = readableObject.stringValue else {
            return
        }
        
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        stopCaptureSession()
        
        DispatchQueue.main.async { [weak self] in
            self?.handleScannedCode(stringValue)
        }
    }
}
