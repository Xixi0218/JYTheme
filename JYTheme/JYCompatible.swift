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
public enum JYThemeStyle: String {
    /// 白天模式
    case day = "Day"
    /// 黑夜模式
    case night = "Night"
}

// MARK: 主题管理类
public struct JYTheme {
    
    static private(set) var current: JYThemeStyle = .day
    
    /// 当前主题
    fileprivate static var observer: BehaviorRelay<JYThemeStyle> = BehaviorRelay(value: current)
    
    /// 通过指定主题样式更新主题
    /// - Parameter style: 指定更新的主题样式
    public static func update(_ style: JYThemeStyle) {
        current = style
        observer.accept(style)
    }
    
}

@dynamicMemberLookup
public class JYThemeReactive<Base: JYThemeReactiveCompatible> {
    
    private unowned let base: Base
    
    public private(set) var bmDisposedBag: DisposeBag = DisposeBag()
    
    public init(_ base: Base) {
        self.base = base
    }
    
    public subscript(dynamicMember keyPath: ReferenceWritableKeyPath<Base, UIColor>) -> JYColor {
        set {
            JYTheme.observer.subscribe { [weak self] style in
                self?.base[keyPath: keyPath] = style == .day ? newValue.lightColor : newValue.darkColor
            } onError: { error in
            }.disposed(by: bmDisposedBag)
        }
        get {
            fatalError("不能调用")
        }
    }
    
    public subscript(dynamicMember keyPath: ReferenceWritableKeyPath<Base, UIColor?>) -> JYColor {
        set {
            setColor(color: newValue) { [weak self] color in
                self?.base[keyPath: keyPath] = color
            }
        }
        get {
            fatalError("不能调用")
        }
    }
    
    public func setColor(color: JYColor, setter: @escaping (UIColor) -> Void) {
        JYTheme.observer.subscribe { style in
            setter(style == .day ? color.lightColor : color.darkColor)
        } onError: { error in
        }.disposed(by: bmDisposedBag)
    }
}

fileprivate var JYThemeReactiveKey = "JYThemeReactiveKey"

public protocol JYThemeReactiveCompatible: AnyObject {}

public extension JYThemeReactiveCompatible {
    
    var th: JYThemeReactive<Self> {
        set {
            objc_setAssociatedObject(self, &JYThemeReactiveKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let th = objc_getAssociatedObject(self, &JYThemeReactiveKey) as? JYThemeReactive<Self> {
                return th
            }
            
            let th = JYThemeReactive(self)
            objc_setAssociatedObject(self, &JYThemeReactiveKey, th, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return th
        }
    }
}

extension UIView: JYThemeReactiveCompatible { }

extension JYThemeReactive where Base: UIButton {
    
    func setTitleColor(_ color: JYColor, for state: UIControl.State) {
        setColor(color: color) { [weak self] in
            self?.base.setTitleColor($0, for: state)
        }
    }
    
}
