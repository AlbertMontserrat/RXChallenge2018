import Foundation
import RxSwift

struct DetailGateway {
    
    let provider: TypicodeService
    
    init(provider: TypicodeService) {
        self.provider = provider
    }
    
    func getUser(with id: Int) -> Single<User> {
        return provider.getUser(with: id)
    }
    
    func getComments(for postId: Int) -> Single<[Comment]> {
        return provider.getComments(for: postId)
    }
}
