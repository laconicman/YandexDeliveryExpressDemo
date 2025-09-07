//
//  ClientKey.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 7/15/25.
//

import SwiftUI
import YandexDeliveryExpressAPI
import OpenAPIURLSession

struct ClientKey: EnvironmentKey {
    static let defaultValue: Client = try! Client(credentials: Credentials.fromEnvironment)
}

extension EnvironmentValues {
    var yandexClient: Client {
        get { self[ClientKey.self] }
        set { self[ClientKey.self] = newValue }
    }
}
