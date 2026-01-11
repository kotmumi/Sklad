//
//  ScannerViewController.swift
//  TaskPulse
//
//  Created by Кирилл Котыло on 9.10.25.
//

import UIKit
import AVFoundation

final class ScanerViewController: UIViewController {
    
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    private let cornerLayer = CAShapeLayer()
    private let torchButton = UIButton(type: .system)
    private let backButton = UIButton(type: .system)
    
    private let titlelabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "QR-code"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .textPrimary
        return label
    }()
    
    let lastButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.setTitle("  Недавнее", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setImage(UIImage(systemName: "qrcode.viewfinder"), for: .normal)
        button.tintColor = .textPrimary
        button.backgroundColor = .buttonTertiary
        return button
    }()
    
    private var torchOn = false
    private var isProcessingQR = false
    
    private let viewModel: ScanerViewModel
    weak var coordinator: ScannerCoordinator?
    
    init(viewModel: ScanerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCamera()
        setupOverlay()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
            // Сбрасываем флаг при возврате на экран
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self else { return }
            if  self.captureSession?.isRunning == false {
                self.captureSession.startRunning()
            }
            
            isProcessingQR = false
        }
    }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let self else { return }
                if self.captureSession?.isRunning == true {
                    self.captureSession.stopRunning()
                }
            }
        }
    
    // MARK: - Camera Setup
    private func setupCamera() {
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              captureSession.canAddInput(videoInput) else { return }
        captureSession.addInput(videoInput)
        
        let metadataOutput = AVCaptureMetadataOutput()
        guard captureSession.canAddOutput(metadataOutput) else { return }
        captureSession.addOutput(metadataOutput)
        
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)
        DispatchQueue.global().async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    // MARK: - Overlay
    private func setupOverlay() {
        let size: CGFloat = 200
        let lineLength: CGFloat = 40
        let lineWidth: CGFloat = 5
        let cornerRadius: CGFloat = 20
        let color = UIColor.systemGray3.cgColor
        
        // Центр окна
        let frameRect = CGRect(
            x: (view.bounds.width - size) / 2,
            y: (view.bounds.height - size) / 2 - 100,
            width: size,
            height: size
        )
        
        // Рисуем только углы
        let path = UIBezierPath()
        
        // верхний левый
        path.move(to: CGPoint(x: frameRect.minX + cornerRadius, y: frameRect.minY))
        path.addArc(withCenter: CGPoint(x: frameRect.minX + cornerRadius, y: frameRect.minY + cornerRadius),
                    radius: cornerRadius,
                    startAngle: -.pi/2,
                    endAngle: -.pi,
                    clockwise: false)
        path.addLine(to: CGPoint(x: frameRect.minX, y: frameRect.minY + lineLength))
        path.move(to: CGPoint(x: frameRect.minX + lineLength, y: frameRect.minY))
        path.addLine(to: CGPoint(x: frameRect.minX + cornerRadius, y: frameRect.minY))
        
        // верхний правый
        path.move(to: CGPoint(x: frameRect.maxX - lineLength, y: frameRect.minY))
        path.addLine(to: CGPoint(x: frameRect.maxX - cornerRadius, y: frameRect.minY))
        path.addArc(withCenter: CGPoint(x: frameRect.maxX - cornerRadius, y: frameRect.minY + cornerRadius),
                    radius: cornerRadius,
                    startAngle: -.pi/2,
                    endAngle: 0,
                    clockwise: true)
        path.addLine(to: CGPoint(x: frameRect.maxX, y: frameRect.minY + lineLength))
        
        // нижний правый
        path.move(to: CGPoint(x: frameRect.maxX, y: frameRect.maxY - lineLength))
        path.addLine(to: CGPoint(x: frameRect.maxX, y: frameRect.maxY - cornerRadius))
        path.addArc(withCenter: CGPoint(x: frameRect.maxX - cornerRadius, y: frameRect.maxY - cornerRadius),
                    radius: cornerRadius,
                    startAngle: 0,
                    endAngle: .pi/2,
                    clockwise: true)
        path.addLine(to: CGPoint(x: frameRect.maxX - lineLength, y: frameRect.maxY))
        
        // нижний левый
        path.move(to: CGPoint(x: frameRect.minX + lineLength, y: frameRect.maxY))
        path.addLine(to: CGPoint(x: frameRect.minX + cornerRadius, y: frameRect.maxY))
        path.addArc(withCenter: CGPoint(x: frameRect.minX + cornerRadius, y: frameRect.maxY - cornerRadius),
                    radius: cornerRadius,
                    startAngle: .pi/2,
                    endAngle: .pi,
                    clockwise: true)
        path.addLine(to: CGPoint(x: frameRect.minX, y: frameRect.maxY - lineLength))
        
        // Настраиваем слой
        cornerLayer.path = path.cgPath
        cornerLayer.strokeColor = color
        cornerLayer.lineWidth = lineWidth
        cornerLayer.fillColor = UIColor.clear.cgColor
        cornerLayer.lineCap = .round
        cornerLayer.lineJoin = .round
        view.layer.addSublayer(cornerLayer)
        
        // Анимация дыхания
        let pulse = CABasicAnimation(keyPath: "opacity")
        pulse.fromValue = 1.0
        pulse.toValue = 0.6
        pulse.duration = 1.5
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        cornerLayer.add(pulse, forKey: "pulse")
    }
    
    // MARK: - Buttons
    private func setupUI() {
        // Кнопка назад
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .white
        backButton.frame = CGRect(x: 20, y: 55, width: 44, height: 44)
        backButton.backgroundColor = .backgroundPrimary
        backButton.layer.cornerRadius = 22
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        view.addSubview(backButton)
        
        // Кнопка фонарика
        torchButton.setImage(UIImage(systemName: "sun.max"), for: .normal)
        torchButton.tintColor = .white
        torchButton.frame = CGRect(x: (view.bounds.width - 60)/2,
                                   y: view.bounds.height / 2 + 100,
                                   width: 60, height: 60)
        torchButton.layer.cornerRadius = 30
        torchButton.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        torchButton.addTarget(self, action: #selector(toggleTorch), for: .touchUpInside)
        view.addSubview(torchButton)
        
        view.addSubview(titlelabel)
        view.addSubview(lastButton)
        
        NSLayoutConstraint.activate([
            titlelabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titlelabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            lastButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            lastButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            lastButton.heightAnchor.constraint(equalToConstant: 50),
            lastButton.widthAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    // MARK: - Torch
    @objc private func toggleTorch() {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        
        torchOn.toggle()
        UIView.animate(withDuration: 0.3) {
            self.torchButton.tintColor = self.torchOn ? .systemYellow : .white
            self.torchButton.backgroundColor = self.torchOn
                ? UIColor.systemYellow.withAlphaComponent(0.25)
                : UIColor.black.withAlphaComponent(0.3)
        }
        
        try? device.lockForConfiguration()
        device.torchMode = torchOn ? .on : .off
        device.unlockForConfiguration()
    }
    
    // MARK: - Back
    @objc private func backTapped() {
        captureSession.stopRunning()
        coordinator?.back()
       // dismiss(animated: true)
    }
    
    // MARK: - QR Detection
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
        guard !isProcessingQR else { return }
        
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let code = object.stringValue else { return }
        isProcessingQR = true
        if let item = viewModel.scaneItem(barcode: code) {
            
            showSuccessAnimation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                let itemWriteOff = viewModel.featchWriteOffItems(item: item)
                
                self.captureSession.stopRunning()
                
                coordinator?.goToDetails(item: item, writeOff: itemWriteOff)
            }
            print("✅ QR найден: \(code)")
        } else {
            
            showErrorAnimation()
            print("❌ QR не найден: \(code)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.isProcessingQR = false
            }
        }
    }
    
    private func showSuccessAnimation() {
            // Зеленый цвет при успехе
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.25)
            cornerLayer.strokeColor = UIColor.systemGreen.cgColor
            CATransaction.commit()
            
            // Возврат цвета через 1.5 секунды
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                guard let self = self else { return }
                CATransaction.begin()
                CATransaction.setAnimationDuration(0.25)
                self.cornerLayer.strokeColor = UIColor.systemGray3.cgColor
                CATransaction.commit()
            }
        }
        
    
    private func showErrorAnimation() {
            // Красный цвет при ошибке
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.25)
            cornerLayer.strokeColor = UIColor.systemRed.cgColor
            CATransaction.commit()
            
            // Вибрация при ошибке
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
            // Возврат цвета через 1.5 секунды
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                guard let self = self else { return }
                CATransaction.begin()
                CATransaction.setAnimationDuration(0.25)
                self.cornerLayer.strokeColor = UIColor.systemGray3.cgColor
                CATransaction.commit()
                
                // Сбрасываем флаг для нового сканирования
                self.isProcessingQR = false
            }
        }
}

extension ScanerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
}
