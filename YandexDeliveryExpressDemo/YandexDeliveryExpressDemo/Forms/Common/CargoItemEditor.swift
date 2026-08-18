//
//  CargoItemEditor.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 8/1/25.
//

import SwiftUI
import YandexDeliveryExpressAPI

// MARK: - Cargo Item Editor

struct CargoItemEditor: View {
        @Binding var item: Components.Schemas.CargoItem
    let routePoints: [Components.Schemas.RoutePointBase]
    let onDelete: () -> Void
    @State private var itemSize: Components.Schemas.ItemSize
    @State private var hasSize: Bool
    
    init(item: Binding<Components.Schemas.CargoItem>, routePoints: [Components.Schemas.RoutePointBase], onDelete: @escaping () -> Void) {
        self._item = item
        self.routePoints = routePoints
        self.onDelete = onDelete
        self.itemSize = item.wrappedValue.size ?? .exampleSmallBox
        self.hasSize = item.wrappedValue.size != nil
    }
    
    var body: some View {
        
        Field("External ID", value: $item.extraId, defaultValue: "")
        Field("Title", value: $item.title)
        
        // TODO: Deduplicate, filter by point type
        Picker("Pickup Point", selection: $item.pickupPoint) {
            ForEach(routePoints, id: \.pointId) { point in
                Text("Point \(point.pointId): \(point.address.fullname)")
                    .tag(point.pointId)
            }
        }
        
        Picker("Dropoff Point", selection: $item.dropoffPoint) {
            ForEach(routePoints, id: \.pointId) { point in
                Text("Point \(point.pointId): \(point.address.fullname)")
                    .tag(point.pointId)
            }
        }
        
        Field("Cost Value", value: $item.costValue)
        
        SinglePicker("Cost Currency", selection: $item.costCurrency)
        
        Field("Quantity", value: $item.quantity)
        
        Field("Weight (kg)", value: $item.weight, defaultValue: 0.0)
        
        DisclosureGroup("Size") {
            ItemSizeEditor(size: $itemSize)
                .disabled(!hasSize)
                .onChange(of: itemSize) { setItemSize() }
            
            Toggle("Has Size", isOn: $hasSize)
                .onChange(of: hasSize) { setItemSize() }
        }
        
        Button("Delete Item", role: .destructive) {
            onDelete()
        }
        
    }
    
    private func setItemSize() {
        if hasSize { item.size = itemSize } else { item.size = nil }
    }

}

#Preview {
    CargoItemEditor(item: .constant(.exampleBooks), routePoints: .exampleSimpleRoute, onDelete: {})
        .padding()
}
