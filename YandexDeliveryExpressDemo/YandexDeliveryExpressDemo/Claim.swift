//
//  Item.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 7/15/25.
//

import Foundation
import SwiftData

@Model
final class Claim {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
