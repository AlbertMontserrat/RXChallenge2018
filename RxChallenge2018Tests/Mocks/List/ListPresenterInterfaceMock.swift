@testable import RxChallenge2018
import RxSwift
import RxChallengeDomain

class ListPresenterInterfaceMock: ListPresenterInterface {
    var configureTitlesTimesCalled = 0
    let postsSubject = BehaviorSubject<PostsWithQuery?>(value: nil)
    var error: NetworkError?
    
    private let disposeBag = DisposeBag()

    func configureTitles() {
        configureTitlesTimesCalled += 1
    }
    
    func setupPosts(with postsObservable: Observable<PostsWithQuery>) {
        postsObservable.bind(to: postsSubject).disposed(by: disposeBag)
    }
    
    func showError(with error: NetworkError) {
        self.error = error
    }
}
