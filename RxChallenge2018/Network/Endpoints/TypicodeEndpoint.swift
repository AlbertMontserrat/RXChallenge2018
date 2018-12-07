import Foundation
import Moya

struct TypicodeEndpoint {
    
    func getPosts() -> Endpoint {
        let parameters: [String: Any] = [:]
        return Endpoint(baseURL: Hosts.typicode.getBaseURL(),
                        path: "post",
                        parameters: parameters)
    }
}
