public struct User {
    public let id: Int?
    public let name: String?
    public let username: String?
    public let email: String?
    public let address: Address?
    
    public init(id: Int? = nil, name: String? = nil, username: String? = nil, email: String? = nil, address: Address? = nil) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.address = address
    }
}
