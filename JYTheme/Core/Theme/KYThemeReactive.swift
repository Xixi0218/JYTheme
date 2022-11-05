//
//  JYCompatible.swift
//  JYTheme
//
//  Created by keyon on 2022/4/23.
//

import Foundation
import RxSwift
import RxRelay

// MARK: 主题模式枚举
public enum KYThemeStyle: String {
    /// 白天模式
    case day = "Day"
    /// 黑夜模式
    case night = "Night"
}

// MARK: 主题管理类
public struct KYTheme {
    
    static private(set) var current: KYThemeStyle = .day
    
    /// 当前主题
    static var observer: BehaviorRelay<KYThemeStyle> = BehaviorRelay(value: current)
    
    /// 通过指定主题样式更新主题
    /// - Parameter style: 指定更新的主题样式
    public static func update(_ style: KYThemeStyle) {
        current = style
        observer.accept(style)
    }
    
}

@dynamicMemberLookup
public class KYThemeReactive<Base: KYThemeReactiveCompatible> {
    
    private unowned let base: Base
    
    public private(set) var bag: DisposeBag = DisposeBag()
    
    public init(_ base: Base) {
        self.base = base
    }
    
    public subscript(dynamicMember keyPath: ReferenceWritableKeyPath<Base, UIColor>) -> KYColor {
        set {
            setColor(color: newValue) { [weak self] color in
                self?.base[keyPath: keyPath] = color
            }
        }
        get {
            fatalError("不能调用")
        }
    }
    
    public subscript(dynamicMember keyPath: ReferenceWritableKeyPath<Base, UIColor?>) -> KYColor {
        set {
            setColor(color: newValue) { [weak self] color in
                self?.base[keyPath: keyPath] = color
            }
        }
        get {
            fatalError("不能调用")
        }
    }
    
    public func setColor(color: KYColor, setter: @escaping (UIColor) -> Void) {
        KYTheme.observer.subscribe { style in
            setter(style == .day ? color.lightColor : color.darkColor)
        } onError: { error in
        }.disposed(by: bag)
    }
}

fileprivate var KYThemeReactiveKey = "KYThemeReactiveKey"

public protocol KYThemeReactiveCompatible: AnyObject {}

public extension KYThemeReactiveCompatible {
    
    var th: KYThemeReactive<Self> {
        set {
            objc_setAssociatedObject(self, &KYThemeReactiveKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let th = objc_getAssociatedObject(self, &KYThemeReactiveKey) as? KYThemeReactive<Self> {
                return th
            }
            
            let th = KYThemeReactive(self)
            objc_setAssociatedObject(self, &KYThemeReactiveKey, th, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return th
        }
    }
}

extension UIView: KYThemeReactiveCompatible { }

extension KYThemeReactive where Base: UIButton {
    
    func setTitleColor(_ color: KYColor, for state: UIControl.State) {
        setColor(color: color) { [weak self] in
            self?.base.setTitleColor($0, for: state)
        }
    }
    
}
