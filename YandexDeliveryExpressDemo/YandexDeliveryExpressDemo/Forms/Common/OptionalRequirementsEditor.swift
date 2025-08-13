//
//  OptionalRequirementsEditor.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 8/13/25.
//

import SwiftUI
import YandexDeliveryExpressAPI
import BetterBinding

struct OptionalRequirementsEditor: View {
    @Binding private(set) var cargoOptions: [Components.Schemas.CargoOption]
    @Binding private(set) var cargoLoaders: Int?
    @Binding private(set) var proCourier: Bool?
    @Binding private(set) var skipDoorToDoor: Bool?
    @Binding private(set) var due: Date?
    @State private var isUsingDueDate: Bool = false
    
    var body: some View {
        Stepper("Cargo Loaders", value: $cargoLoaders ??? 0, in: 0...2)
        
        Toggle("Pro Courier", isOn: $proCourier ??? false)
        Toggle("Skip Door to Door", isOn: $skipDoorToDoor ??? false)
        
        Toggle("Set Due Date", isOn: $isUsingDueDate)
            .onChange(of: isUsingDueDate) { _, newState in
                if !newState { due = nil }
            }
        
        if isUsingDueDate {
            DatePicker("Due Date", selection: $due ?? Date().addingTimeInterval(60 * 60),
                       in: Date()...Date().addingTimeInterval(60 * 60 * 24 * 30),
                       displayedComponents: [.date, .hourAndMinute])
                       .disabled(!isUsingDueDate)
                       .animation(.default, value: isUsingDueDate)
        }
        
        DisclosureGroup("CargoOptions") {
            MultiPicker(selection: $cargoOptions)
        }
    }

}
