//
//  RequirementsSection.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 7/25/25.
//

import SwiftUI
import YandexDeliveryExpressAPI
// import BetterBinding

struct RequirementsSection: View {
    @Binding private(set) var taxiClasses: [Components.Schemas.TaxiClass]
    @Binding private(set) var cargoType: Components.Schemas.CargoType?
    @Binding private(set) var cargoOptions: [Components.Schemas.CargoOption]
    @Binding private(set) var cargoLoaders: Int?
    @Binding private(set) var proCourier: Bool?
    @Binding private(set) var skipDoorToDoor: Bool?
    @Binding private(set) var due: Date?
    
    // TODO: Validate the form against conflicting requirements.
    var body: some View {
        Section("Requirements") {
            DisclosureGroup("Taxi Classes", systemImage: "box.truck.badge.clock") {
                MultiPickerCaseIterable(selection: $taxiClasses)
            }
            
            SinglePicker("Cargo Type", systemImage: "truck.box", selection: $cargoType, hasNoneOption: true)
            
            DisclosureGroup("Other Options (Optional)", systemImage: "figure.walk.arrival") {
                OptionalRequirementsEditor(cargoOptions: $cargoOptions, cargoLoaders: $cargoLoaders, proCourier: $proCourier, skipDoorToDoor: $skipDoorToDoor, due: $due)
            }
            
        }
    }
}

#Preview {
    @Previewable @State var taxiClasses: [Components.Schemas.TaxiClass] = .exampleTaxiClasses
    @Previewable @State var cargoType: Components.Schemas.CargoType? = .lcvL
    @Previewable @State var cargoOptions: [Components.Schemas.CargoOption] = []
    @Previewable @State var cargoLoaders: Int?
    @Previewable @State var proCourier: Bool?
    @Previewable @State var skipDoorToDoor: Bool?
    @Previewable @State var due: Date?
    List {
        RequirementsSection(taxiClasses: $taxiClasses, cargoType: $cargoType, cargoOptions: $cargoOptions, cargoLoaders: $cargoLoaders, proCourier: $proCourier, skipDoorToDoor: $skipDoorToDoor, due: $due)
    }
}


