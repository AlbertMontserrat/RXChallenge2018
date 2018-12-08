import Foundation

struct Comment {
    let id: Int?
    let postId: Int?
    let name: String?
    let email: String?
    let body: String?
}

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
}
