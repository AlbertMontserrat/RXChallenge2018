import Foundation
import Moya
import RxSwift

protocol TypicodeService {
    func getPosts(_ target: TypicodeEndpoint, page: Int) -> Single<Post>
}

class TypicodeProvider: TypicodeService {
    
    private let networkProvider: NetworkProvider
    
    init(networkProvider: NetworkProvider = MoyaNetworkProvider.shared) {
        self.networkProvider = networkProvider
    }
    
    func getPosts(_ target: TypicodeEndpoint = TypicodeEndpoint(), page: Int) -> Single<Post>  {
        return networkProvider.requestDecodable(target.getMovies(page: page))
    }
}
