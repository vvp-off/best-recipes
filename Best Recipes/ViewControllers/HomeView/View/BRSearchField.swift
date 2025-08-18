//
//  BRSearchField.swift
//  Best Recipes
//
//  Created by Дарья Балацун on 12.08.25.
//

import UIKit

class BRSearchField: UITextField, UITextFieldDelegate {
    
    var onTap: (() -> Void)?
    var onCancel: (() -> Void)?
    
    private var cancelButton: UIButton?
    
    init() {
        super.init(frame: .zero)
        setupLayout()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.delegate = self
    }
    
    @objc private func handleTap() {
        onTap?()
    }
    
    @objc private func textFieldDidChange() {
           
       }
        
    func setCancelButtonVisible(_ visible: Bool) {
        if visible {
            let cancelButton = UIButton(type: .system)
            cancelButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            cancelButton.tintColor = .lightGray
            cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
            
            let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: self.frame.height))
            cancelButton.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
            rightPaddingView.addSubview(cancelButton)
            
            self.rightView = rightPaddingView
            self.rightViewMode = .always
            self.cancelButton = cancelButton
        } else {
            self.rightView = nil
        }
    }
    
    @objc private func cancelButtonTapped() {
            onCancel?()
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
                        
extension BRSearchField {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

