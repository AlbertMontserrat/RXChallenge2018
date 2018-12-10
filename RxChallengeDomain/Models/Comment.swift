public struct Comment {
    public let id: Int?
    public let postId: Int?
    public let name: String?
    public let email: String?
    public let body: String?
    
    public init(id: Int? = nil, postId: Int? = nil, name: String? = nil, email: String? = nil, body: String? = nil) {
        self.id = id
        self.postId = postId
        self.name = name
        self.email = email
        self.body = body
    }
}
