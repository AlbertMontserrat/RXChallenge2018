import Foundation
import RxChallengeDomain

extension User: Decodable {
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
}
