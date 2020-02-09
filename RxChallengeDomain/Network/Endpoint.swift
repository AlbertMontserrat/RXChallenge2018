import Foundation

public struct Host {
    public let url: URL
    
    public init(url: URL) {
        self.url = url
    }
}

public enum EndpointMethod: String {
    case options
    case get
    case head
    case post
    case put
    case patch
    case delete
    case trace
    case connect
}

public enum EndpointParameterEncoding {
    case url
    case json
}

public struct Endpoint {
    
    public let host: Host
    public let path: String
    public let httpMethod: EndpointMethod
    public var sampleData: Data
    public let headers: [String: String]?
    public let parameters: [String : Any]?
    public let parameterEncoding: EndpointParameterEncoding
    
    public init(host: Host, path: String = "", httpMethod: EndpointMethod = .get, sampleData: Data = Data(), headers: [String: String]? = nil, parameters: [String : Any]? = nil, parameterEncoding: EndpointParameterEncoding = .url) {
        self.host = host
        self.path = path
        self.httpMethod = httpMethod
        self.sampleData = sampleData
        self.headers = headers
        self.parameters = parameters
        self.parameterEncoding = parameterEncoding
    }
}
