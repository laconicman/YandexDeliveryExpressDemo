//
//  CalculateOffersViewModel.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 8/11/25.
//
import Foundation
import YandexDeliveryExpressAPI

// MARK: - Calculate Offers ViewModel

@MainActor
final class CalculateOffersViewModel: BaseFormViewModel, FormViewModelProtocol {
    typealias APIOutput = Operations.CalculateOffers.Output
    
    @Published var result: Result<APIOutput, Error>?
    
    // Required parameters
    @Published var routePoints: [Components.Schemas.RoutePointBase] = []
    
    // Optional parameters
    @Published var items: [Components.Schemas.ItemBase] = []
    @Published var requirements: Components.Schemas.OfferRequirements?
    
    // Requirements sub-parameters
    @Published var taxiClasses: [Components.Schemas.TaxiClass] = []
    @Published var cargoType: Components.Schemas.CargoType?
    @Published var cargoLoaders: Int?
    @Published var cargoOptions: [Components.Schemas.CargoOption] = []
    @Published var proCourier: Bool? = false
    @Published var skipDoorToDoor: Bool? = false
    @Published var due: Date?
    
    var isValid: Bool {
        // The wire requires ≥1 item row — the field is non-optional since the
        // package's 0.3.0 spec correction (live evidence, 2026-09-22).
        routePoints.count >= 2 && !items.isEmpty
    }
    
    override init() {
        super.init()
        setupDefaults()
    }
    
    private func setupDefaults() {
        // Add default route points for Moscow
        routePoints = .exampleSimpleRoute
        
        // Add default item
        items = .exampleSmallOrder
        
        // Set default requirements
        buildRequirements()
    }
    
    private func buildRequirements() {
        guard !taxiClasses.isEmpty || cargoType != nil || cargoLoaders != 1 || 
              !cargoOptions.isEmpty || (proCourier ?? false) || (skipDoorToDoor ?? false) || due != nil else {
            requirements = nil
            return
        }
        // Save some traffic by not sending default values (arguable, not very future-proof).
        requirements = .init(
            cargoLoaders: cargoLoaders == 0 ? nil : cargoLoaders,
            cargoOptions: cargoOptions.isEmpty ? nil : cargoOptions,
            cargoType: cargoType,
            due: due,
            proCourier: (proCourier ?? false) ? true : nil,
            skipDoorToDoor: (skipDoorToDoor ?? false) ? true : nil,
            taxiClasses: taxiClasses.isEmpty ? nil : taxiClasses,
        )
    }
    
    func execute() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            buildRequirements()
            
            let client = ClientEnvironment.shared.client
            let headers = Operations.CalculateOffers.Input.Headers(
                acceptLanguage: acceptLanguage,
                accept: .defaultValues()
            )
            
            let body = Operations.CalculateOffers.Input.Body.json(
                .init(
                    routePoints: routePoints.map {
                        Components.Schemas.RoutePointWithAddress(
                            value1: .init(id: $0.pointId),
                            value2: $0.address)
                    },
                    items: items,
                    requirements: requirements
                )
            )
            
            let output = try await client.calculateOffers(headers: headers, body: body)
            result = .success(output)
        } catch {
            result = .failure(error)
        }
    }
    
// MARK: Reserved for later use
    /*
    func addRoutePoint() {
        routePoints.addRoutePoint()
    }
    
    func removeRoutePoint(at index: Int) {
        guard routePoints.count > 2 else { return }
        routePoints.remove(at: index)
    }
    
    func addItem() {
        let pickupPoint = routePoints.first?.pointId ?? 1
        let dropoffPoint = routePoints.last?.pointId ?? 2
        items.append(.init(quantity: 1, pickupPoint: pickupPoint, dropoffPoint: dropoffPoint))
    }
    
    func removeItem(at index: Int) {
        items.remove(at: index)
    }
     */
}
