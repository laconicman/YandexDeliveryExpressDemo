//
//  ItemsSection.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 7/25/25.
//

import SwiftUI
import YandexDeliveryExpressAPI

struct ItemsSection: View {
    @Binding private(set) var items: [Components.Schemas.ItemBase]
    let routePoints: [Components.Schemas.RoutePointBase] // These might want to be bindings because they can change outside
    @State private var isExpanded = true
    
    var body: some View {
        Section {
            ForEach(items.indices, id: \.self) { index in
                DisclosureGroup("Item", isExpanded: $isExpanded) {
                    ItemEditor($items[index], routePoints: routePoints, onDelete: { items.remove(at: index) }
                    )
                }
            }
            
            Button("Add Item to Route") {
                try? addToRoute() // TODO: Handle errors
            }
            .disabled(routePoints.count < 2)
        } header: {
            Text("Items (Optional)")
                .badge(items.count)
        }
        
    }

    private func addToRoute(quantity: Int = 1) throws {
        // FIXME: let dropoffPoint = routePoints[safe:1]?.pointId
        guard let pickupPoint = routePoints.first?.pointId, let dropoffPoint = routePoints.last?.pointId else { throw NSError(domain: "", code: 0, userInfo: nil)}
        items.append(.init(quantity: 1, pickupPoint: pickupPoint, dropoffPoint: dropoffPoint))
    }

}

#Preview {
    @Previewable @State var items: [Components.Schemas.ItemBase] = .exampleSmallOrder
    let routePoints: [Components.Schemas.RoutePointBase] = .exampleSimpleRoute
    List {
        ItemsSection(items: $items, routePoints: routePoints)
    }
}
