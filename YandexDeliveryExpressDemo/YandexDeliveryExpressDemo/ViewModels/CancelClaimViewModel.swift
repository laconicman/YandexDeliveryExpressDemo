//
//  CancelClaimViewModel.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 8/11/25.
//
import Foundation
import YandexDeliveryExpressAPI

// MARK: - Cancel Claim ViewModel

@MainActor
final class CancelClaimViewModel: BaseFormViewModel, FormViewModelProtocol {
    typealias APIOutput = Operations.CancelClaim.Output
    
    @Published var result: Result<APIOutput, Error>?
    @Published var claimId: String = ""
    @Published var version: Int64 = 1
    @Published var cancelState: Components.Schemas.CancelState = .free
    
    var isValid: Bool {
        !claimId.isEmpty && version > 0
    }
    
    func execute() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let client = ClientEnvironment.shared.client
            let query = Operations.CancelClaim.Input.Query(claimId: claimId)
            let headers = Operations.CancelClaim.Input.Headers(
                acceptLanguage: acceptLanguage,
                accept: .defaultValues()
            )
            let body = Operations.CancelClaim.Input.Body.json(
                .init(
                    version: version,
                    cancelState: cancelState
                )
            )
            
            let output = try await client.cancelClaim(query: query, headers: headers, body: body)
            result = .success(output)
        } catch {
            result = .failure(error)
        }
    }
}
