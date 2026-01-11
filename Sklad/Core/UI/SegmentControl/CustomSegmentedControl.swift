import UIKit

final class CustomSegmentedControl: UIControl {
    
    enum Segment: Int {
        case writeOff = 0
        case test = 1
    }
    
    private let stackView = UIStackView()
    private let testButton = UIButton(type: .system)
    private let writeOffButton = UIButton(type: .system)
    
    private let highlightView = UIView()
    private var highlightLeading: NSLayoutConstraint!
    private var highlightWidth: NSLayoutConstraint!
    
    private(set) var selectedSegment: Segment = .writeOff {
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
        //clipsToBounds = true
        backgroundColor = .backgroundTertiary
        
        // highlightView — подсветка
        highlightView.backgroundColor = .writeOff
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
        highlightWidth = highlightView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5)
        NSLayoutConstraint.activate([
            highlightLeading,
            highlightWidth,
            highlightView.topAnchor.constraint(equalTo: topAnchor),
            highlightView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        setupButton(testButton, title: "  На Телипко М.Г.", image: UIImage(systemName: "exclamationmark.triangle.fill"))
        setupButton(writeOffButton, title: "  На списание", image: UIImage(systemName: "xmark.circle.fill"))
        
        testButton.addTarget(self, action: #selector(didTapTest), for: .touchUpInside)
        writeOffButton.addTarget(self, action: #selector(didTapWriteOff), for: .touchUpInside)
        
        stackView.addArrangedSubview(writeOffButton)
        stackView.addArrangedSubview(testButton)
        
        updateUI()
    }
    
    private func setupButton(_ button: UIButton, title: String, image: UIImage?) {
        button.setTitle(title, for: .normal)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
        button.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        
        button.imageView?.contentMode = .scaleAspectFit
        
    }
    
    private func updateUI() {
        switch selectedSegment {
        case .test:
            //testButton.setTitleColor(.white, for: .normal)
           // testButton.tintColor = .white
            
            //writeOffButton.setTitleColor(.black, for: .normal)
            //writeOffButton.tintColor = .black
            highlightView.backgroundColor = .test
            
        case .writeOff:
            //writeOffButton.setTitleColor(.white, for: .normal)
            //writeOffButton.tintColor = .white
            
            //testButton.setTitleColor(.black, for: .normal)
           // testButton.tintColor = .black
            highlightView.backgroundColor = .writeOff
        }
    }
    
    private func moveHighlight(to segment: Segment, animated: Bool) {
        let segmentWidth = bounds.width / 2
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
        
        let selectedButton: UIButton = (selectedSegment == .test) ? testButton : writeOffButton
        
        // Подпрыгивание иконки
        selectedButton.imageView?.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 0.8,
            options: [.curveEaseOut]
        ) {
            selectedButton.imageView?.transform = .identity
        }
        
        // Подпрыгивание самой кнопки
        selectedButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.8,
            options: [.curveEaseOut]
        ) {
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
        let segmentWidth = bounds.width / 2
        let halfWidth = segmentWidth / 2
        
        switch gesture.state {
        case .began:
            // Начальное увеличение highlight при старте перетаскивания
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 0.3,
                           initialSpringVelocity: 0.8,
                           options: [.curveEaseOut]) {
                self.highlightView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            
        case .changed:
            // "Липкий" highlight
            let targetX = max(0, min(bounds.width - segmentWidth, location.x - halfWidth))
            let currentX = highlightLeading.constant
            let dampenedX = currentX + (targetX - currentX) * 0.3
            highlightLeading.constant = dampenedX
            layoutIfNeeded()
            
            // Интерактивная подсветка
            let hoverSegment: Segment = (location.x < segmentWidth) ? .test : .writeOff
            highlightView.backgroundColor = (hoverSegment == .test) ? UIColor.test.withAlphaComponent(0.5) : UIColor.writeOff.withAlphaComponent(0.5)
            
        case .ended, .cancelled:
            // Определяем сегмент по позиции отпуска
            let newSegment: Segment = (location.x < segmentWidth) ? .test : .writeOff
            
            if selectedSegment != newSegment {
                selectedSegment = newSegment
                sendActions(for: .valueChanged)
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
            
            // Подпрыгивание highlight при отпускании с spring-анимацией
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.3,
                           initialSpringVelocity: 0.8,
                           options: [.curveEaseOut]) {
                self.highlightView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            } completion: { _ in
                UIView.animate(withDuration: 0.3,
                               delay: 0,
                               usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 0.6,
                               options: [.curveEaseOut]) {
                    self.highlightView.transform = .identity
                }
            }
            
            // Притягиваем highlight к сегменту
            moveHighlight(to: selectedSegment, animated: true)
            updateUI()
            
        default:
            break
        }
    }
    
    
    // MARK: - Actions
    
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
