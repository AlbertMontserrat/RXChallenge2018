@testable import RxChallenge2018
import RxSwift

class ListInteractorInterfaceMock: ListInteractorInterface {
    var initializeTitlesTimesCalled = 0
    let searchSubject = BehaviorSubject<String?>(value: nil)
    let selectionIdSubject = BehaviorSubject<Int?>(value: nil)

    private let disposeBag = DisposeBag()

    func initializeTitles() {
        initializeTitlesTimesCalled += 1
    }
    
    func configure(with searchObservable: Observable<String>) {
        searchObservable.bind(to: searchSubject).disposed(by: disposeBag)
    }
    
    func configureSelection(with selectionIdObservable: Observable<Int>) {
        selectionIdObservable.bind(to: selectionIdSubject).disposed(by: disposeBag)
    }
}
