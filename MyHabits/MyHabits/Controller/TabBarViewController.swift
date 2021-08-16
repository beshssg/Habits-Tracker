//
//  TabBarViewController.swift
//  MyHabits
//
//  Created by beshssg on 02.08.2021.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: - UIProperties:
    let habitsViewController = UINavigationController(rootViewController: HabitsViewController())
    let infoViewController = UINavigationController(rootViewController: InfoViewController())
    
    let habitsBarItem: UITabBarItem = {
        let tabBar = UITabBarItem()
        tabBar.image = UIImage(systemName: "rectangle.grid.1x2.fill")
        tabBar.title = "Привычки"
        tabBar.standardAppearance?.selectionIndicatorTintColor = Styles.purpleColor
        return tabBar
    }()
    
    let infoBarItem: UITabBarItem = {
        let tabBar = UITabBarItem()
        tabBar.image = UIImage(systemName: "info.circle.fill")
        tabBar.title = "Информация"
        tabBar.standardAppearance?.selectionIndicatorTintColor = Styles.purpleColor
        return tabBar
    }()
    
    // MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    // MARK: - Methods:
    func setupTabBar() {
        habitsViewController.tabBarItem = habitsBarItem
        infoViewController.tabBarItem = infoBarItem
        
        let tabBarList = [habitsViewController, infoViewController]
        
        viewControllers = tabBarList
        tabBar.tintColor = .purple
    }
}
