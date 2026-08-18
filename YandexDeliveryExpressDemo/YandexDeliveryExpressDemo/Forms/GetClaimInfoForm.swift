//
//  GetClaimInfoForm.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 9/2/25.
//

import SwiftUI
import YandexDeliveryExpressAPI

// MARK: - Get Claim Info Form

struct GetClaimInfoForm: View {
    @StateObject private var viewModel = GetClaimInfoViewModel()
    
    var body: some View {
        GenericForm("Get Claim Info", viewModel: viewModel) {
            SinglePicker("Language", systemImage: "globe", selection: $viewModel.acceptLanguage)
                .pickerStyle(.segmented)
            Section("Select claim") {
                ClaimIdSection(claimId: $viewModel.claimId)
            }
            ClaimPickerSection(claimId: $viewModel.claimId)
        }
    }
    
}

struct ClaimPickerSection: View {
    @Binding private(set) var claimId: CommonViewModel.Claim.ID
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
    @Previewable @StateObject var state = RequestState()
    @Previewable @StateObject var common = CommonViewModel.preview
    GetClaimInfoForm()
        .environmentObject(state)
        .environmentObject(common)
}
