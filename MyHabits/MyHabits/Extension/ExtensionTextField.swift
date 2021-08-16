//
//  ExtensionTextField.swift
//  MyHabits
//
//  Created by beshssg on 01.08.2021.
//

import UIKit

extension UITextField {
    func indentText(size: CGFloat) {
        self.leftView = UIView(frame: CGRect(x: frame.minX, y: frame.minY, width: size, height: frame.height))
        self.leftViewMode = .always
    }
}
