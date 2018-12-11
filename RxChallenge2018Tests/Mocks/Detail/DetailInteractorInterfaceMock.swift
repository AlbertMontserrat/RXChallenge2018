@testable import RxChallenge2018
import RxSwift

class DetailInteractorInterfaceMock: DetailInteractorInterface {
    var initializeTitlesTimesCalled = 0
    let startupSubject = BehaviorSubject<()?>(value: nil)
    
    let disposeBag = DisposeBag()
    
    func initializeTitles() {
        initializeTitlesTimesCalled += 1
    }
    
    func setupStartupObservable(_ startupObservable: Observable<()>) {
        startupObservable.bind(to: startupSubject).disposed(by: disposeBag)
    }
}
