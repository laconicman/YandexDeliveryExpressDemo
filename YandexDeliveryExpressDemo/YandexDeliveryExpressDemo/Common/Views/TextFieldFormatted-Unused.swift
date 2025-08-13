// Скорее всего не пригодится
/*
import SwiftUI

/// Альтернатива `TextField` обеспечивающая единообразное форматирование и отображение полей на проекте.
struct TextFieldFormatted<T: LosslessStringConvertible>: View {
    let title: String
    @Binding var value: T
    
    var body: some View {
        TextField(title, value: $value, format: LosslessStringConvertibleFormatStyle<T>())
            .textFieldStyle(.roundedBorder)
            .autocorrectionDisabled()
    }
}

// Custom FormatStyle for LosslessStringConvertible types
struct LosslessStringConvertibleFormatStyle<T: LosslessStringConvertible>: ParseableFormatStyle {
    var parseStrategy: LosslessStringConvertibleParseStrategy<T> = .init()
    
    func format(_ value: T) -> String {
        return String(value)
    }
}

struct LosslessStringConvertibleParseStrategy<T: LosslessStringConvertible>: ParseStrategy {
    func parse(_ value: String) throws -> T {
        guard let result = T(value) else {
            throw ParseError.invalidInput
        }
        return result
    }
}

enum ParseError: Error {
    case invalidInput
}
*/
