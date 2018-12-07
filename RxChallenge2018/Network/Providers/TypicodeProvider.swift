import Foundation
import Moya
import RxSwift

protocol TypicodeService {
    func getPosts(_ endpoint: TypicodeEndpoint) -> Single<Post>
}

class TypicodeProvider: TypicodeService {
    
    private let networkProvider: NetworkProvider
    
    init(networkProvider: NetworkProvider = MoyaNetworkProvider.shared) {
        self.networkProvider = networkProvider
    }
    
    func getPosts(_ endpoint: TypicodeEndpoint = TypicodeEndpoint()) -> Single<Post>  {
        return networkProvider.requestDecodable(target.getPosts(), customPath: nil)
    }
}
