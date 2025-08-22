//
//  TabBarViewController.swift
//  Best Recipes
//
//  Created by VP on 12.08.2025.
//


import UIKit

final class TabBarViewController: UITabBarController {
    private lazy var mockViewControllers = getMockVC()
    
    private lazy var centerButton: UIButton = {
        let centerButton = UIButton()
        centerButton.backgroundColor = UIColor(red: 0.886, green: 0.243, blue: 0.243, alpha: 1)
        centerButton.layer.cornerRadius = 27
        centerButton.setImage(UIImage(named: "TabBarItemPlus"), for: .normal)
        centerButton.tintColor = .black
        centerButton.layer.shadowColor = UIColor.black.cgColor
        centerButton.layer.shadowOpacity = 0.2
        centerButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        centerButton.layer.shadowRadius = 10
        centerButton.addTarget(nil,action: #selector(centerButtonTapped),for: .touchUpInside)
        return centerButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setupCenterButton()
        addTabBarShadow()
    }
    
//  MARK: - CenterButton setup and format
        private func setupCenterButton() {
            centerButton.translatesAutoresizingMaskIntoConstraints = false
            tabBar.addSubview(centerButton)
            
            NSLayoutConstraint.activate([
                centerButton.heightAnchor.constraint(equalToConstant: 54),
                centerButton.widthAnchor.constraint(equalToConstant: 54),
                centerButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
                centerButton.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -30)
            ])
        }
        
    @objc private func centerButtonTapped() {
        selectedIndex = 2
    }

    
//  MARK: - TabBarItem and ViewControllers setup
    private func getMockVC() -> [UIViewController] {
        let firstVC = UIViewController()
        firstVC.view.backgroundColor = .black
        let secondVC = FavoriteViewController.create() 
        secondVC.view.backgroundColor = .white
        let thirdVC = CreateRecipeViewController()
        thirdVC.view.backgroundColor = .white
        let forVC = UIViewController()
        forVC.view.backgroundColor = .darkGray
        let fiveVC = MyProfileViewController()
        fiveVC.view.backgroundColor = .white
        let mockViewControllers = [firstVC, secondVC, thirdVC, forVC, fiveVC]
        return mockViewControllers
    }
    
    private func generateTabBar() {
        viewControllers = [
            generateVC(
                viewController: UINavigationController(rootViewController:
                mockViewControllers[0]),
                image: UIImage(named: "TabBarItem1")
            ),
            
            generateVC(
                viewController: UINavigationController(rootViewController: mockViewControllers[1]),
                image: UIImage(named: "TabBarItem2")),
            
            generateVC(
                viewController: UINavigationController(rootViewController: mockViewControllers[2]),
                image: nil),
            
            generateVC(viewController: UINavigationController(rootViewController: mockViewControllers[3]),
                image: UIImage(named: "TabBarItem3")),
            
            generateVC(
                viewController: UINavigationController(rootViewController: mockViewControllers[4]),
                image: UIImage(named: "TabBarItem4")
            )
        ]
        self.tabBar.tintColor = .red
        
    }
    
    private func generateVC(viewController: UIViewController, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.image = image
        return viewController
    }
//  MARK: - Setting TabBar
    private func addTabBarShadow() {
        tabBar.layer.shadowColor = UIColor.gray.cgColor
        tabBar.layer.shadowRadius = 20
        tabBar.layer.masksToBounds = false
        tabBar.layer.shadowOpacity = 0.10
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .white
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
    }
}

//  MARK: - UITabBarControllerDelegate
extension TabBarViewController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        let selectedIndex = self.tabBar.items?.firstIndex(of: item)
        }
    }

