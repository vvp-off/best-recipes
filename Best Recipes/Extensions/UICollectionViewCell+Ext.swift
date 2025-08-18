//
//  UICollectionViewCell+Ext.swift
//  Best Recipes
//
//  Created by Иван Семенов on 14.08.2025.
//

import UIKit

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
