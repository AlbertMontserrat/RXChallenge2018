import Foundation
import Moya
import RxSwift

protocol TypicodeService {
    func getPosts() -> Single<[Post]>
}

class TypicodeProvider: TypicodeService {
    
    private let networkProvider: NetworkProvider
    
    init(networkProvider: NetworkProvider = MoyaNetworkProvider.shared) {
        self.networkProvider = networkProvider
    }
    
    func getPosts() -> Single<[Post]>  {
        let endpoint = Endpoint(baseURL: Hosts.typicode.getBaseURL(),
                                path: "posts")
        return networkProvider.requestDecodableArray(endpoint)
    }
}
