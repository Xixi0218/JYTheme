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

    public func currentThemeColor() -> UIColor {
        KYTheme.current == .day ? lightColor : darkColor
    }
}
