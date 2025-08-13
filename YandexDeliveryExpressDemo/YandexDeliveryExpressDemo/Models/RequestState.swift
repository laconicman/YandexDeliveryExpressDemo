//
//  RequestState.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 7/15/25.
//

import Foundation
import YandexDeliveryExpressAPI

@MainActor
final class RequestState: ObservableObject {
    @Published var resultText: String = ""
    
    /* // Reserved for future use
    func log<T: Encodable>(_ object: T) {
        let encoder = JSONEncoder.prettyPrinted
        
        let pretty = if let data = try? encoder.encode(object) {
            String(data: data, encoding: .utf8) ?? "<encoding failed>"
        } else {
            "<encoding failed>"
        }
        
        resultText = pretty
    }
     */
    
    func log<T: CustomStringConvertible>(_ object: T) {
        resultText = object.description
    }
}
