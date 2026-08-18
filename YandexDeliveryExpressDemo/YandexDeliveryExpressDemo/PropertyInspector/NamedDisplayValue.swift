//
//  NamedDisplayValue.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 7/23/25.
//

protocol NamedDisplayValue: CustomStringConvertible {
    var name: String { get }
    // var displayName: String { get }
    var displayValue: String { get }
    var attributed: Bool { get } // TODO: Придумать структуру получше
}
