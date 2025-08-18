//
//  UIView+Ext.swift
//  Best Recipes
//
//  Created by Иван Семенов on 15.08.2025.
//

import UIKit

extension UIView {
    func pinEdges(to other: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: other.topAnchor),
            leadingAnchor.constraint(equalTo: other.leadingAnchor),
            trailingAnchor.constraint(equalTo: other.trailingAnchor),
            bottomAnchor.constraint(equalTo: other.bottomAnchor)
        ])
    }
}
