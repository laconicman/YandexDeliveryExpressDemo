//
//  RoutePointEditor.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 7/24/25.
// TODO: Generalize: split m/vm, domain/appliction/logic.

import SwiftUI
import YandexDeliveryExpressAPI

struct RoutePointEditor: View {
    @Binding var routePoint: Components.Schemas.RoutePointBase
    let index: Int
    let canDelete: Bool
    let onDelete: (_ index: Int) -> Void // Not sure we need index here
    
    var body: some View {
        DisclosureGroup("Route Point \(routePoint.visitOrder)", systemImage: routePoint._type.systemName) {
            VStack(alignment: .leading, spacing: 8) {
                Field("ID", value: $routePoint.pointId)
                SinglePicker("Type", selection: $routePoint._type)
                AddressEditor(address: $routePoint.address)
                
                if canDelete {
                    Button("Delete Route Point", systemImage: "trash", role: .destructive) {
                        onDelete(index)
                    }
                }
            }
        }
    }
}

#Preview {
    RoutePointEditor(routePoint: .constant(.examplePickupOffice), index: 0, canDelete: true, onDelete: {index in })
        .padding()
}
