//
//  UIFont+Ext.swift
//  Best Recipes
//
//  Created by Иван Семенов on 15.08.2025.
//

import UIKit

extension UIFont {
    static func poppinsRegular(size: CGFloat) -> UIFont? {
        return UIFont(name: "Poppins-Regular", size: size)
    }
    static func poppinsBold(size: CGFloat) -> UIFont? {
        return UIFont(name: "Poppins-Bold", size: size)
    }
    static func poppinsSemiBold(size: CGFloat) -> UIFont? {
        return UIFont(name: "Poppins-SemiBold", size: size)
    }
}
