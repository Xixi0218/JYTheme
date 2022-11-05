//
//  LocalizationPreference.swift
//  UIKitLab
//
//  Created by Octree on 2022/5/28.
//

import Combine
import Foundation
import RxSwift
import RxRelay

/// In app language preference
public enum KYLocalizationPreference {
    /// Dependent on the system preferences
    case followSystem
    /// The in app language preference
    case specified(Language)
}

public extension KYLocalizationPreference {
    /// The in app preferred language
    private static var specifiedLanguage: Language? = UserDefaults.standard.string(forKey: "SpecifiedCurrentLanguageKey")
        .map { Language(rawValue: $0) } {
        didSet {
            UserDefaults.standard.set(specifiedLanguage?.rawValue, forKey: "SpecifiedCurrentLanguageKey")
        }
    }

    /// A publisher that emits event while changing the language preference.
    static var languageChangeSubject: BehaviorSubject<KYLocalizationPreference> = .init(value: current)

    /// Current language preference
    static var current: Self {
        get {
            specifiedLanguage.map { .specified($0) } ?? .followSystem
        }
        set {
            defer { languageChangeSubject.onNext(current) }
            guard case let .specified(lang) = newValue else {
                specifiedLanguage = nil
                return
            }
            specifiedLanguage = lang
        }
    }
}
