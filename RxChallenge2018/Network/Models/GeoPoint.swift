import Foundation

struct GeoPoint {
    let lat: String?
    let lng: String?
}

extension GeoPoint: Codable {
    enum CodingKeys: String, CodingKey {
        case lat, lng
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self = GeoPoint(lat: try? values.decode(String.self, forKey: .lat),
                        lng: try? values.decode(String.self, forKey: .lng))
    }
}

