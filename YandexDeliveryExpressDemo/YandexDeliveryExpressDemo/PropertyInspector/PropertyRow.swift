//
//  PropertyRow.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 7/23/25.
//

import SwiftUI

struct PropertyRow: View {
    let node: NamedDisplayValue
    
    var body: some View {
        HStack {
            Text(node.description)
                .fontWeight(.medium)
            Spacer()
            Text(node.displayValue)
                .foregroundColor(.secondary)
                .font(node.attributed ? .caption : .body)
                .textSelection(.enabled)
                // .monospaced() // Since iOS 16.4
        }
    }
}
