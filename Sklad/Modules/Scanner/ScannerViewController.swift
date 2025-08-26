import UIKit
import AVFoundation

class ScannerViewController: UIViewController {
    
  
    
    private let captureSessionQueue = DispatchQueue(label: "capture.session.queue")
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var isSessionRunning = false
    private let googleSheetsManager = GoogleSheetsDataService()
    
    private var items: [Item]
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    init(items: [Item]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        guard items.first(where: { $0.details.commercialName == code }) != nil else {
            showNotFoundAlert()
            return
        }
        
       // let detailsVC = DetailsViewController(item: item, writeOff: <#[ItemWriteOff]#>)
       // navigationController?.pushViewController(detailsVC, animated: true)
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
