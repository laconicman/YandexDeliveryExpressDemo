//
//  File.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 9/2/25.
//

import SwiftUI

// TODO: Replace with `FieldSection`?
struct ClaimIdSection: View {
    @Binding private(set) var claimId: String
    var body: some View {
        Section("Claim ID") {
            Field("Claim ID", value: $claimId)
                .textFieldStyle(.roundedBorder)
        }
    }
}
