//
//  LanguagePickerSection.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 7/24/25.
//
/*
import SwiftUI
import YandexDeliveryExpressAPI

struct LanguagePickerSection: View {
    @Binding private(set) var acceptLanguage: Components.Parameters.AcceptLanguage
    var body: some View {
        Section("Language") {
            Picker("Accept Language", selection: $acceptLanguage) {
                ForEach(Components.Parameters.AcceptLanguage.allCases, id: \.rawValue) { language in
                    Text(language.description).tag(language)
                }
            }
        }
    }
}

#Preview {
    Form {
        LanguagePickerSection(acceptLanguage: .constant(.ru))
    }
}
*/
