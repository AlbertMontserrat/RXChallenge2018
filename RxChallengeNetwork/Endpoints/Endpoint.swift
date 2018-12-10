import Foundation

enum EndpointMethod: String {
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

enum EndpointParameterEncoding {
    case url
    case json
}

struct Endpoint {
    
    let baseURL: URL
    let path: String
    let httpMethod: EndpointMethod
    var sampleData: Data
    let headers: [String: String]?
    let parameters: [String : Any]?
    let parameterEncoding: EndpointParameterEncoding
    
    init(baseURL: URL, path: String = "", httpMethod: EndpointMethod = .get, sampleData: Data = Data(), headers: [String: String]? = nil, parameters: [String : Any]? = nil, parameterEncoding: EndpointParameterEncoding = .url) {
        self.baseURL = baseURL
        self.path = path
        self.httpMethod = httpMethod
        self.sampleData = sampleData
        self.headers = headers
        self.parameters = parameters
        self.parameterEncoding = parameterEncoding
    }
}

//MARK - Cache extension
extension Endpoint {
    var key: String {
        return [httpMethod.rawValue, baseURL.absoluteString, path, String(describing: parameters ?? [:])].joined(separator: "|")
    }
}
