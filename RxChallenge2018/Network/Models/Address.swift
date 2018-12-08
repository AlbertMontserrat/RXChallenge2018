import Foundation

struct Address {
    let street: String?
    let suite: String?
    let city: String?
    let zipcode: String?
    let geoPoint: GeoPoint?
}

extension Address: Codable {
    enum CodingKeys: String, CodingKey {
        case street, suite, city, zipcode, geoPoint
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self = Address(street: try? values.decode(String.self, forKey: .street),
                       suite: try? values.decode(String.self, forKey: .suite),
                       city: try? values.decode(String.self, forKey: .city),
                       zipcode: try? values.decode(String.self, forKey: .zipcode),
                       geoPoint: try? values.decode(GeoPoint.self, forKey: .geoPoint))
    }
}
