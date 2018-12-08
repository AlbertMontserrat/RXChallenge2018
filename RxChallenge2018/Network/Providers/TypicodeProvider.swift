import Foundation
import Moya
import RxSwift

protocol TypicodeService {
    func getPosts() -> Single<[Post]>
    func getUser(with id: Int) -> Single<User>
    func getComments(for postId: Int) -> Single<[Comment]>
}

class TypicodeProvider: TypicodeService {
    
    private let networkProvider: NetworkProvider
    
    init(networkProvider: NetworkProvider = MoyaNetworkProvider.shared) {
        self.networkProvider = networkProvider
    }
    
    func getPosts() -> Single<[Post]> {
        let endpoint = Endpoint(baseURL: Hosts.typicode.getBaseURL(),
                                path: "posts")
        return networkProvider.requestDecodableArray(endpoint)
    }
    
    func getUser(with id: Int) -> Single<User> {
        let endpoint = Endpoint(baseURL: Hosts.typicode.getBaseURL(),
                                path: "users/\(id)")
        return networkProvider.requestDecodable(endpoint, customPath: nil)
    }
    
    func getComments(for postId: Int) -> Single<[Comment]> {
        let endpoint = Endpoint(baseURL: Hosts.typicode.getBaseURL(),
                                path: "posts/\(postId)/comments")
        return networkProvider.requestDecodableArray(endpoint)
    }
}
