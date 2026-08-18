//
//  Untitled.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 8/13/25.
//

import YandexDeliveryExpressAPI

extension Components.Schemas.PointType: SystemImageRepresentable {
    public var systemName: String {
        switch self {
        case .source:
            "point.bottomleft.forward.to.arrow.triangle.scurvepath"
        case .destination:
            "point.topright.arrow.triangle.backward.to.point.bottomleft.filled.scurvepath"
        case ._return:
            "return"
        }
    }
}
