//
//  ExtensionUILabel.swift
//  MyHabits
//
//  Created by beshssg on 01.08.2021.
//

import UIKit

extension UILabel {
    func applyTitleStyle() {
        self.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        self.textColor = .black
    }
    
    func applyHeadlineStyle() {
        self.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        self.textColor = Styles.blueColor
    }
    
    func applyBodyStyle() {
        self.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        self.textColor = .black
    }
    
    func applyFootnoteStyle() {
        self.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        self.textColor = .black
    }
    
    func applyStatusFootnoteStyle() {
        self.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        self.textColor = Styles.mediumGrayColor
    }
    
    func applyCaptionStyle() {
        self.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        self.textColor = Styles.lightGrayColor
    }
}
