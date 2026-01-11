//
//  MainSegmentControl.swift
//  Sklad
//
//  Created by Кирилл Котыло on 27.09.25.
//

import UIKit


final class MainSegmentedControl: UIControl {
    
    enum Segment: Int, CaseIterable {
        case stoke = 0
        case writeOff = 1
        case test = 2
    }
    
    private let stackView = UIStackView()
    private let stockButton = UIButton(type: .system)
    private let testButton = UIButton(type: .system)
    private let writeOffButton = UIButton(type: .system)
    
    private let highlightView = UIView()
    private var highlightLeading: NSLayoutConstraint!
    private var highlightWidth: NSLayoutConstraint!
    
    private(set) var selectedSegment: Segment = .stoke {
        didSet { animateSelectionChange() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupGestures()
        layoutIfNeeded()
        moveHighlight(to: selectedSegment, animated: false)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupGestures()
        layoutIfNeeded()
        moveHighlight(to: selectedSegment, animated: false)
    }
    
    private func setupView() {
        layer.cornerRadius = 20
        backgroundColor = .buttonTertiary
        
        // highlightView — подсветка
        highlightView.backgroundColor = .stock
        highlightView.layer.cornerRadius = 20
        highlightView.layer.masksToBounds = true
        addSubview(highlightView)
        highlightView.translatesAutoresizingMaskIntoConstraints = false
        
        // stackView поверх highlight
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // highlightView constraints
        highlightLeading = highlightView.leadingAnchor.constraint(equalTo: leadingAnchor)
        highlightWidth = highlightView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / CGFloat(Segment.allCases.count))
        NSLayoutConstraint.activate([
            highlightLeading,
            highlightWidth,
            highlightView.topAnchor.constraint(equalTo: topAnchor),
            highlightView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        setupButton(stockButton, title: "  Доступно", image: UIImage(systemName: "checkmark.circle.fill"))
        setupButton(testButton, title: " На Телипко М.Г.", image: UIImage(systemName: "exclamationmark.triangle.fill"))
        setupButton(writeOffButton, title: "  На списание", image: UIImage(systemName: "xmark.circle.fill"))

        stockButton.addTarget(self, action: #selector(didTapStock), for: .touchUpInside)
        testButton.addTarget(self, action: #selector(didTapTest), for: .touchUpInside)
        writeOffButton.addTarget(self, action: #selector(didTapWriteOff), for: .touchUpInside)
        
        stackView.addArrangedSubview(stockButton)
        stackView.addArrangedSubview(writeOffButton)
        stackView.addArrangedSubview(testButton)
        
        updateUI()
    }
    
    private func setupButton(_ button: UIButton, title: String, image: UIImage?) {
        button.setTitle(title, for: .normal)
        button.setImage(image, for: .normal)
        button.tintColor = .textPrimary
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .regular)
        button.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        
        button.imageView?.contentMode = .scaleAspectFit
    }
    
    private func updateUI() {
        switch selectedSegment {
        case .stoke:
           // stockButton.setTitleColor(.white, for: .normal)
          //  stockButton.tintColor = .white
            //testButton.setTitleColor(.black, for: .normal)
           // testButton.tintColor = .black
           // writeOffButton.setTitleColor(.black, for: .normal)
           // writeOffButton.tintColor = .black
            highlightView.backgroundColor = .stock
            
        case .test:
           // stockButton.setTitleColor(.black, for: .normal)
           // stockButton.tintColor = .black
            //testButton.setTitleColor(.white, for: .normal)
          //  testButton.tintColor = .white
          //  writeOffButton.setTitleColor(.black, for: .normal)
         //   writeOffButton.tintColor = .black
            highlightView.backgroundColor = .test
            
        case .writeOff:
          //  stockButton.setTitleColor(.black, for: .normal)
           // stockButton.tintColor = .black
           // testButton.setTitleColor(.black, for: .normal)
           // testButton.tintColor = .black
          //  writeOffButton.setTitleColor(.white, for: .normal)
          //  writeOffButton.tintColor = .white
            highlightView.backgroundColor = .writeOff
        }
    }
    
    private func moveHighlight(to segment: Segment, animated: Bool) {
        let segmentWidth = bounds.width / CGFloat(Segment.allCases.count)
        let xPosition = CGFloat(segment.rawValue) * segmentWidth
        highlightLeading.constant = xPosition
        
        if animated {
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.8,
                options: [.curveEaseOut]
            ) {
                self.layoutIfNeeded()
            }
        } else {
            layoutIfNeeded()
        }
    }
    
    private func animateSelectionChange() {
        moveHighlight(to: selectedSegment, animated: true)
        updateUI()
        
        let selectedButton: UIButton
        switch selectedSegment {
        case .stoke: selectedButton = stockButton
        case .test: selectedButton = testButton
        case .writeOff: selectedButton = writeOffButton
        }
        
        // Подпрыгивание кнопки
        selectedButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: [.curveEaseOut]) {
            selectedButton.transform = .identity
        }
    }
    
    // MARK: - Gestures
    
    private func setupGestures() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(pan)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        let segmentWidth = bounds.width / CGFloat(Segment.allCases.count)
        let halfWidth = segmentWidth / 2
        
        switch gesture.state {
        case .began:
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.4,
                           initialSpringVelocity: 0.7,
                           options: [.curveEaseOut]) {
                self.highlightView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }
            
        case .changed:
            let targetX = max(0, min(bounds.width - segmentWidth, location.x - halfWidth))
            let currentX = highlightLeading.constant
            let dampenedX = currentX + (targetX - currentX) * 0.3
            highlightLeading.constant = dampenedX
            layoutIfNeeded()
            
            // Подсветка под пальцем
            let index = min(max(Int(location.x / segmentWidth), 0), Segment.allCases.count - 1)
            let hoverSegment = Segment(rawValue: index)!
            switch hoverSegment {
            case .stoke: highlightView.backgroundColor = UIColor.stock.withAlphaComponent(0.5)
            case .test: highlightView.backgroundColor = UIColor.test.withAlphaComponent(0.5)
            case .writeOff: highlightView.backgroundColor = UIColor.writeOff.withAlphaComponent(0.5)
            }
            
        case .ended, .cancelled:
            let index = min(max(Int(location.x / segmentWidth), 0), Segment.allCases.count - 1)
            let newSegment = Segment(rawValue: index)!
            
            if selectedSegment != newSegment {
                selectedSegment = newSegment
                sendActions(for: .valueChanged)
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
            
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 0.3,
                           initialSpringVelocity: 0.8,
                           options: [.curveEaseOut]) {
                self.highlightView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            } completion: { _ in
                UIView.animate(withDuration: 0.3,
                               delay: 0,
                               usingSpringWithDamping: 0.6,
                               initialSpringVelocity: 0.6,
                               options: [.curveEaseOut]) {
                    self.highlightView.transform = .identity
                }
            }
            
            moveHighlight(to: selectedSegment, animated: true)
            updateUI()
            
        default:
            break
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTapStock() {
        guard selectedSegment != .stoke else { return }
        selectedSegment = .stoke
        sendActions(for: .valueChanged)
    }
    
    @objc private func didTapTest() {
        guard selectedSegment != .test else { return }
        selectedSegment = .test
        sendActions(for: .valueChanged)
    }
    
    @objc private func didTapWriteOff() {
        guard selectedSegment != .writeOff else { return }
        selectedSegment = .writeOff
        sendActions(for: .valueChanged)
    }
}

extension MainSegmentedControl {
    @objc var selectedSegmentIndex: Int {
        get { return selectedSegment.rawValue }
        set {
            if let newSegment = Segment(rawValue: newValue) {
                selectedSegment = newSegment
                sendActions(for: .valueChanged)
            }
        }
    }
}
