import Foundation

struct Post {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}

extension Post: Codable {
    enum CodingKeys: String, CodingKey {
        case id, userId, title, body
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self = Post(id: try values.decode(Int.self, forKey: .id),
                    userId: try values.decode(Int.self, forKey: .userId),
                    title: try values.decode(String.self, forKey: .title),
                    body: try values.decode(String.self, forKey: .body))
    }
}
