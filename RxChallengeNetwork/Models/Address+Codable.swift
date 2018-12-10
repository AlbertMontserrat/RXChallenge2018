import Foundation
import RxChallengeDomain

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
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(street, forKey: .street)
        try container.encode(suite, forKey: .suite)
        try container.encode(city, forKey: .city)
        try container.encode(zipcode, forKey: .zipcode)
        try container.encode(geoPoint, forKey: .geoPoint)
    }
}
