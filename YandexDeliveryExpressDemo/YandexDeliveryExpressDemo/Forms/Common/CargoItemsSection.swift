//
//  CargoItemsSection.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 8/13/25.
//

import SwiftUI
import YandexDeliveryExpressAPI

struct CargoItemsSection: View {
    @Binding private(set) var items: [Components.Schemas.CargoItem]
    let routePoints: [Components.Schemas.RoutePointBase] // These might want to be bindings because they can change outside
    @State private var isExpanded = true
    
    var body: some View {
        Section {
            ForEach(items.indices, id: \.self) { index in
                DisclosureGroup("Cargo Item: \(items[index].title)") {
                    CargoItemEditor(
                        item: $items[index],
                        routePoints: routePoints,
                        onDelete: { items.remove(at: index)}
                    )
                }
            }
            
            Button("Add new item to route") {
                try? addToRoute() // TODO: Handle errors
            }
            .disabled(routePoints.count < 2)
        } header: {
            Text("Cargo Items")
                .badge(items.count)
        }
        
    }

    private func addToRoute(quantity: Int = 1) throws {
        // FIXME: let dropoffPoint = routePoints[safe:1]?.pointId
        // mind point type
        guard let pickupPoint = routePoints.first?.pointId, let dropoffPoint = routePoints.last?.pointId else { throw NSError(domain: "", code: 0, userInfo: nil)}
        items.append(.init(costCurrency: .rub, costValue: "0", pickupPoint: pickupPoint, quantity: 1, title: "Item \(Int.random(in: 1...1000))", dropoffPoint: dropoffPoint))
    }

}

#Preview {
    @Previewable @State var items: [Components.Schemas.CargoItem] = .exampleSingleItemOrder
    let routePoints: [Components.Schemas.RoutePointBase] = .exampleSimpleRoute
    List {
        CargoItemsSection(items: $items, routePoints: routePoints)
    }
}
