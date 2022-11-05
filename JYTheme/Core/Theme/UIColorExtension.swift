//
//  UIColorExtension.swift
//  JYTheme
//
//  Created by keyon on 2022/4/23.
//

import Foundation
import UIKit

extension KYReactive where Base == UIColor {

    /// 以一个16进制字符串和一个透明度值创建一个颜色
    ///
    /// - Parameters:
    ///   - hex: 一个16进制字符串 (例如: "EDE7F6", "0xEDE7F6", "#EDE7F6", "#0ff", "0xF0F")
    ///   - alpha: 一个可选的透明度值 (默认是 1)
    init?(hex: String, alpha: CGFloat = 1.0) {
        var string = ""
        if hex.lowercased().hasPrefix("0x") {
            string = hex.replacingOccurrences(of: "0x", with: "")
        } else if hex.hasPrefix("#") {
            string = hex.replacingOccurrences(of: "#", with: "")
        } else {
            string = hex
        }
        if string.count == 3 {
            var str = ""
            string.forEach { str.append(String(repeating: String($0), count: 2)) }
            string = str
        }
        guard let hexValue = Int(string, radix: 16) else { return nil }
        let red = (hexValue >> 16) & 0xff
        let green = (hexValue >> 8) & 0xff
        let blue = hexValue & 0xff
        base = UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }

    /// 返回颜色的十六进制字符串
    var hex: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        base.getRed(&r, green: &g, blue: &b, alpha: &a)

        if a == 1.0 {
            let rInt = Int(r * 255) << 16
            let gInt = Int(g * 255) << 8
            let bInt = Int(b * 255)
            let rgb = rInt | gInt | bInt
            return String(format:"#%06x", rgb)
        } else {
            let rInt = Int(r * 255) << 24
            let gInt = Int(g * 255) << 16
            let bInt = Int(b * 255) << 8
            let aInt = Int(a * 255)
            let rgba = rInt | gInt | bInt | aInt
            return String(format:"#%08x", rgba)
        }
    }

}
