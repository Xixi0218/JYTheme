//
//  KYResultBuilder.swift
//  KYStack
//
//  Created by keyon on 2022/10/25.
//

import Foundation
import UIKit

@resultBuilder
struct KYResultBuilder<T> {
    static func buildBlock(_ components: [T]...) -> [T] {
        return components.flatMap{ $0 }
    }

    static func buildOptional(_ component: [T]?) -> [T] {
        return component ?? []
    }

    static func buildExpression(_ expression: T) -> [T] {
        return [expression]
    }

    static func buildExpression(_ expression: [T]) -> [T] {
        return expression
    }

    static func buildArray(_ components: [[T]]) -> [T] {
        return components.flatMap{ $0 }
    }

    static func buildEither(first component: [T]) -> [T] {
        return component
    }

    static func buildEither(second component: [T]) -> [T] {
        return component
    }

}

typealias LocalizerStringBuilder = KYResultBuilder<String>
typealias LocalizerAttributeBuilder = KYResultBuilder<NSAttributedString>

public struct KYLocalizerStringBuilder {
    @LocalizerStringBuilder var content: () -> [String]

    var string: String {
        return content().reduce(into: String(), { partialResult, next in
            partialResult.append(next)
        })
    }
}

public struct KYLocalizerAttributeBuilder {
    @LocalizerAttributeBuilder var content: () -> [NSAttributedString]

    var attributed: NSMutableAttributedString {
        return content().reduce(into: NSMutableAttributedString(), { partialResult, next in
            partialResult.append(next)
        })
    }
}

