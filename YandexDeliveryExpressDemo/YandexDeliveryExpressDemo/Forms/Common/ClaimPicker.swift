//
//  ClaimPicker.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 9/8/25.
//

import SwiftUI

struct ClaimPicker: View {
    @Binding private(set) var claimId: String?
    @EnvironmentObject private var common: CommonViewModel
    
    var body: some View {
        Picker("Created claims", selection: $claimId) {
            ForEach(common.createdClaims) { claim in
                Text("\(claim.date): \(claim.id)")
                    .tag(claim.id)
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var common = CommonViewModel.preview
    ClaimPicker(claimId: .constant("To implement"))
        .environmentObject(common)
}
