//
//  MainTabBar.swift
//  StockTrace
//
//  Created by Кирилл Котыло on 25.06.25.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupTabBarAppearance()
    }
    
    private func setupViewControllers() {
        
        let navigationController1 = CustomNavigationController(viewController: MainViewController())
        let vc2 = WriteOffListViewController()
        let vc3 = AccountViewController()
        let navigationController2 = UINavigationController()
        navigationController2.viewControllers.append(ScannerViewController())
        navigationController2.navigationBar.backgroundColor = .clear
    
        navigationController1.tabBarItem = UITabBarItem(title: "Sklad", image: UIImage(systemName: "tray.full.fill"), tag: 0)
        vc2.tabBarItem = UITabBarItem(title: "List", image: UIImage(systemName: "list.bullet.circle.fill"), tag: 1)
        vc3.tabBarItem = UITabBarItem(title: "Account", image: UIImage(systemName: "person.crop.circle"), tag: 2)
        navigationController2.tabBarItem = UITabBarItem(title: "Scaner", image: UIImage(systemName: "barcode"), tag: 3)
        
        viewControllers = [navigationController1, vc2, navigationController2, vc3]
    }
    
    private func setupTabBarAppearance() {
        UITabBar.appearance().tintColor = #colorLiteral(red: 0, green: 0.4787650108, blue: 0.8216508031, alpha: 1)
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().alpha = 0.97
        // 5. Добавляем отступы от краев
        self.setValue(PaddedTabBar() , forKey: "tabBar")
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .clear
            appearance.backgroundEffect = UIBlurEffect(style: .systemThinMaterialLight)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

class PaddedTabBar: UITabBar {
    private var padding: CGFloat = 20
    private var bottomPadding: CGFloat = 10
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let superview = self.superview else { return }
              
              // 1. Рассчитываем положение с учетом Safe Area
              let safeAreaBottom = superview.safeAreaInsets.bottom
              let totalHeight = self.frame.height + safeAreaBottom //+ bottomPadding
        
        // 1. Устанавливаем новый frame с отступами
        self.frame = CGRect(
            x: padding,
            y: superview.bounds.height - totalHeight,
            width: self.superview!.bounds.width - 2 * padding,
            height: self.bounds.height
        )
        // 2. Скругление углов
        self.layer.cornerRadius = 25
        self.layer.masksToBounds = true
        
        // 3. Перераспределяем кнопки
        let itemWidth = (self.bounds.width - 2 * padding) / CGFloat(self.items?.count ?? 1)
        var xOffset: CGFloat = padding
       // var yOffset: CGFloat = padding
        for view in self.subviews {
            if let itemView = view as? UIControl {
                itemView.frame = CGRect(
                    x: xOffset,
                    y: 0,
                    width: itemWidth,
                    height: self.bounds.height //- bottomPadding * 2
                )
                xOffset += itemWidth
            }
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
            var size = super.sizeThatFits(size)
            size.height = 50 // Увеличиваем высоту для отступа
            return size
        }
    override var intrinsicContentSize: CGSize {
         var size = super.intrinsicContentSize
         size.height = 50
         return size
     }
}
