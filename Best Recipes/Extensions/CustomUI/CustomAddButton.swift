//
//  CustomAddButton.swift
//  Best Recipes
//
//  Created by Иван Семенов on 14.08.2025.
//

import UIKit

final class CustomAddButton: UIButton {
    ///Icon save/delete
    lazy var bookmarkImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    convenience init(isChecked: Bool) {
        self.init(frame: .zero)
        bookmarkImageView.image = isChecked ? UIImage(named: "deleteRecipe") : UIImage(named: "savedRecipe")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 17.5
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(bookmarkImageView)
        
        NSLayoutConstraint.activate([
            bookmarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            bookmarkImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bookmarkImageView.heightAnchor.constraint(equalToConstant: 19),
            bookmarkImageView.widthAnchor.constraint(equalToConstant: 15),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggle(with isChecked: Bool) {
        bookmarkImageView.image = isChecked ? UIImage(named: "deleteRecipe") : UIImage(named: "savedRecipe")
    }
}
