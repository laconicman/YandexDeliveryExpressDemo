// Sources/ExpressDemo/forms/GenericForm.swift
import SwiftUI
import YandexDeliveryExpressAPI

// MARK: - Generic Form Base

// TODO: Consider refactoring this to a `ViewModifier`.
// Consider renaming to QueryForm
struct GenericForm<FVM: FormViewModelProtocol, Content: View>: View {
    @ObservedObject private var viewModel: FVM
    @EnvironmentObject private var state: RequestState
    @EnvironmentObject private var common: CommonViewModel
    
    private let titleKey: LocalizedStringKey
    private let content: () -> Content
    
    init(_ titleKey: LocalizedStringKey, viewModel: FVM, @ViewBuilder content: @escaping () -> Content) {
        self.titleKey = titleKey
        self.viewModel = viewModel
        self.content = content
    }
    
    var body: some View {
        Form {
            content()
            
            Section {
                // TODO: use `AsyncButton`
                Button("Send Request") {
                    Task {
                        await viewModel.execute()
                        if let result = viewModel.result {
                            switch result {
                            case .success(let output):
                                state.log(output)
                            case .failure(let error):
                                state.resultText = error.localizedDescription
                            }
                        }
                    }
                }
                .disabled(!viewModel.isValid || viewModel.isLoading)
                .buttonStyle(.borderless)
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                }
            }
            
            if !state.resultText.isEmpty {
                Section("Response JSON") {
                    ScrollView {
                        Text(state.resultText)
                            .font(.system(.footnote, design: .monospaced))
                            .padding(4)
                            .textSelection(.enabled)
                    }
                    .frame(maxHeight: 300)
                }
            }
        }
        
        .navigationTitle(titleKey)
        .navigationBarTitleDisplayMode(.inline)
    }
}
