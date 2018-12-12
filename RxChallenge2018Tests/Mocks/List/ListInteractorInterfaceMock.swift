@testable import RxChallenge2018
import RxSwift

class ListInteractorInterfaceMock: ListInteractorInterface {
    var initializeTitlesTimesCalled = 0
    let searchSubject = BehaviorSubject<String?>(value: nil)
    let startupSubject = BehaviorSubject<()?>(value: nil)
    let refreshSubject = BehaviorSubject<()?>(value: nil)
    let selectionIdSubject = BehaviorSubject<Int?>(value: nil)

    private let disposeBag = DisposeBag()

    func initializeTitles() {
        initializeTitlesTimesCalled += 1
    }
    
    func configureObservables(startupObservable: Observable<()>, refreshObservable: Observable<()>, searchObservable: Observable<String>, selectionIdObservable: Observable<Int>) {
        startupObservable.bind(to: startupSubject).disposed(by: disposeBag)
        refreshObservable.bind(to: refreshSubject).disposed(by: disposeBag)
        searchObservable.bind(to: searchSubject).disposed(by: disposeBag)
        selectionIdObservable.bind(to: selectionIdSubject).disposed(by: disposeBag)
    }
}
