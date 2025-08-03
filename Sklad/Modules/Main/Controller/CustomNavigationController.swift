//
//  CustomNavigationController.swift
//  StockTrace
//
//  Created by Кирилл Котыло on 25.06.25.
//

import UIKit

class CustomNavigationController: UINavigationController {
    
    let gradientColors = [
        UIColor.white,
        UIColor.clear
     ]
    
    let viewController: UIViewController
    let searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchBar.placeholder = "Поиск по названию"
        sc.searchBar.translatesAutoresizingMaskIntoConstraints = false
        sc.searchBar.searchTextField.background = nil
        sc.searchBar.searchTextField.backgroundColor = .white
        return sc
    }()
    
    let filterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 25
        return button
    }()
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSearchBarAppearance()
    }
    
    private func setupViewControllers() {
        searchController.searchBar.addSubview(filterButton)
        viewController.navigationController?.navigationBar.layer.borderWidth = 0
        viewController.navigationItem.searchController = searchController
        viewController.navigationItem.hidesSearchBarWhenScrolling = false
        viewControllers = [viewController]

    }
    
    private func setupSearchBarAppearance () {
        DispatchQueue.main.async {
            
           guard let searchTextField = self.searchController.searchBar.value(forKey: "searchField") as? UITextField else { return }
            
            searchTextField.translatesAutoresizingMaskIntoConstraints = false
           
            NSLayoutConstraint.deactivate(searchTextField.constraints)
            
            let height: CGFloat = 50
            let padding: CGFloat = 16
            
            NSLayoutConstraint.activate([
                searchTextField.heightAnchor.constraint(equalToConstant: height),
                searchTextField.leadingAnchor.constraint(equalTo: self.searchController.searchBar.leadingAnchor, constant: padding),
                searchTextField.trailingAnchor.constraint(equalTo: self.searchController.searchBar.trailingAnchor, constant: -padding * 5),
                searchTextField.centerYAnchor.constraint(equalTo: self.searchController.searchBar.centerYAnchor),
                
                self.filterButton.heightAnchor.constraint(equalToConstant: height),
                self.filterButton.widthAnchor.constraint(equalToConstant: height),
                self.filterButton.trailingAnchor.constraint(equalTo: self.searchController.searchBar.trailingAnchor, constant: -padding),
                self.filterButton.topAnchor.constraint(equalTo: searchTextField.topAnchor),
            ])
            
            searchTextField.layer.cornerRadius = height/2
            searchTextField.layer.masksToBounds = true
         
            searchTextField.background = nil
            searchTextField.borderStyle = .none
            searchTextField.backgroundColor = .white
            
            searchTextField.layer.borderWidth = 1
            searchTextField.layer.borderColor = UIColor.lightGray.cgColor
            
        }
    }
}

extension UINavigationBar {
    func setTransparentGradient() {
        // 1. Полностью прозрачный фон
        let emptyImage = UIImage()
        self.setBackgroundImage(emptyImage, for: .default)
        self.shadowImage = emptyImage
        self.isTranslucent = true
        
        // 2. Создаем градиентный слой
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1).withAlphaComponent(0.95).cgColor,
            #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1).withAlphaComponent(0).cgColor
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.8)
        
        // 3. Специальный контейнер для градиента
//        let gradientView = UIView(frame: CGRect(
//            x: 0,
//            y: -UIApplication.shared.statusBarFrame.height,
//            width: UIScreen.main.bounds.width,
//            height: self.bounds.height + UIApplication.shared.statusBarFrame.height
//        ))
//        gradientView.layer.addSublayer(gradientLayer)
//        gradientLayer.frame = gradientView.bounds
        
        // 4. Создание изображения с прозрачностью
        let format = UIGraphicsImageRendererFormat()
        format.opaque = false
        format.scale = UIScreen.main.scale
        
        let renderer = UIGraphicsImageRenderer(size: gradientLayer.bounds.size, format: format)
        let image = renderer.image { context in
            // Очищаем фон полностью прозрачным
            UIColor.clear.setFill()
            context.fill(CGRect(origin: .zero, size: gradientLayer.bounds.size))
            
            // Рендерим градиент
            gradientLayer.render(in: context.cgContext)
        }
        // 5. Настройка для iOS 15+
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundEffect = nil
            appearance.backgroundColor = .clear
            appearance.backgroundImage = image
            appearance.shadowColor = nil
            
            self.standardAppearance = appearance
            self.scrollEdgeAppearance = appearance
        } else {
            self.setBackgroundImage(image, for: .default)
        }
        
        // 6. Дополнительные фиксы
        self.backgroundColor = .clear
        self.barTintColor = .clear
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0
    }
}
