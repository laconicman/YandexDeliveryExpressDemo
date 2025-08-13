// Sources/ExpressDemo/forms/GenericForm.swift
import SwiftUI
import YandexDeliveryExpressAPI

// MARK: - Generic Form Base

struct GenericForm<FVM: FormViewModelProtocol, Content: View>: View {
    @ObservedObject private var viewModel: FVM
    @EnvironmentObject private var state: RequestState
    
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

// MARK: - Get Claim Info Form

struct GetClaimInfoForm: View {
    @StateObject private var viewModel = GetClaimInfoViewModel()
    
    var body: some View {
        GenericForm("Get Claim Info", viewModel: viewModel) {
            AnyView(
                Group {
                    languageSection
                    claimIdSection
                }
            )
        }
    }
    
    @ViewBuilder
    private var languageSection: some View {
        Section("Language") {
            Picker("Accept Language", selection: $viewModel.acceptLanguage) {
                Text("Russian").tag(Components.Parameters.AcceptLanguage.ru)
                Text("English").tag(Components.Parameters.AcceptLanguage.en)
            }
            .pickerStyle(.segmented)
        }
    }
    
    @ViewBuilder
    private var claimIdSection: some View {
        Section("Claim ID") {
            TextField("Claim ID", text: $viewModel.claimId)
                .textFieldStyle(.roundedBorder)
        }
    }
}

// MARK: - Accept Claim Form

struct AcceptClaimForm: View {
    @StateObject private var viewModel = AcceptClaimViewModel()
    
    var body: some View {
        GenericForm("Accept Claim", viewModel: viewModel) {
            AnyView(
                Group {
                    languageSection
                    claimIdSection
                    versionSection
                }
            )
        }
    }
    
    @ViewBuilder
    private var languageSection: some View {
        Section("Language") {
            Picker("Accept Language", selection: $viewModel.acceptLanguage) {
                Text("Russian").tag(Components.Parameters.AcceptLanguage.ru)
                Text("English").tag(Components.Parameters.AcceptLanguage.en)
            }
            .pickerStyle(.segmented)
        }
    }
    
    @ViewBuilder
    private var claimIdSection: some View {
        Section("Claim ID") {
            TextField("Claim ID", text: $viewModel.claimId)
                .textFieldStyle(.roundedBorder)
        }
    }
    
    @ViewBuilder
    private var versionSection: some View {
        Section("Version") {
            Field("Version", value: $viewModel.version)
        }
    }
}

// MARK: - Cancel Claim Form

struct CancelClaimForm: View {
    @StateObject private var viewModel = CancelClaimViewModel()
    
    var body: some View {
        GenericForm("Cancel Claim", viewModel: viewModel) {
            AnyView(
                Group {
                    languageSection
                    claimIdSection
                    versionSection
                    cancellationSection
                }
            )
        }
    }
    
    @ViewBuilder
    private var languageSection: some View {
        Section("Language") {
            Picker("Accept Language", selection: $viewModel.acceptLanguage) {
                Text("Russian").tag(Components.Parameters.AcceptLanguage.ru)
                Text("English").tag(Components.Parameters.AcceptLanguage.en)
            }
            .pickerStyle(.segmented)
        }
    }
    
    @ViewBuilder
    private var claimIdSection: some View {
        Section("Claim ID") {
            TextField("Claim ID", text: $viewModel.claimId)
                .textFieldStyle(.roundedBorder)
        }
    }
    
    @ViewBuilder
    private var versionSection: some View {
        Section("Version") {
            Field("Version", value: $viewModel.version)
        }
    }
    
    @ViewBuilder
    private var cancellationSection: some View {
        Section("Cancellation") {
            Picker("Cancel State", selection: $viewModel.cancelState) {
                ForEach(Components.Schemas.CancelState.allCases) { state in
                    Text(state.rawValue.capitalized).tag(state)
                }
            }
            .pickerStyle(.segmented)
            
//            TextField("Reason", text: $viewModel.reason, axis: .vertical)
//                .textFieldStyle(.roundedBorder)
//                .lineLimit(3...6)
        }
    }
}
