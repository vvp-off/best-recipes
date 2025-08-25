//
//  OnboardingViewController.swift
//  Best Recipes
//
//  Created by Иван Семенов on 15.08.2025.
//

import UIKit

final class OnboardingViewController: UIViewController {
    // MARK: - Private properties
    private lazy var nextButton: CustomButton = {
        CustomButton(customTitle: "Continue")
    }()
    
    private lazy var skipButton: UIButton = {
        $0.setTitle("Skip", for: .normal)
        $0.titleLabel?.font = .poppinsRegular(size: 13)
        $0.setTitleColor(.white, for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton(type: .system))
    
    private lazy var scrollView: UIScrollView = {
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIScrollView())
    
    private lazy var titleLabel: UILabel = {
        $0.attributedText = colored("Recipes from all over the World", highlight: "over the World")
        $0.textColor = .white
        $0.font = .poppinsBold(size: 40)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var pageControl: UIPageControl = {
        let p = UIPageControl()
        p.numberOfPages = backgrounds.count
        p.preferredIndicatorImage = UIImage(named: "RectangleSelect")
        p.pageIndicatorTintColor = .gray
        p.currentPageIndicatorTintColor = .primary
        p.translatesAutoresizingMaskIntoConstraints = false
        /// Scroll by tap on pageControl
        p.addAction(UIAction { [weak self] _ in self?.goToPage(p.currentPage, animated: true) }, for: .valueChanged)
        return p
    }()
    
    /// container for pages inside scrollView
    private let contentView = UIView()
    
    //MARK: Data
    private let backgrounds: [UIImage?] = [
        UIImage(named: "onboarding2"),
        UIImage(named: "onboarding3"),
        UIImage(named: "onboarding4")
    ]
    private var imageViews: [UIImageView] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupHierarchy()
        setupConstraints()
        buildPages()
        updateControls(for: 0)
    }
    
    // MARK: - Layout
    private func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        view.addSubview(skipButton)
        view.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        scrollView.pinEdges(to: view)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            pageControl.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -34),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            nextButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            nextButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            nextButton.heightAnchor.constraint(equalToConstant: 46),
            
            skipButton.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 10),
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleLabel.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 53),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -74)
        ])
    }
    
    private func buildPages() {
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews.removeAll()
        
        var previous: UIView? = nil
        
        for (i, img) in backgrounds.enumerated() {
            let iv = UIImageView(image: img)
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            iv.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(iv)
            
            NSLayoutConstraint.activate([
                iv.topAnchor.constraint(equalTo: contentView.topAnchor),
                iv.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                iv.widthAnchor.constraint(equalTo: view.widthAnchor),
                iv.heightAnchor.constraint(equalTo: view.heightAnchor),
                
                iv.leadingAnchor.constraint(equalTo: previous?.trailingAnchor ?? contentView.leadingAnchor)
            ])
            
            if i == backgrounds.count - 1 {
                iv.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            }
            
            previous = iv
            imageViews.append(iv)
        }
        view.layoutIfNeeded()
    }
    
    // MARK: - Private
    private func colored(_ text: String, highlight: String) -> NSAttributedString {
        let s = NSMutableAttributedString(string: text)
        s.setColorForText(highlight, with: .accentOnboarding)
        return s
    }
    
    private func goToPage(_ page: Int, animated: Bool) {
        let offsetX = view.bounds.width * CGFloat(page)
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animated)
    }
    
    /// Updates the text, visibility of Skip and action of the Next/Start button
    private func updateControls(for page: Int) {
        pageControl.currentPage = page
        
        nextButton.removeTarget(nil, action: nil, for: .allEvents)
        skipButton.removeTarget(nil, action: nil, for: .allEvents)
        
        switch page {
        case 0:
            titleLabel.attributedText = colored("Recipes from all over the World", highlight: "over the World")
            skipButton.isHidden = false
            nextButton.setTitle("Continue", for: .normal)
            nextButton.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                self.goToPage(1, animated: true)
            }, for: .touchUpInside)
            
        case 1:
            titleLabel.attributedText = colored("Recipes with each and every detail", highlight: "each and every detail")
            skipButton.isHidden = false
            nextButton.setTitle("Continue", for: .normal)
            nextButton.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                self.goToPage(2, animated: true)
            }, for: .touchUpInside)
            
        default:
            titleLabel.attributedText = colored("Cook it now or save it for later", highlight: "save it for later")
            skipButton.isHidden = true
            nextButton.setTitle("Start Cooking", for: .normal)
            nextButton.addAction(UIAction { [weak self] _ in
                self?.finishOnboarding()
            }, for: .touchUpInside)
        }
        skipButton.addAction(UIAction { [weak self] _ in self?.finishOnboarding() }, for: .touchUpInside)
    }
    
    private func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: AppKeys.didShowOnboarding)
        
        let assembly = Assembly()
        let tabBar = assembly.createTabBar()
        let mainRouter: MainRouterProtocol = assembly.createMainRouter()
        
        let savedRecipes = UINavigationController(rootViewController: assembly.createFavoriteModule())
        let createRecipes = UINavigationController(rootViewController: assembly.createRecipeModule())
        let myProfile = UINavigationController(rootViewController: assembly.myProfileModule())
        
        let mockVC = UIViewController()
        mockVC.tabBarItem.image = UIImage(named: "TabBarItem3")

        tabBar.viewControllers = [
            mainRouter.navigationController,
            savedRecipes,
            createRecipes,
            mockVC,         //search
            myProfile
        ]

        let nav = UINavigationController(rootViewController: tabBar)
        nav.setNavigationBarHidden(true, animated: false)
        
        if let scene = view.window?.windowScene {
            scene.keyWindow?.rootViewController = nav
        } else if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            scene.keyWindow?.rootViewController = nav
        }
    }
}

// MARK: - UIScrollViewDelegate
extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = 0
        let page = Int(round(scrollView.contentOffset.x / max(view.bounds.width, 1)))
        updateControls(for: min(max(page, 0), backgrounds.count - 1))
    }
}
