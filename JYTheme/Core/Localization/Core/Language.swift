//
//  Language.swift
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

import Foundation

/// A model that represents a specific language
/// The rawValue is the language code
public struct Language: RawRepresentable, Equatable {
    public typealias RawValue = String
    public var rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

// MARK: - ExpressibleByStringLiteral
extension Language: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        rawValue = value
    }
}

// MARK: - Codable
extension Language: Codable {
    public func encode(to encoder: Encoder) throws {
        var single = encoder.singleValueContainer()
        try single.encode(rawValue)
    }

    public init(from decoder: Decoder) throws {
        let single = try decoder.singleValueContainer()
        rawValue = try single.decode(String.self)
    }
}

// MARK: - Definitions
public extension Language {
    static var arabic: Language { "ar" }
    static var catalan: Language { "ca" }
    enum Chinese {
        public static var simplified: Language { "zh-Hans" }
        public static var traditional: Language { "zh-Hant" }
        public static var hongkong: Language { "zh-HK" }
    }

    static var croatian: Language { "hr" }
    static var czech: Language { "cs" }
    static var danish: Language { "da" }
    static var dutch: Language { "nl" }
    enum English {
        public static var us: Language { "en" }
        public static var uk: Language { "en-GB" }
        public static var australian: Language { "en-AU" }
        public static var canadian: Language { "en-CA" }
        public static var indian: Language { "en-IN" }
        public static var ireland: Language { "en-IE" }
        public static var newZealand: Language { "en-NZ" }
        public static var singapore: Language { "en-SG" }
        public static var southAfrica: Language { "en-ZA" }
    }

    static var finnish: Language { "fi" }
    static var french: Language { "fr" }
    static var german: Language { "de" }
    static var greek: Language { "el" }
    static var hebrew: Language { "he" }
    static var hindi: Language { "hi" }
    static var hungarian: Language { "hu" }
    static var indonesian: Language { "id" }
    static var italian: Language { "it" }
    static var japanese: Language { "ja" }
    static var korean: Language { "ko" }
    static var malay: Language { "ms" }
    static var norwegian: Language { "nb" }
    static var polish: Language { "pl" }
    static var portuguese: Language { "pt" }
    static var romanian: Language { "ro" }
    static var russian: Language { "ru" }
    static var slovak: Language { "sk" }
    static var spanish: Language { "es" }
    static var swedish: Language { "sv" }
    static var thai: Language { "th" }
    static var turkish: Language { "tr" }
    static var ukrainian: Language { "uk" }
    static var vietnamese: Language { "vi" }
}

public extension Language {
    /// Return supported languages in current app.
    static func availableLanguages() -> [Language] {
        Bundle.main.localizations.filter { $0 != "Base" }.map { Language(rawValue: $0) }
    }
}

public extension Language {
    
    private static var current: Language {
        switch KYLocalizationPreference.current {
        case .followSystem:
            guard let first = Bundle.main.preferredLocalizations.first else {
                return .English.us
            }
            let lang = Language(rawValue: first)
            guard Language.availableLanguages().contains(lang) else { return .English.us }
            return lang
        case let .specified(lang):
            return lang
        }
    }
    
}
