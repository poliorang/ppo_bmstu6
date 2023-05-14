//
//  TabBarViewController.swift
//  rfpr
//
//  Created by poliorang on 01.05.2023.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        setupViewControllers()
    }

    func setupViewControllers() {
        viewControllers = [createNavigationsController(for: CompetitionViewController(),
                                   title: NSLocalizedString("Соревнования", comment: ""),
                                   image: UIImage(systemName: "person")!),
                           createNavigationsController(for: LootViewController(),
                                   title: NSLocalizedString("Улов", comment: ""),
                                   image: UIImage(systemName: "person")!)
                           ]
        
    }
    
    func createNavigationsController(for rootViewController: UIViewController,
                                         title: String, image: UIImage) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        navigationController.navigationBar.prefersLargeTitles = true
        
        rootViewController.navigationItem.title = title
        
        return navigationController
    }
}
