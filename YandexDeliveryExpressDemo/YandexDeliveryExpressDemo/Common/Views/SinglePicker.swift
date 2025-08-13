//
//  SinglePicker.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 7/25/25.
//

import SwiftUI

struct SinglePicker<E: CaseIterable>: View where E: ManagedElement {
    private let titleKey: LocalizedStringKey
    private let systemImage: String?
    @Binding private(set) var selection: E?
    private let hasNoneOption: Bool
    
    /// Picker for `CaseIterable` `ManagedElement`
    /// - Parameters:
    ///   - titleKey: A localized string key that describes the purpose of selecting an option.
    ///   - systemImage: if `nil not indentation for pictogram, if empty or not a valid SFSymbol - empty placeholder`
    ///   - selection: A binding to a property that determines the currently-selected option.
    ///   - hasNoneOption: if `true` has additional "None" option which results in selection being set to `nil`
    init(_ titleKey: LocalizedStringKey, systemImage: String? = nil, selection: Binding<E?>, hasNoneOption: Bool = false) {
        self.titleKey = titleKey
        self.systemImage = systemImage
        self._selection = selection
        self.hasNoneOption = hasNoneOption
    }
    
    /// Picker for `CaseIterable` `ManagedElement`
    /// - Parameters:
    ///   - titleKey: A localized string key that describes the purpose of selecting an option.
    ///   - systemImage: if `nil not indentation for pictogram, if empty or not a valid SFSymbol - empty placeholder`
    ///   - selection: A binding to a property that determines the currently-selected option.
    init(_ titleKey: LocalizedStringKey, systemImage: String? = nil, selection: Binding<E>) {
        self.titleKey = titleKey
        self.systemImage = systemImage
        self._selection = .init(selection)
        self.hasNoneOption = false
    }

    var body: some View {
        if let systemImage {
            Picker(titleKey, systemImage: systemImage, selection: $selection) {
                pickerContent
            } currentValueLabel: {
                selectionLabel
            }
        } else {
            Picker(titleKey, selection: $selection) {
                pickerContent
            } currentValueLabel: {
                selectionLabel
            }
        }
    }
    
    @ViewBuilder
    private var pickerContent: some View {
        if hasNoneOption {
            Text("None").tag(E?.none)
        }
        ForEach(Array(E.allCases)) { element in
            Text(element.description)
                .tag(element)
        }
    }
    
    private var selectionLabel: Text {
        if let selection  {
            Text(selection.description)
        } else {
            Text("Not selected")
        }
    }
    
}


#Preview {
    @Previewable @State var taxiClasses: ManagedEnumSample?
    List {
        SinglePicker("Taxi class", systemImage: "car.fill", selection: $taxiClasses, hasNoneOption: true)
    }
}
