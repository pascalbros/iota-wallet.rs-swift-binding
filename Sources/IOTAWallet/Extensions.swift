import Foundation

extension URL {
    static var libraryDirectory: URL {
        let paths = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension String {
    var pointerValue: UnsafePointer<CChar>? {
        NSString(string: self).utf8String
    }
    
    var decodedResponse: WalletGenericResponse? {
        WalletGenericResponse.decode(self)
    }
}

extension UnsafePointer where Pointee == CChar {
    var stringValue: String? {
        return String(cString: self)
    }
}

extension Dictionary {
    var json: String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}

extension Decodable {
    static func decode(_ from: String?) -> Self? {
        guard let from = from else { return nil }
        let data = Data(from.utf8)
        return (try? JSONDecoder().decode(self.self, from: data))
    }
}
