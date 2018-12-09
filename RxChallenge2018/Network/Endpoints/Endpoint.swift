import Foundation
import Moya

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

struct Endpoint {
    
    let baseURL: URL
    let path: String
    let httpMethod: EndpointMethod
    var sampleData: Data
    let headers: [String: String]?
    let parameters: [String : Any]?
    let parametersEncoding: ParameterEncoding
    
    init(baseURL: URL, path: String = "", httpMethod: EndpointMethod = .get, sampleData: Data = Data(), headers: [String: String]? = nil, parameters: [String : Any]? = nil, parametersEncoding: ParameterEncoding = URLEncoding.default) {
        self.baseURL = baseURL
        self.path = path
        self.httpMethod = httpMethod
        self.sampleData = sampleData
        self.headers = headers
        self.parameters = parameters
        self.parametersEncoding = parametersEncoding
    }
}

//MARK - Cache extension
extension Endpoint {
    var key: String {
        return [httpMethod.rawValue, baseURL.absoluteString, path, String(describing: parameters ?? [:])].joined(separator: "|")
    }
}
