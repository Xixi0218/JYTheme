//
//  KYCompatible.swift
//  JYRouter
//
//  Created by keyon on 2022/11/3.
//  Copyright © 2022 Keyon. All rights reserved.
//

import Foundation

public struct KYReactive<Base> {
    /// Base object to extend.
    public let base: Base

    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
}

/// A type that has reactive extensions.
public protocol KYCompatible {
    /// Extended type
    associatedtype ReactiveBase

    /// Reactive extensions.
    static var ky: KYReactive<ReactiveBase>.Type { get set }

    /// Reactive extensions.
    var ky: KYReactive<ReactiveBase> { get set }
}

extension KYCompatible {
    /// Reactive extensions.
    public static var ky: KYReactive<Self>.Type {
        get { KYReactive<Self>.self }
        // this enables using Reactive to "mutate" base type
        // swiftlint:disable:next unused_setter_value
        set { }
    }

    /// Reactive extensions.
    public var ky: KYReactive<Self> {
        get { KYReactive(self) }
        // this enables using Reactive to "mutate" base object
        // swiftlint:disable:next unused_setter_value
        set { }
    }
}

extension NSObject: KYCompatible { }
