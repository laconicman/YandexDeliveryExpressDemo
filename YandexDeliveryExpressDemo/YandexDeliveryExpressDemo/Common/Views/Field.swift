//
//  Field.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 7/24/25.
//

import SwiftUI

// MARK: - Common Field Component

struct Field<T: LosslessStringConvertible, S: StringProtocol>: View {
    /// Creates a value (text) field with a text label generated from a title string.
    ///
    /// - Parameters:
    ///   - title: The title of the text view, describing its purpose.
    ///   - text: The text to display and edit.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public init(_ title: S, value: Binding<T>, prompt: Text? = nil) {
        self.title = title
        self._value = value
        self.prompt = prompt
    }
    
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public init(_ title: S, value: Binding<T?>, defaultValue: T, prompt: Text? = nil) where T: Equatable {
        self.title = title
        self._value = Binding(
            get: { value.wrappedValue ?? defaultValue },
            set: { value.wrappedValue = (($0 == defaultValue) ? nil : $0) }
        )
        self.prompt = prompt
    }
    
    private let title: S
    @Binding private var value: T
    private let prompt: Text?
    
    var body: some View {
        Group {
            switch $value {
            case let val as Binding<String>:
                TextField(title, text: val, prompt: prompt)
            case let val as Binding<Double>:
                TextField(title, value: val, format: .number, prompt: prompt)
                    .keyboardType(.decimalPad)
            case let val as Binding<Float>:
                TextField(title, value: val, format: .number, prompt: prompt)
                    .keyboardType(.decimalPad)
            case let val as Binding<Int>:
                TextField(title, value: val, format: .number, prompt: prompt)
                    .keyboardType(.numberPad)
            case let val as Binding<Int64>:
                TextField(title, value: val, format: .number, prompt: prompt)
                    .keyboardType(.numberPad)
            default:
                EmptyView()
            }
        }
        .textFieldStyle(.roundedBorder)
        .autocorrectionDisabled()
    }
}

#Preview {
    @Previewable @State var doubleValue = 936.23
    @Previewable @State var stringValue = "String Value"
    List {
        Field("title", value: $doubleValue)
        Field("title", value: $stringValue)
    }
}
