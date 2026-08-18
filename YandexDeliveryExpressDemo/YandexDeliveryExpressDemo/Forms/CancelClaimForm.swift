//
//  CancelClaimForm.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 9/7/25.
//

import SwiftUI
import YandexDeliveryExpressAPI

struct CancelClaimForm: View {
    @StateObject private var viewModel = CancelClaimViewModel()
    
    var body: some View {
        GenericForm("Cancel Claim", viewModel: viewModel) {
            SinglePicker("Language", systemImage: "globe", selection: $viewModel.acceptLanguage)
                .pickerStyle(.segmented)
            ClaimIdSection(claimId: $viewModel.claimId)
            FieldSection("Version", value: $viewModel.version)
            cancellationSection
            Text("hnbhb")
        }
    }
    
    @ViewBuilder
    private var cancellationSection: some View {
        Section("Cancellation") {
//            Picker("Cancel State", selection: $viewModel.cancelState) {
//                ForEach(Components.Schemas.CancelState.allCases) { state in
//                    Text(state.rawValue.capitalized).tag(state)
//                }
//            }
            SinglePicker("Cancel State", selection: $viewModel.cancelState) 
            .pickerStyle(.segmented)
            
            //            TextField("Reason", text: $viewModel.reason, axis: .vertical)
            //                .textFieldStyle(.roundedBorder)
            //                .lineLimit(3...6)
        }
    }
}

#Preview {
    @Previewable @StateObject var state = RequestState()
    CancelClaimForm()
        .environmentObject(state)
}
