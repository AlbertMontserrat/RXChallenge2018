import RxChallengeDomain

struct AppProviders {
    let typicodeProvider: TypicodeService
}

//Fake
import RxSwift
struct TypicodeServiceFake: TypicodeService {
    func getPosts() -> Single<[Post]> {
        return Single.just([])
    }
    
    func getUser(with id: Int) -> Single<User> {
        return Single.just(User(id: nil, name: nil, username: nil, email: nil, address: nil))
    }
    
    func getComments(for postId: Int) -> Single<[Comment]> {
        return Single.just([])
    }
}
