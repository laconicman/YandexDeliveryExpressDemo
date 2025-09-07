//
//  FieldSection.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 9/7/25.
//


import SwiftUI

struct FieldSection<T: LosslessStringConvertible,  S: StringProtocol>: View {
    private let title: S
    @Binding private var value: T
    
    /// Creates a `Section` with  value (text) field with section title and text label generated from a title string.
    ///
    /// - Parameters:
    ///   - title: The title, describing the section purpose.
    ///   - value: The value (or text) display and edit.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    init(_ title: S, value: Binding<T>) {
        self.title = title
        self._value = value
    }
    
    var body: some View {
        Section(title) {
            Field(title, value: $value)
        }
    }

}

/* // TODO: Make this localizable in future. See: `SinglePicker` implementation.
struct FieldSection<T: LosslessStringConvertible>: View {
    private let titleKey: LocalizedStringKey?
    private let titleString: String?
    @Binding private var value: T
    
    // Initializer for LocalizedStringKey (for automatic localization)
    init(_ titleKey: LocalizedStringKey, value: Binding<T>) {
        self.titleKey = titleKey
        self.titleString = nil
        self._value = value
    }
    
    // Initializer for StringProtocol (for non-localized strings)
    @_disfavoredOverload
    init<S: StringProtocol>(_ title: S, value: Binding<T>) {
        self.titleKey = nil
        self.titleString = String(title)
        self._value = value
    }
    
    var body: some View {
        if let titleKey = titleKey {
            Section(titleKey) {
                Field(titleKey, value: $value) // Need to reform `Field` sam way to be able to use.
            }
        } else if let titleString = titleString {
            Section(titleString) {
                Field(titleString, value: $value)
            }
        }
    }
}
*/
