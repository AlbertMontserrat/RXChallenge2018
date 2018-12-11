@testable import RxChallenge2018
import RxSwift
import RxChallengeDomain

class DetailPresenterInterfaceMock: DetailPresenterInterface {
    var configureTitlesTimesCalled = 0
    let setupTitlesSubject = BehaviorSubject<DetailData?>(value: nil)
    var error: NetworkError?
    
    let disposeBag = DisposeBag()
    
    func configureTitles() {
        configureTitlesTimesCalled += 1
    }
    
    func setupTitles(with detailObservable: Observable<DetailData>) {
        detailObservable.bind(to: setupTitlesSubject).disposed(by: disposeBag)
    }
    
    func showError(with error: NetworkError) {
        self.error = error
    }
}
