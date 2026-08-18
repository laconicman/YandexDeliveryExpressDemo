//
//  BaseFormViewModel.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 8/11/25.
//
import Foundation
import YandexDeliveryExpressAPI

/// Base class for form ViewModels to reduce boilerplate
@MainActor
class BaseFormViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var acceptLanguage: Components.Parameters.AcceptLanguage = .ru
    
    func reset() {
        isLoading = false
    }
}
