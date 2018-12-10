import RxSwift

public protocol TypicodeService {
    func getPosts() -> Single<[Post]>
    func getUser(with id: Int) -> Single<User>
    func getComments(for postId: Int) -> Single<[Comment]>
}
