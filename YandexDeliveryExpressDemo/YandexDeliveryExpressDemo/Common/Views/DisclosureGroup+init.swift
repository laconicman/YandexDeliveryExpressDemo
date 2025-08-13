//
//  DisclosureGroup+init.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 7/25/25.
//

import SwiftUI

extension DisclosureGroup where Label == SwiftUI.Label<Text, Image> {

    /// - Parameters:
    ///   - titleKey: The key for the localized label of `self` that describes
    ///     the content of the disclosure group.
    ///   - systemImage: SFSymbol pictogram
    ///   - content: The content shown when the disclosure group expands.
    nonisolated public init(_ titleKey: LocalizedStringKey, systemImage: String, @ViewBuilder content: @escaping () -> Content) {
        self.init(content: content, label: {
            SwiftUI.Label(titleKey, systemImage: systemImage)
        })
    }
    
    nonisolated public init<S>(_ title: S, systemImage: String, @ViewBuilder content: @escaping () -> Content) where S : StringProtocol {
        self.init(content: content, label: {
            SwiftUI.Label(title, systemImage: systemImage)
        })
    }
}

