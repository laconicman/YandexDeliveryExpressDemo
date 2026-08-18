// Sources/ExpressDemo/components/EditorComponents.swift
/*
import SwiftUI
import YandexDeliveryExpressAPI

// MARK: - Cargo Point Editor

struct RoutePointEditor: View {
    @Binding var routePoint: Components.Schemas.RoutePoint
    let index: Int
    let canDelete: Bool
    let onDelete: () -> Void
    
    var body: some View {
        DisclosureGroup("Cargo Point \(index + 1)") {
            VStack(alignment: .leading, spacing: 8) {
                Field("Point ID", value: $routePoint.pointId)
                Field("Visit Order", value: $routePoint.visitOrder)
                
                Picker("Type", selection: $routePoint._type) {
                    ForEach(Components.Schemas.PointType.allCases, id: \.self) { type in
                        Text(type.rawValue.capitalized).tag(type)
                    }
                }
                
                DisclosureGroup("Address") {
                    PointAddressEditor(address: $routePoint.address)
                }
                
                DisclosureGroup("Contact") {
                    ContactEditor(contact: $routePoint.contact)
                }
                
                Field("External Order ID", value: Binding(
                    get: { routePoint.externalOrderId ?? "" },
                    set: { routePoint.externalOrderId = $0.isEmpty ? nil : $0 }
                ))
                
                Toggle("Skip Confirmation", isOn: Binding(
                    get: { routePoint.skipConfirmation ?? false },
                    set: { routePoint.skipConfirmation = $0 ? true : nil }
                ))
                
                if canDelete {
                    Button("Delete Route Point", role: .destructive) {
                        onDelete()
                    }
                }
            }
        }
    }
}

// MARK: - Point Address Editor

struct PointAddressEditor: View {
    @Binding var address: Components.Schemas.Address
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Field("Longitude", value: Binding(
                    get: { address.coordinates?.first ?? 0.0 },
                    set: { newValue in
                        if address.coordinates?.count ?? 0 > 0 {
                            address.coordinates?[0] = newValue
                        } else {
                            address.coordinates = [newValue, 0.0]
                        }
                    }
                ))
                
                Field("Latitude", value: Binding(
                    get: { (address.coordinates?.count ?? 0) > 1 ? address.coordinates![1] : 0.0 },
                    set: { newValue in
                        if (address.coordinates?.count ?? 0) > 1  {
                            address.coordinates![1] = newValue
                        } else if address.coordinates?.count == 1 {
                            address.coordinates!.append(newValue)
                        } else {
                            address.coordinates = [0.0, newValue]
                        }
                    }
                ))
            }
            
            Field("Full Name", value: $address.fullname)
            
            DisclosureGroup("Address Details") {
                Field("Country", value: Binding(
                    get: { address.country ?? "" },
                    set: { address.country = $0.isEmpty ? nil : $0 }
                ))
                
                Field("City", value: Binding(
                    get: { address.city ?? "" },
                    set: { address.city = $0.isEmpty ? nil : $0 }
                ))
                
                Field("Street", value: Binding(
                    get: { address.street ?? "" },
                    set: { address.street = $0.isEmpty ? nil : $0 }
                ))
                
                Field("Building", value: Binding(
                    get: { address.building ?? "" },
                    set: { address.building = $0.isEmpty ? nil : $0 }
                ))
                
                Field("Porch", value: Binding(
                    get: { address.porch ?? "" },
                    set: { address.porch = $0.isEmpty ? nil : $0 }
                ))
                
                Field("Floor", value: Binding(
                    get: { address.sfloor ?? "" },
                    set: { address.sfloor = $0.isEmpty ? nil : $0 }
                ))
                
                Field("Apartment", value: Binding(
                    get: { address.sflat ?? "" },
                    set: { address.sflat = $0.isEmpty ? nil : $0 }
                ))
                
                Field("Door Code", value: Binding(
                    get: { address.doorCode ?? "" },
                    set: { address.doorCode = $0.isEmpty ? nil : $0 }
                ))
                
                TextField("Comment", text: Binding(
                    get: { address.comment ?? "" },
                    set: { address.comment = $0.isEmpty ? nil : $0 }
                ), axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(2...4)
            }
        }
    }
}
*/

