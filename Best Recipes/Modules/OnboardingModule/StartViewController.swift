//
//  StartViewController.swift
//  Best Recipes
//
//  Created by Иван Семенов on 15.08.2025.
//

import UIKit

final class StartViewController: UIViewController {
    // MARK: - Private properties
    private lazy var backgroundView: UIImageView = {
        $0.image = UIImage(named: "onboarding1")
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private lazy var titleLabel: UILabel = {
        $0.text = "Best Recipe"
        $0.font = .poppinsBold(size: 56)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var descriptionLabel: UILabel = {
        $0.text = "Find best recipes for cooking"
        $0.font = .poppinsRegular(size: 16)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        let s = NSMutableAttributedString()
        
        let att = NSTextAttachment()
        att.image = UIImage(named: "starIcon")
        att.bounds = CGRect(x: 0, y: -2, width: 16, height: 16)
        s.append(NSAttributedString(attachment: att))
        s.append(NSAttributedString(string: " 100k+ Premium recipes"))
        s.setFontForText("100k+", with: .poppinsBold(size: 16)!)
        
        label.attributedText = s
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var startButton: CustomButton = {
        let button = CustomButton(customTitle: "Get Started")
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            let vc = OnboardingViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    //MARK: LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        view.addSubview(backgroundView)
        view.addSubview(startButton)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(topLabel)
    }
    
    //MARK: Layout
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -8),
            titleLabel.widthAnchor.constraint(equalToConstant: 320),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -48),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 320),
            
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            startButton.widthAnchor.constraint(equalToConstant: 156),
            startButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
}

extension NSMutableAttributedString {
    func setFontForText(_ textToFind: String?, with font: UIFont) {
        let range:NSRange?
        
        if let text = textToFind {
            range = self.mutableString.range(of: text, options: .caseInsensitive)
        } else {
            range = NSMakeRange(0, self.length)
        }
        
        if range!.location != NSNotFound {
            addAttribute(NSAttributedString.Key.font, value: font, range: range!)
        }
    }
}
