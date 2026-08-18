//
//  RoutePointPicker.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 7/25/25.
//

import SwiftUI
import YandexDeliveryExpressAPI

struct RoutePointPicker<S: Hashable>: View {
    let title: any StringProtocol
    @Binding var selection: S
    let routePoints: [Components.Schemas.RoutePointWithAddress]
    var body: some View {
        Picker(title, selection: $selection) {
            ForEach(routePoints, id: \.id) { point in
                Text("Point \(point.id): \(point.value2.fullname)")
                    .tag(point.id)
            }
        }
    }
}

#Preview {
    @Previewable @State var selection: Int64 = 0
    List {
        RoutePointPicker(title: "Pickup Point", selection: $selection, routePoints: .exampleMoscowRoute)
    }
}
