import Foundation
import RxChallengeDomain

extension User: Codable {
    enum CodingKeys: String, CodingKey {
        case id, name, username, email, address
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self = User(id: try? values.decode(Int.self, forKey: .id),
                    name: try? values.decode(String.self, forKey: .name),
                    username: try? values.decode(String.self, forKey: .username),
                    email: try? values.decode(String.self, forKey: .email),
                    address: try? values.decode(Address.self, forKey: .address))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(username, forKey: .username)
        try container.encode(email, forKey: .email)
        try container.encode(address, forKey: .address)
    }
}
