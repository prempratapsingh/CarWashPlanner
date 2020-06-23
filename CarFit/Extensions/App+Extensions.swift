//
//  App+Extensions.swift
//  Calendar
//
//Test Project

import UIKit

//MARK:- Navigation bar clear
extension UINavigationBar {
    
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
    
}
