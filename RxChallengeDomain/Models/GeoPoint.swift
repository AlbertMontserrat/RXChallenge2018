public struct GeoPoint {
    public let lat: String?
    public let lng: String?
    
    public init(lat: String? = nil, lng: String? = nil) {
        self.lat = lat
        self.lng = lng
    }
}
