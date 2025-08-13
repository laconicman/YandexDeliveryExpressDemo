import Foundation

extension JSONEncoder {
    static let prettyPrinted: JSONEncoder = {
        $0.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        if #available(iOS 13.0, macOS 10.15, *) {
            $0.outputFormatting.insert(.withoutEscapingSlashes)
        }
        
        return $0
    }(JSONEncoder())
}
