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
            ClaimIdSection(claimId: $viewModel.claimId)
        }
    }
    
}

#Preview {
    @Previewable @StateObject var state = RequestState()
    GetClaimInfoForm()
        .environmentObject(state)
}
