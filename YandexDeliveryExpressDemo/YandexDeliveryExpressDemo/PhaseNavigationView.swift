//
//  Phase.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 7/15/25.
//

// Sources/ExpressDemo/PhaseNavigationView.swift
import SwiftUI

struct PhaseNavigationView: View {
    @State private var path = [Phase]()
    @State private var isShowingAuth = false
    
    var body: some View {
        NavigationStack(path: $path) {
            List(Phase.allCases) { phase in
                NavigationLink(value: phase) {
                    HStack {
                        Image(systemName: phase.systemName)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(phase.rawValue)
                                .font(.headline)
                            Text(phase.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
            .toolbar{
                Button {
                    isShowingAuth = true
                } label: {
                    Label("Sign in", systemImage: "key") // TODO: Use Macro for `systemImage`.
                }
            }
            .sheet(isPresented: $isShowingAuth) {
                AuthAndSettingsView()
                    .presentationDetents([.fraction(0.2), .medium])
                    .fixedSize()
            }
            .navigationTitle("Ya Express Demo")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Phase.self) { phase in
                switch phase {
                case .calculateOffers: CalculateOffersForm()
                case .createClaim:     CreateClaimForm()
                case .getClaimInfo:    GetClaimInfoForm()
                case .acceptClaim:     AcceptClaimForm()
                case .cancelClaim:     CancelClaimForm()
                }
            }
        }
    }
}

enum Phase: String, CaseIterable, Identifiable, SystemImageRepresentable  {
    case calculateOffers = "Calculate Offers"
    case createClaim     = "Create Claim"
    case getClaimInfo    = "Get Claim Info"
    case acceptClaim     = "Accept Claim"
    case cancelClaim     = "Cancel Claim"
    
    var id: Self { self }
    
    var description: String {
        switch self {
        case .calculateOffers: "Calculate delivery offers for a route"
        case .createClaim: "Create a new delivery claim"
        case .getClaimInfo: "Get information about existing claim"
        case .acceptClaim: "Accept a delivery claim"
        case .cancelClaim: "Cancel an existing claim"
        }
    }
    
    var systemName: String {
        switch self {
        case .calculateOffers: "questionmark.text.page"
        case .createClaim: "plus.circle"
        case .getClaimInfo: "info.circle"
        case .acceptClaim: "checkmark.circle"
        case .cancelClaim: "xmark.circle"
        }
    }
}
