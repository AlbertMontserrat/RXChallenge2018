import RxChallengeDomain
import RxSwift

public class TypicodeProvider: TypicodeService {
    
    private let networkProvider: NetworkProvider
    
    public convenience init() {
        self.init(networkProvider: MoyaNetworkProvider.shared)
    }
    
    init(networkProvider: NetworkProvider = MoyaNetworkProvider.shared) {
        self.networkProvider = networkProvider
    }
    
    public func getPosts() -> Single<[Post]> {
        let endpoint = Endpoint(baseURL: Hosts.typicode.getBaseURL(),
                                path: "posts")
        return networkProvider.requestDecodableArray(endpoint)
    }
    
    public func getUser(with id: Int) -> Single<User> {
        let endpoint = Endpoint(baseURL: Hosts.typicode.getBaseURL(),
                                path: "users/\(id)")
        return networkProvider.requestDecodable(endpoint, customPath: nil)
    }
    
    public func getComments(for postId: Int) -> Single<[Comment]> {
        let endpoint = Endpoint(baseURL: Hosts.typicode.getBaseURL(),
                                path: "posts/\(postId)/comments")
        return networkProvider.requestDecodableArray(endpoint)
    }
}
