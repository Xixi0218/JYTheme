//
//  KYColor.swift
//  JYTheme
//
//  Created by keyon on 2022/4/23.
//

import UIKit

public struct KYColor {
    var darkColor: UIColor
    var lightColor: UIColor

    var currentThemeColor: UIColor {
        return KYTheme.current == .day ? lightColor : darkColor
    }
}
