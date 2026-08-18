//
//  CreateClaimForm.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 7/24/25.
//

import SwiftUI
import YandexDeliveryExpressAPI
import MultiPicker

// MARK: - Create Claim Form

struct CreateClaimForm: View {
    @StateObject private var viewModel = CreateClaimViewModel()
    @EnvironmentObject private var common: CommonViewModel
    @State private var selectedOffer: Components.Schemas.CalculatedOffer?
    
    var body: some View {
        GenericForm("Create Claim", viewModel: viewModel) {
            SinglePicker("Language", systemImage: "globe", selection: $viewModel.acceptLanguage)
                .pickerStyle(.segmented)
            requestIdSection
            Section("Offers") {
                MultiPicker("Offers", selection: $selectedOffer) {
                    ForEach(common.calculatedOffers) { offer in
                        Text(offer.price.totalPriceWithVat)
                            .mpTag(offer)
                    }
                }
                .onChange(of: selectedOffer) { oldValue, newValue in
                    viewModel.offerPayload = newValue?.payload
                    if let taxiClass = newValue?.taxiClass {
                        viewModel.taxiClass = taxiClass
                    }
                }
            }
            RoutePointsBaseSection(routePoints: $viewModel.routePoints)
            CargoItemsSection(items: $viewModel.items, routePoints: viewModel.routePoints)
            clientRequirementsSection
            additionalSection
            if case let .success(result) = viewModel.result, let json = try? result.ok.body.json {
                FilteredPropertyInspectorView(object: json)
                    .onAppear {
                        common.createdClaims.append(.init(id: json.id, date: json.createdTs, price: json.pricing?.finalPrice ?? ""))
                    }
            }
        }
        
    }

    private var requestIdSection: some View {
        Section("Request ID") {
            Field("Request ID", value: $viewModel.requestId)
            Button("Generate New UUID") {
                viewModel.requestId = UUID().uuidString
            }
        }
    }

    private var clientRequirementsSection: some View {
        Section("Client Requirements") {
            
            SinglePicker("Taxi class", systemImage: "box.truck.badge.clock", selection: $viewModel.taxiClass)
            
            SinglePicker("Cargo Type", systemImage: "truck.box", selection: $viewModel.cargoType, hasNoneOption: true)
            
            DisclosureGroup("Other Options (Optional)", systemImage: "figure.walk.arrival") {
                OptionalRequirementsEditor(cargoOptions: $viewModel.cargoOptions, cargoLoaders: $viewModel.cargoLoaders, proCourier: $viewModel.proCourier, skipDoorToDoor: $viewModel.skipDoorToDoor, due: $viewModel.due)
                
            }
        }
    }

    private var additionalSection: some View {
        Section("Additional Information") {
            TextField("Shipping Document", text: $viewModel.shippingDocument)
                .textFieldStyle(.roundedBorder)
            
            TextField("Comment", text: $viewModel.comment, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(3...6)

        }
    }
}

#Preview {
    @Previewable @StateObject var state = RequestState()
    @Previewable @StateObject var common = CommonViewModel.preview
    CreateClaimForm()
        .environmentObject(state)
        .environmentObject(common)
}
