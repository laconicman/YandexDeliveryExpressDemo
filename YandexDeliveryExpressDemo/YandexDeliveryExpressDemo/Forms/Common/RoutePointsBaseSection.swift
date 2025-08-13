//
//  RoutePointsBaseSection.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 7/24/25.
//

import SwiftUI
import YandexDeliveryExpressAPI

struct RoutePointsBaseSection: View {
    @Binding var routePoints: [Components.Schemas.RoutePointBase]
    var body: some View {
        Section("Route Points") {
            ForEach(routePoints.indices, id: \.self) { index in
                RoutePointEditor(
                    routePoint: $routePoints[index],
                    index: index,
                    canDelete: routePoints.count > 2,
                    onDelete: { index in removeRoutePoint(at: index) }
                )
            }
            .onDelete { removeRoutePoints(atOffsets: $0) }
            .onMove { routePoints.move(fromOffsets: $0, toOffset: $1) }
            
            Button("Add Route Point", systemImage: "plus") {
                routePoints.addRoutePoint()
            }
        }
    }
    
    private func removeRoutePoint(at index: Int) {
        guard routePoints.count > 2 else { return }
        routePoints.remove(at: index)
        refreshRoutePointsVisitOrder()
    }
    
    private func removeRoutePoints(atOffsets offsets: IndexSet) {
        guard routePoints.count - offsets.count > 1 else { return }
        routePoints.remove(atOffsets: offsets)
        refreshRoutePointsVisitOrder()
    }
    
    private func moveRoutePoints(fromOffsets source: IndexSet, toOffset destination: Int)  {
        routePoints.move(fromOffsets: source, toOffset:  destination)
        refreshRoutePointsVisitOrder()
    }
    
    private func refreshRoutePointsVisitOrder() {
        routePoints = routePoints.enumerated().map{
            var element = $0.element // this can be written wore elegantly
            element.visitOrder = $0.offset + 1
            return element
        }
    }

}

#Preview {
    @Previewable @State var routePoints: [Components.Schemas.RoutePointBase] = .exampleSimpleRoute
    List {
        RoutePointsBaseSection(routePoints: $routePoints)
    }
}
