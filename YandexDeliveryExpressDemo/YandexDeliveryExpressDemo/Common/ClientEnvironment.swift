//
//  ClientEnvironment.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 8/11/25.
//
import YandexDeliveryExpressAPI

// MARK: - Client Environment

import SwiftUI

@MainActor
final class ClientEnvironment: ObservableObject { // ???: Do we need observable here?
    static let shared = ClientEnvironment()
    // lazy var client = try! Client(credentials: Credentials.fromEnvironment)
    @AppStorage("authToken") private var authToken: String = ""
    lazy var client = try! Client(credentials: Credentials.init(authToken: authToken))
    
    private init() {}
}
