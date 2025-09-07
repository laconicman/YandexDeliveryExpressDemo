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
    
    @Published var calalculatedOffers: [Components.Schemas.CalculatedOffer] = []
    
}
