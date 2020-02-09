import Foundation
import RxChallengeDomain

extension Post: Codable {
    enum CodingKeys: String, CodingKey {
        case id, userId, title, body
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self = Post(id: try? values.decode(Int.self, forKey: .id),
                    userId: try? values.decode(Int.self, forKey: .userId),
                    title: try? values.decode(String.self, forKey: .title),
                    body: try? values.decode(String.self, forKey: .body))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(title, forKey: .title)
        try container.encode(body, forKey: .body)
    }
}
