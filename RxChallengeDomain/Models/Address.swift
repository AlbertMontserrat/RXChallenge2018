public struct Address {
    public let street: String?
    public let suite: String?
    public let city: String?
    public let zipcode: String?
    public let geoPoint: GeoPoint?
    
    public init(street: String? = nil, suite: String? = nil, city: String? = nil, zipcode: String? = nil, geoPoint: GeoPoint? = nil) {
        self.street = street
        self.suite = suite
        self.city = city
        self.zipcode = zipcode
        self.geoPoint = geoPoint
    }
}
