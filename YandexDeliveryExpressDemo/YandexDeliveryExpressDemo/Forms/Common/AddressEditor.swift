//
//  Untitled.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 8/11/25.
//

// TODO: Generalize: split m/vm, domain/appliction/logic.

import SwiftUI
import BetterBinding
import YandexDeliveryExpressAPI

struct AddressEditor: View {
    @Binding var address: Components.Schemas.Address
    
    var body: some View {
        Field("Full Name", value: $address.fullname)
            .textContentType(.fullStreetAddress)
        
        // TODO: Extract to `CoordinatesEditor`
        HStack {
            Field("Longitude", value: Binding( // TODO: deduplicate with func
                get: { address.coordinates?[safe: 0] ?? 0.0 },
                set: {
                    if address.coordinates?[safe: 0] != nil {
                        address.coordinates![0] = $0
                    } else {
                        address.coordinates = [$0, 0.0]
                    }
                }
            ))
            
            Field("Latitude", value: Binding(
                get: { address.coordinates?[safe: 1] ?? 0.0  },
                set: {
                    if address.coordinates?[safe: 1] != nil {
                        address.coordinates![1] = $0
                    } else if address.coordinates?.count == 1 {
                        address.coordinates!.append($0)
                    } else {
                        address.coordinates = [0.0, $0]
                    }
                }
            ))
        }
        
        DisclosureGroup("Address Details") {
            Field("Country", value: $address.country ??? "")
                .textContentType(.addressState)
            
            Field("City", value: $address.city ??? "")
                .textContentType(.addressCity)
            
            Field("Street", value: $address.street ??? "")
                .textContentType(.streetAddressLine1)
            
            Field("Building", value: $address.building ??? "")
            
            Field("Porch", value: $address.porch ??? "")
            
            Field("Floor", value: $address.sfloor ??? "")
            
            Field("Apartment", value: $address.sflat ?? "")
        }
        
    }
}

#Preview {
    AddressEditor(address: .constant(.exampleMoscowApartment))
        .padding()
}
