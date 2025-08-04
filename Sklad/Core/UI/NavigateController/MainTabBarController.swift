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
        setupTabBarAppearance()
    }
    
    private func setupTabBarAppearance() {
        UITabBar.appearance().tintColor = #colorLiteral(red: 0, green: 0.4787650108, blue: 0.8216508031, alpha: 1)
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().alpha = 0.97

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
