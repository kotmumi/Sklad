//
//  MainTabBar.swift
//  StockTrace
//
//  Created by Кирилл Котыло on 25.06.25.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private var gradientLayer: CAGradientLayer?
    private var blurView: UIVisualEffectView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()
        setupGradientAndBlur()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateGradientFrame()
    }
    
    private func setupTabBarAppearance() {
        tabBar.tintColor = .buttonPrimary
        tabBar.backgroundColor = .clear
        
        tabBar.isTranslucent = true
        tabBar.clipsToBounds = true
        
        tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        //UITabBar.appearance().tintColor = .buttonPrimary
        //UITabBar.appearance().backgroundColor = .backgroundPrimary
        //UITabBar.appearance().alpha = 1

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
           // appearance.backgroundColor = .clear
            appearance.backgroundEffect = UIBlurEffect(style: .systemThinMaterialLight)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    private func setupGradientAndBlur() {
          // Создаем градиентный слой
          let gradient = CAGradientLayer()
          gradient.colors = [
              UIColor.backgroundPrimary.cgColor,
              UIColor.backgroundPrimary.withAlphaComponent(0.3).cgColor,
              UIColor.clear.withAlphaComponent(0.3).cgColor
          ]
          gradient.locations = [0.0, 0.5, 1.0]
          gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
          gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
          
          gradientLayer = gradient
          
          // Создаем размытие
          let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
          let blurView = UIVisualEffectView(effect: blurEffect)
          blurView.frame = tabBar.bounds
          blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
          
          // Вставляем градиент под размытие
          tabBar.layer.insertSublayer(gradient, at: 0)
          tabBar.insertSubview(blurView, at: 0)
          
          self.blurView = blurView
      }
      
      private func updateGradientFrame() {
          gradientLayer?.frame = tabBar.bounds
          blurView?.frame = tabBar.bounds
      }
}
