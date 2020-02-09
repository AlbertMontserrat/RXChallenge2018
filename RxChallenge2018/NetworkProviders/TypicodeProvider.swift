import RxChallengeDomain
import RxSwift

private extension Host {
    static let typicode = Host(url: URL(string: "https://jsonplaceholder.typicode.com")!)
}

public protocol TypicodeService {
    func getPosts() -> Single<[Post]>
    func getUser(with id: Int) -> Single<User>
    func getComments(for postId: Int) -> Single<[Comment]>
}

public class TypicodeProvider: TypicodeService {
    
    private let networkProvider: NetworkProvider
    
    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
    
    public func getPosts() -> Single<[Post]> {
        let endpoint = Endpoint(host: .typicode,
                                path: "posts")
        return networkProvider.requestDecodable(endpoint, customPath: nil)
    }
    
    public func getUser(with id: Int) -> Single<User> {
        let endpoint = Endpoint(host: .typicode,
                                path: "users/\(id)")
        return networkProvider.requestDecodable(endpoint, customPath: nil)
    }
    
    public func getComments(for postId: Int) -> Single<[Comment]> {
        let endpoint = Endpoint(host: .typicode,
                                path: "posts/\(postId)/comments")
        return networkProvider.requestDecodable(endpoint, customPath: nil)
    }
}
