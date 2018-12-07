import Foundation
import RxSwift

struct ListGateway {
    
    let provider: TypicodeService
    
    init(provider: TypicodeService) {
        self.provider = provider
    }
    
    func getPosts() -> Single<[Post]> {
        return provider.getPosts()
    }
}
