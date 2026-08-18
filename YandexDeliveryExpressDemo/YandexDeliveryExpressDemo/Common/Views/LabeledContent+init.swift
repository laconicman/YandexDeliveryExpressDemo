import SwiftUI

@available(iOS 16.0, *)
extension LabeledContent where Label == SwiftUI.Label<Text, Image>, Content: View {
    /// Creates labeled content with a localized string key and system image for the label.
    nonisolated public init(_ titleKey: LocalizedStringKey, systemImage: String, @ViewBuilder content: @escaping () -> Content) {
        self.init(content: content, label: {
            SwiftUI.Label(titleKey, systemImage: systemImage)
        })
    }
    
    /// Creates labeled content with a string title and system image for the label.
    nonisolated public init<S>(_ title: S, systemImage: String, @ViewBuilder content: @escaping () -> Content) where S : StringProtocol {
        self.init(content: content, label: {
            SwiftUI.Label(title, systemImage: systemImage)
        })
    }
}
