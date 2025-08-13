//
//  ItemEditor.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 8/1/25.
//

import SwiftUI
import BetterBinding
import YandexDeliveryExpressAPI

// MARK: - Item Editor

struct ItemEditor: View {
    @Binding private var item: Components.Schemas.ItemBase
    @State private var itemSize: Components.Schemas.ItemSize
    @State private var hasSize: Bool
    private let routePoints: [Components.Schemas.RoutePointWithAddress]
    private let onDelete: () -> Void
    
    public init(_ item: Binding<Components.Schemas.ItemBase>, routePoints: [Components.Schemas.RoutePointWithAddress], onDelete: @escaping () -> Void) {
        self._item = item
        self.itemSize = item.wrappedValue.size ?? .init(length: 0.0, width: 0.0, height: 0.0)
        self.hasSize = item.wrappedValue.size != nil
        self.routePoints = routePoints
        self.onDelete = onDelete
    }
    
    public init(_ item: Binding<Components.Schemas.ItemBase>, routePoints: [Components.Schemas.RoutePointBase], onDelete: @escaping () -> Void) {
        self._item = item
        self.itemSize = item.wrappedValue.size ?? .init(length: 0.0, width: 0.0, height: 0.0)
        self.hasSize = item.wrappedValue.size != nil
        self.routePoints = routePoints.map {
            Components.Schemas.RoutePointWithAddress(
                value1: .init(id: $0.pointId),
                value2: $0.address)
        }
        self.onDelete = onDelete
    }
    
    private func sizeChanged() {
        item.size = hasSize ? itemSize : nil
    }
    
    var body: some View {
        LabeledContent("Quantity") {
            Stepper(value: $item.quantity, in: 1...100000) {
                Field("", value: $item.quantity)
                    .padding(.horizontal)
            }
        }
        
        RoutePointPicker(title: "Pickup Point", selection: $item.pickupPoint, routePoints: routePoints)
        RoutePointPicker(title: "Dropoff Point", selection: $item.dropoffPoint, routePoints: routePoints)
        
        LabeledContent("Weight (kg)") {
            Field("Weight (kg)", value: $item.weight, defaultValue: 0.0)
        }
        
        DisclosureGroup("Size") {
            ItemSizeEditor(size: $itemSize)
                .onChange(of: itemSize) { sizeChanged() }
                .disabled(!hasSize)
            
            Toggle("Has Size", isOn: $hasSize)
                .onChange(of: hasSize)  { sizeChanged() }
        }
        
        Button("Delete Item", systemImage: "xmark", role: .destructive) {
            onDelete()
        }
        .buttonStyle(.bordered)
    }
}

#Preview {
    @Previewable @State var item: Components.Schemas.ItemBase = .exampleSmallPackage
    let routePoints: [Components.Schemas.RoutePointWithAddress] = .exampleMoscowRoute
    List {
        ItemEditor($item, routePoints: routePoints, onDelete: {})
    }
}
