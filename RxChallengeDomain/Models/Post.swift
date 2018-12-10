public struct Post {
    public let id: Int?
    public let userId: Int?
    public let title: String?
    public let body: String?
    
    public init(id: Int? = nil, userId: Int? = nil, title: String? = nil, body: String? = nil) {
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
    }
}
