//
//  BonerConfig.swift
//  Boner
//
//  Created by Chris on 17/4/4.
//  Copyright © 2017年 Chris. All rights reserved.
//

import UIKit
import Foundation

public enum LoginState: String, CustomStringConvertible {
    case online = "online"
    case offline = "offline"
    
    public var description: String {
        return self.rawValue
    }
}

class BonerConfig {
    
    static let appGroupID: String = "group.bonerSharedDefaults"
    static let BonerFont: String = "AvenirNext-Regular"
    static let authActionURL = "http://10.0.0.55:801/include/auth_action.php"
    
    static let ScreenWidth: CGFloat = UIScreen.main.bounds.width
    static let ScreenHeight: CGFloat = UIScreen.main.bounds.height
    
}
