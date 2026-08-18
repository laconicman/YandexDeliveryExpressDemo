//
//  CreateClaimViewModel.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 8/11/25.
//
import Foundation
import YandexDeliveryExpressAPI

// MARK: - Create Claim ViewModel

@MainActor
final class CreateClaimViewModel: BaseFormViewModel, FormViewModelProtocol {
    typealias APIOutput = Operations.CreateClaim.Output
    
    @Published var result: Result<APIOutput, Error>?
    
    // Required parameters
    @Published var requestId: String = UUID().uuidString
    @Published var items: [Components.Schemas.CargoItem] = []
    @Published var routePoints: [Components.Schemas.RoutePointBase] = []
    
    // Optional parameters
    @Published var clientRequirements: Components.Schemas.ClientRequirements?
    @Published var shippingDocument: String = ""
    @Published var comment: String = ""
    @Published var skipDoorToDoor: Bool?
    
    // Client requirements sub-parameters
    @Published var taxiClass: Components.Schemas.TaxiClass = .express
    @Published var cargoType: Components.Schemas.CargoType?
    @Published var cargoLoaders: Int?
    @Published var cargoOptions: [Components.Schemas.CargoOption] = []
    @Published var proCourier: Bool?
    @Published var due: Date?
    
    var isValid: Bool {
        !items.isEmpty && routePoints.count >= 2
    }
    
    override init() {
        super.init()
        setupDefaults()
    }
    
    private func setupDefaults() {
        items = .exampleSingleItemOrder
        routePoints = .exampleSimpleRoute
        buildClientRequirements()
    }
    
    private func buildClientRequirements() {
        clientRequirements = .init(
            taxiClass: taxiClass,
            cargoLoaders: cargoLoaders == 1 ? nil : cargoLoaders,
            cargoOptions: cargoOptions.isEmpty ? nil : cargoOptions,
            cargoType: cargoType,
            proCourier: proCourier
        )
    }
    
    func execute() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            buildClientRequirements()
            
            let client = ClientEnvironment.shared.client
            let query = Operations.CreateClaim.Input.Query(requestId: requestId)
            let headers = Operations.CreateClaim.Input.Headers(
                acceptLanguage: acceptLanguage,
                accept: .defaultValues()
            )
            
            let body = Operations.CreateClaim.Input.Body.json(
                .init(
                    items: items,
                    routePoints: routePoints,
                    clientRequirements: clientRequirements,
                    comment: comment.isEmpty ? nil : comment,
                    due: due,
                    shippingDocument: shippingDocument.isEmpty ? nil : shippingDocument,
                    skipDoorToDoor: skipDoorToDoor
                )
            )
            
            let output = try await client.createClaim(query: query, headers: headers, body: body)
            result = .success(output)
        } catch {
            result = .failure(error)
        }
    }
    
    func addItem() {
        let pickupPoint = routePoints.first?.pointId ?? 1
        let dropoffPoint = routePoints.last?.pointId ?? 2
        items.append(.init(costCurrency: .rub, costValue: "0", pickupPoint: pickupPoint, quantity: 1, title: "", dropoffPoint: dropoffPoint))
    }
    
    func removeItem(at index: Int) {
        items.remove(at: index)
    }
    
    func addRoutePoint() {
        routePoints.addRoutePoint()
    }
    
    func removeRoutePoint(at index: Int) {
        guard routePoints.count > 2 else { return }
        routePoints.remove(at: index)
        // Update visit orders
        for i in 0..<routePoints.count {
            routePoints[i].visitOrder = i + 1
        }
    }
}

