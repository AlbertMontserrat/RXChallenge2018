import Foundation
import RxChallengeDomain

extension GeoPoint: Codable {
    enum CodingKeys: String, CodingKey {
        case lat, lng
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self = GeoPoint(lat: try? values.decode(String.self, forKey: .lat),
                        lng: try? values.decode(String.self, forKey: .lng))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lat, forKey: .lat)
        try container.encode(lng, forKey: .lng)
    }
}

