//
//  TabBarViewController.swift
//  PillCare
//
//  Created by Moin Janjua on 13/08/2024.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        
       
        let appearance = UITabBarAppearance()

             // Customize selected icon and label color
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemRed
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemRed]

             // Customize unselected icon and label color
             appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
             appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
             
             // Apply the appearance configuration to the tab bar
             tabBar.standardAppearance = appearance
    }
    func updateTabBarImages() {
        guard let items = tabBar.items else { return }
        
       
        for (_, item) in items.enumerated() {
          
            item.setTitleTextAttributes([.foregroundColor: UIColor.systemPurple], for: .selected)
            item.setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
            
            
        }
    }
    // UITabBarControllerDelegate method to detect the selected tab bar item
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        if let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController),
//           let customTabBar = self.tabBar as? CustomTabBar {
//           
//            customTabBar.updateLinePosition(selectedIndex: selectedIndex)
//            
//        }
//    }

}
