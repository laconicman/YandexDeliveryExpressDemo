//
//  CalculateOffersViewModel 2.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 9/7/25.
//


import Foundation
import YandexDeliveryExpressAPI

@MainActor
final class CommonViewModel: ObservableObject {
    
    @Published var calculatedOffers: [Components.Schemas.CalculatedOffer] = []
    @Published var createdClaims: [Claim] = []
}

extension CommonViewModel {
    
    struct Claim: Identifiable {
        let id: String
        let date: Date
        let price: String
    }
    
}

#if DEBUG

extension CommonViewModel {
    
    static let preview = {
        $0.calculatedOffers = [.init(deliveryInterval: .init(from: .now, to: .distantFuture), payload: "redis123", pickupInterval: .init(from: .now, to: .distantFuture), price: .init(currency: .rub, surgeRatio: 1, totalPrice: "123", totalPriceWithVat: "456"), taxiClass: .courier), .init(deliveryInterval: .init(from: .now, to: .distantFuture), payload: "redis123", pickupInterval: .init(from: .now, to: .distantFuture), price: .init(currency: .rub, surgeRatio: 1, totalPrice: "123", totalPriceWithVat: "789"), taxiClass: .courier)]
        return $0
    }(CommonViewModel())
    
}
#endif
