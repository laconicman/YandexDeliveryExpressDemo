//
//  MultiPickerCaseIterable.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 7/25/25.
//

import SwiftUI

struct MultiPickerCaseIterable<E: CaseIterable>: View where E: ManagedElement {
    @Binding private(set) var selection: [E]
    
    var body: some View {
        ForEach(Array(E.allCases)) { element in
            LabeledContent(element.description.capitalized) {
                Button(selection.contains(element) ? String(localized: "Remove", comment: "Button title in `MultiPicker`") : String(localized: "Add", comment: "Button title in `MultiPicker`")) {
                    if selection.contains(element) {
                        selection.removeAll { $0 == element }
                    } else {
                        selection.append(element)
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var taxiClasses: [ManagedEnumSample] = [.express, .cargo]
    List {
        MultiPickerCaseIterable(selection: $taxiClasses)
    }
}

#if DEBUG
enum ManagedEnumSample: String, CaseIterable, ManagedElement {
    case courier, express, cargo
    var id: String { rawValue }
    var description: String { rawValue }
}
#endif
