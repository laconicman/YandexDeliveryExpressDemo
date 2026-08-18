//
//  AuthView.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 7/22/25.
//

import SwiftUI
// ClientEnvironment.shared.client
struct AuthAndSettingsView: View {
    // TODO: View model arch
    @Environment(\.dismiss) var dismiss
    @AppStorage("authToken") var authToken: String = "" // TODO: use Keychain
    var body: some View {
        VStack {
            SecureField(text: $authToken, prompt: Text("Enter auth token")) {
                Label("Token", systemImage: "lock.square")
                    .labelStyle(.titleAndIcon)
            }
            .textFieldStyle(.roundedBorder)
            .onSubmit {
                submit()
                dismiss()
            }
            Button("Submit") {
                submit()
                dismiss()
            }
        }
        .padding()
    }
    
    // TODO: Error handling, alert
    private func submit() {
        do {
            ClientEnvironment.shared.client = try .init(credentials: .init(authToken: authToken))
        } catch {
            print(error) // TODO: Handle with alert manager.
        }
    }
}

#Preview {
    AuthAndSettingsView()
}
