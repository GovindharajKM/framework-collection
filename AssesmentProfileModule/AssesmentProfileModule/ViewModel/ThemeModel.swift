//
//  ThemeModel.swift
//  Assesment
//
//  Created by Govindharaj Murugan on 18/01/21.
//

import Foundation
import UIKit

enum Theme {
    case light
    case dark
}

public class ThemeModel {
    
    static var isDarkModeEnabled = false
    
    static var bgColor: UIColor = .white
    static var textColor: UIColor = .black
    static var viewBgColor: UIColor = .white
    static var segmentBGColor: UIColor = .lightGray
    
    
    static func setUpTheme() {
        if let isDarkMode = UserDefaults.standard.value(forKey: "isDarkModeEnabled") as? Bool {
            if isDarkMode {
                ThemeModel.changeTheme(.dark)
            } else {
                ThemeModel.changeTheme(.light)
            }
        }
    }
    
    static func changeTheme(_ theme : Theme) {
        
        switch theme {
        case .light:
            self.bgColor = .white
            self.textColor = .black
            self.viewBgColor = .white
            self.segmentBGColor = .lightGray
            self.isDarkModeEnabled = false
            break
        case .dark:
            self.bgColor = .black
            self.textColor = .white
            self.viewBgColor = .darkGray
            self.segmentBGColor = .lightGray
            self.isDarkModeEnabled = true
            break
        }
        UserDefaults.standard.setValue(self.isDarkModeEnabled, forKey: "isDarkModeEnabled")
    }
}
