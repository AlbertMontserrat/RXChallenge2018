@testable import RxChallenge2018
import RxSwift

class ListInteractorInterfaceMock: ListInteractorInterface {
    var initializeTitlesTimesCalled = 0
    let searchSubject = BehaviorSubject<String?>(value: nil)
    let startupSubject = BehaviorSubject<()?>(value: nil)
    let refreshSubject = BehaviorSubject<()?>(value: nil)
    let selectionIdSubject = BehaviorSubject<Int?>(value: nil)
    var configureSelectionTimesCalled = 0

    private let disposeBag = DisposeBag()

    func initializeTitles() {
        initializeTitlesTimesCalled += 1
    }
    
    func configure(with startupObservable: Observable<()>, refreshObservable: Observable<()>, searchObservable: Observable<String>) {
        startupObservable.bind(to: startupSubject).disposed(by: disposeBag)
        refreshObservable.bind(to: refreshSubject).disposed(by: disposeBag)
        searchObservable.bind(to: searchSubject).disposed(by: disposeBag)
    }
    
    func configureSelection(with selectionIdObservable: Observable<Int>) {
        configureSelectionTimesCalled += 1
        selectionIdObservable.bind(to: selectionIdSubject).disposed(by: disposeBag)
    }
}
