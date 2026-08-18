// Sources/ExpressDemo/protocols/FormViewModelProtocol.swift
import Foundation
import YandexDeliveryExpressAPI

/// Protocol that all form ViewModels must conform to
@MainActor
protocol FormViewModelProtocol: ObservableObject {
    /// The type of API output this form produces
    associatedtype APIOutput: CustomStringConvertible
    
    /// Whether the form is currently loading
    var isLoading: Bool { get set }
    
    /// The result of the API call
    var result: Result<APIOutput, Error>? { get set }
    
    /// Whether the form data is valid
    var isValid: Bool { get }
    
    /// Execute the API call
    func execute() async
    
    /// Reset the form to initial state
    func reset()
}

