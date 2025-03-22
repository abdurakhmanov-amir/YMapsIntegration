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
        let favouritesView = DependenciesProvider.ResolveView(FavouriteAddressesView.self)
        let mapView = DependenciesProvider.ResolveView(MapView.self)
        
        guard let favouritesView, let mapView else {
            return
        }
        
        let locationImage = UIImage(named: "location-filled")
        let locationImageSelected = UIImage(named: "location-filled")
        let favouriteImage = UIImage(named: "bookmark-alt")
        let favouriteImageSelected = UIImage(named: "bookmark-alt")
        
        favouritesView.tabBarItem = UITabBarItem(title: "", image: favouriteImage, selectedImage: favouriteImageSelected)
        mapView.tabBarItem = UITabBarItem(title: "", image: locationImage, selectedImage: locationImageSelected)
        
        self.setViewControllers([favouritesView, mapView], animated: true)
        self.selectedIndex = 1
        
        for item in self.tabBar.items! {
            if let image = item.image {
                item.image = image.withRenderingMode(.alwaysOriginal).withTintColor(UIColor(red: 205.0/255.0, green: 199.0/255.0, blue: 201.0/255.0, alpha: 1.0))
            }
        }

        UITabBar.appearance().tintColor = UIColor.black
        
        tabBar.isTranslucent = false
        tabBar.backgroundColor = UIColor.white
    }
}
