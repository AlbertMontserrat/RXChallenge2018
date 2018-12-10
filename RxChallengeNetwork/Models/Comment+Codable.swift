import Foundation
import RxChallengeDomain

extension Comment: Codable {
    enum CodingKeys: String, CodingKey {
        case id, postId, name, email, body
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self = Comment(id: try? values.decode(Int.self, forKey: .id),
                    postId: try? values.decode(Int.self, forKey: .postId),
                    name: try? values.decode(String.self, forKey: .name),
                    email: try? values.decode(String.self, forKey: .email),
                    body: try? values.decode(String.self, forKey: .body))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(postId, forKey: .postId)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(body, forKey: .body)
    }
}
