//
//  BRSearchField.swift
//  Best Recipes
//
//  Created by Дарья Балацун on 12.08.25.
//

import UIKit

class BRSearchField: UITextField {
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func  setupLayout() {
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        self.font = .systemFont(ofSize: 16)
        self.attributedPlaceholder = NSAttributedString(string: "Search recipes", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        let imageView = UIImageView(frame: CGRect(x: 20, y: 2, width: 20, height: 20))
        imageView.image = UIImage(resource: .search)
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 22))
        leftPaddingView.addSubview(imageView)
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: self.frame.height))
        self.leftView = leftPaddingView
        self.leftViewMode = .always
        self.rightView = rightPaddingView
        self.rightViewMode = .always
    }
}
                        

