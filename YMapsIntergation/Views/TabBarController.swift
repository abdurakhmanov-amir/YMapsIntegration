//
//  TabBarController.swift
//  YMapsIntergation
//
//  Created by Amir on 15.03.2025.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setTabs()
    }
    
    private func setTabs() {
        let vc1 = ViewController()
        let vc2 = MapView()
        
        vc1.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        vc2.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "clock"), selectedImage: UIImage(systemName: "clock.fill"))
        
        self.setViewControllers([vc1, vc2], animated: true)
        self.selectedIndex = 1
        
        tabBar.isTranslucent = false
        tabBar.backgroundColor = UIColor.white
    }
}
