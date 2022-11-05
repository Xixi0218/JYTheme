//
//  ReactiveLocalization.swift
//  Localization
//
//  Created by octree on 2022/5/28.
//
//  Copyright (c) 2022 Octree <fouljz@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Combine
import UIKit
import RxSwift

/// Uses ``ReactiveLocalization`` proxy as  customization point for constrained protocol extensions.
@dynamicMemberLookup
public class KYReactiveLocalization<Base: AnyObject> {
    public unowned let base: Base
    private var bag = DisposeBag()
    /// Creates extensions with base object.
    /// - Parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }

    public subscript(dynamicMember keyPath: ReferenceWritableKeyPath<Base, String>) -> KYLocalizerStringBuilder {
        set {
            subscribe { [weak self] in
                self?.base[keyPath: keyPath] = newValue.string
            }
        }
        get {
            fatalError("不能调用")
        }
    }

    public subscript(dynamicMember keyPath: ReferenceWritableKeyPath<Base, String?>) -> KYLocalizerStringBuilder {
        set {
            subscribe { [weak self] in
                self?.base[keyPath: keyPath] = newValue.string
            }
        }
        get {
            fatalError("不能调用")
        }
    }

    public subscript(dynamicMember keyPath: ReferenceWritableKeyPath<Base, NSAttributedString>) -> KYLocalizerAttributeBuilder {
        set {
            subscribe { [weak self] in
                self?.base[keyPath: keyPath] = newValue.attributed
            }
        }
        get {
            fatalError("不能调用")
        }
    }

    public subscript(dynamicMember keyPath: ReferenceWritableKeyPath<Base, NSAttributedString?>) -> KYLocalizerAttributeBuilder {
        set {
            subscribe { [weak self] in
                self?.base[keyPath: keyPath] = newValue.attributed
            }
        }
        get {
            fatalError("不能调用")
        }
    }

    func subscribe(action: @escaping () -> Void) {
        bag = DisposeBag()
        Observable.combineLatest(KYLocalizationPreference.languageChangeSubject, KYTheme.observer)
            .subscribe { _ in
                action()
            }.disposed(by: bag)
    }
    
}

private enum KYLocalizationAssociatedKey {
    static var reactive: String = "LocalizationReactiveAssociatedKey"
}

///  A type that has reactive localization extensions.
public protocol KYReactiveLocalizationCompatible: AnyObject {
    associatedtype CompatibleType: AnyObject
    var l10n: KYReactiveLocalization<CompatibleType> { get }
}

public extension KYReactiveLocalizationCompatible {
    var l10n: KYReactiveLocalization<Self> {
        if let localize = objc_getAssociatedObject(self, &KYLocalizationAssociatedKey.reactive) as? KYReactiveLocalization<Self> {
            return localize
        }

        let localize = KYReactiveLocalization(self)
        objc_setAssociatedObject(self, &KYLocalizationAssociatedKey.reactive, localize, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return localize
    }
}
