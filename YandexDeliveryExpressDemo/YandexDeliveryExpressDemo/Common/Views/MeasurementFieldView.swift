//
//  MeasurementFieldView.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 7/30/25.
//


//  Rentel
//
//  Created by Paul Buktab on 7/30/25.
//
import SwiftUI
// TODO: implement `MeasurementFieldView<U: Unit>`

struct MeasurementFieldView<U: Unit>: View {
    internal init(_ pickerTitleKey: LocalizedStringKey = "unit", placeholderTitleKey: LocalizedStringKey = "value", measurement: Binding<Measurement<U>>, options: [U]) {
        self.pickerTitleKey = pickerTitleKey
        self.placeholderTitleKey = placeholderTitleKey
        self._measurement = measurement
        self.options = options
    }
    
    let pickerTitleKey: LocalizedStringKey
    let placeholderTitleKey: LocalizedStringKey
    @Binding var measurement: Measurement<U>
    let options: [U]
    
    var body: some View {
        // Stepper(value: $measurement.value, in: 0...1000) { }
        TextField(placeholderTitleKey, value: $measurement.value, format: .number)
            .keyboardType(.decimalPad)
        Picker(pickerTitleKey, selection: .init(get: { measurement.unit }, set: { measurement = Measurement(value: measurement.value, unit: $0) })) {
            ForEach(options, id: \.symbol) { u in
                Text(u.symbol).tag(u)
            }
        }
    }
}

#if DEBUG
#Preview {
    @Previewable @State var distance = Measurement(value: 5, unit: UnitLength.kilometers)
    Form {
        LabeledContent("Distance") {
            MeasurementFieldView("Units", measurement: $distance, options: [.meters, .kilometers, .miles])
        }
        LabeledContent("Сalculated distance", value: distance, format: .measurement(width: .abbreviated))
    }
}
#endif
