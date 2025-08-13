//
//  GetClaimInfoViewModel.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 8/11/25.
//
import Foundation
import YandexDeliveryExpressAPI

// MARK: - Get Claim Info ViewModel

@MainActor
final class GetClaimInfoViewModel: BaseFormViewModel, FormViewModelProtocol {
    typealias APIOutput = Operations.GetClaimInfo.Output
    
    @Published var result: Result<APIOutput, Error>?
    @Published var claimId: String = ""
    
    var isValid: Bool {
        !claimId.isEmpty
    }
    
    func execute() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let client = ClientEnvironment.shared.client
            let query = Operations.GetClaimInfo.Input.Query(claimId: claimId)
            let headers = Operations.GetClaimInfo.Input.Headers(
                acceptLanguage: acceptLanguage,
                accept: .defaultValues()
            )
            
            let output = try await client.getClaimInfo(query: query, headers: headers)
            result = .success(output)
        } catch {
            result = .failure(error)
        }
    }
}

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
