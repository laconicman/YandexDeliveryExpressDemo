import SwiftUI
import YandexDeliveryExpressAPI

struct CalculateOffersForm: View {
    @StateObject private var viewModel = CalculateOffersViewModel()
    @EnvironmentObject private var common: CommonViewModel
    
    var body: some View {
        GenericForm("Calculate Offers", viewModel: viewModel) {
            SinglePicker("Language", systemImage: "globe", selection: $viewModel.acceptLanguage)
                .pickerStyle(.segmented)
            RoutePointsBaseSection(routePoints: $viewModel.routePoints)
            ItemsSection(items: $viewModel.items, routePoints: viewModel.routePoints)
            RequirementsSection(taxiClasses: $viewModel.taxiClasses, cargoType: $viewModel.cargoType, cargoOptions: $viewModel.cargoOptions, cargoLoaders: $viewModel.cargoLoaders, proCourier: $viewModel.proCourier, skipDoorToDoor: $viewModel.skipDoorToDoor, due: $viewModel.due)
            // TODO: Move to `GenericForm`
            if case let .success(result) = viewModel.result, let json = try? result.ok.body.json {
                FilteredPropertyInspectorView(object: json)
                    .onAppear {
                        common.calalculatedOffers = json.offers
                    }
            }
        }
    }
    
}

#Preview {
    @Previewable @StateObject var state = RequestState()
    CalculateOffersForm()
        .environmentObject(state)
}
