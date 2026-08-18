//
//  AcceptClaimForm.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 9/2/25.
//

import SwiftUI
import YandexDeliveryExpressAPI

struct AcceptClaimForm: View {
    @StateObject private var viewModel = AcceptClaimViewModel()

    var body: some View {
        GenericForm("Accept Claim", viewModel: viewModel) {
            SinglePicker("Language", systemImage: "globe", selection: $viewModel.acceptLanguage)
                .pickerStyle(.segmented)
            ClaimIdSection(claimId: $viewModel.claimId)
            FieldSection("Version", value: $viewModel.version)
        }
    }

}

#Preview {
    @Previewable @StateObject var state = RequestState()
    AcceptClaimForm()
        .environmentObject(state)
}
