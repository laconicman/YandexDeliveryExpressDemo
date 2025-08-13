//
//  ItemSizeEditor.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 8/11/25.
//
import SwiftUI
import YandexDeliveryExpressAPI

// MARK: - Item Size Editor

struct ItemSizeEditor: View {
    @Binding var size: Components.Schemas.ItemSize
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Field("Length (m)", value: $size.length)
            Field("Width (m)", value: $size.width)
            Field("Height (m)", value: $size.height)
        }
    }
}

#Preview {
    ItemSizeEditor(size: .constant(.exampleSmallBox))
        .padding()
}
