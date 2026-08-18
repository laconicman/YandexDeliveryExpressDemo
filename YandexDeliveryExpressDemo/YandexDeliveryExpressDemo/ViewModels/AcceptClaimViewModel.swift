//
//  AcceptClaimViewModel.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 9/2/25.
//

import Foundation
import YandexDeliveryExpressAPI

// MARK: - Accept Claim ViewModel

@MainActor
final class AcceptClaimViewModel: BaseFormViewModel, FormViewModelProtocol {
    typealias APIOutput = Operations.AcceptClaim.Output
    
    @Published var result: Result<APIOutput, Error>?
    @Published var claimId: String = ""
    @Published var version: Int64 = 1
    
    var isValid: Bool {
        !claimId.isEmpty && version > 0
    }
    
    func execute() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let client = ClientEnvironment.shared.client
            let query = Operations.AcceptClaim.Input.Query(claimId: claimId)
            let headers = Operations.AcceptClaim.Input.Headers(
                acceptLanguage: acceptLanguage,
                accept: .defaultValues()
            )
            let body = Operations.AcceptClaim.Input.Body.json(
                .init(version: version)
            )
            
            let output = try await client.acceptClaim(query: query, headers: headers, body: body)
            result = .success(output)
        } catch {
            result = .failure(error)
        }
    }
}
