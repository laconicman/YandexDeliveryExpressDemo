//
//  ContactEditor.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 9/2/25.
//

import SwiftUI
import YandexDeliveryExpressAPI

// MARK: - Contact Editor

struct ContactEditor: View {
    @Binding var contact: Components.Schemas.Contact
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Field("Name", value: $contact.name)
            Field("Phone", value: $contact.phone)
            // TODO: can be improved
            Field("Email", value: Binding(
                get: { contact.email ?? "" },
                set: { contact.email = $0.isEmpty ? nil : $0 }
            ))
            
            Field("Additional Code", value: Binding(
                get: { contact.phoneAdditionalCode ?? "" },
                set: { contact.phoneAdditionalCode = $0.isEmpty ? nil : $0 }
            ))
        }
    }
}
