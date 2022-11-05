//
//  AttributedStringExtension.swift
//  
//
//  Created by keyon on 2022/6/27.
//

import UIKit

extension String: KYCompatible {}

extension KYReactive where Base == String {
    func foregroundColor(_ color: UIColor) -> NSAttributedString {
        attributed.ky.apply([.foregroundColor: color])
    }

    func background(_ color: UIColor) -> NSAttributedString {
        attributed.ky.apply([.backgroundColor: color])
    }

    func underline(_ color: UIColor, style: NSUnderlineStyle) -> NSAttributedString {
        attributed.ky.apply([.underlineColor: color, .underlineStyle: style.rawValue])
    }

    func stroke(_ color: UIColor, width: Double) -> NSAttributedString {
        attributed.ky.apply([.strokeColor: color, .strokeWidth: width])
    }

    func strikethroughColor(_ color: UIColor, style: NSUnderlineStyle) -> NSAttributedString {
        attributed.ky.apply([.strikethroughColor: color, .strikethroughStyle: style.rawValue])
    }

    func paragraphStyle(_ style: NSMutableParagraphStyle) -> NSAttributedString {
        attributed.ky.apply([.paragraphStyle: style])
    }

    func baselineOffset(_ baselineOffset: Double) -> NSAttributedString {
        attributed.ky.apply([.baselineOffset: baselineOffset])
    }

    func font(_ font: UIFont) -> NSAttributedString {
        attributed.ky.apply([.font: font])
    }

    func shadow(_ shadow: NSShadow) -> NSAttributedString {
        attributed.ky.apply([.shadow:shadow])
    }

    var attributed: NSAttributedString {
        NSAttributedString(string: base)
    }
}

extension KYReactive where Base == NSAttributedString  {

    func foregroundColor(_ color: UIColor) -> NSAttributedString {
        apply([.foregroundColor: color])
    }

    func background(_ color: UIColor) -> NSAttributedString {
        apply([.backgroundColor: color])
    }

    func underline(_ color: UIColor, style: NSUnderlineStyle) -> NSAttributedString {
        apply([.underlineColor: color, .underlineStyle: style.rawValue])
    }

    func stroke(_ color: UIColor, width: Double) -> NSAttributedString {
        apply([.strokeColor: color, .strokeWidth: width])
    }

    func strikethroughColor(_ color: UIColor, style: NSUnderlineStyle) -> NSAttributedString {
        apply([.strikethroughColor: color, .strikethroughStyle: style.rawValue])
    }

    func paragraphStyle(_ style: NSMutableParagraphStyle) -> NSAttributedString {
        apply([.paragraphStyle: style])
    }

    func baselineOffset(_ baselineOffset: Double) -> NSAttributedString {
        apply([.baselineOffset: baselineOffset])
    }

    func font(_ font: UIFont) -> NSAttributedString {
        apply([.font: font])
    }

    func shadow(_ shadow: NSShadow) -> NSAttributedString {
        apply([.shadow:shadow])
    }

    func apply(_ attributes: [NSAttributedString.Key:Any]) -> NSAttributedString {
        let mutable = NSMutableAttributedString(string: base.string, attributes: base.attributes(at: 0, effectiveRange: nil))
        mutable.addAttributes(attributes, range: NSRange(location: 0, length: base.length))
        return mutable
    }
}
