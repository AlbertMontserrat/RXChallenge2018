@testable import RxChallenge2018
import RxSwift
import RxCocoa
import GenericCellControllers

class DetailViewInterfaceMock: DetailViewInterface {
    var title: String?
    let titlesSubject = BehaviorSubject<DetailDescriptor?>(value: nil)
    var errorTitle: String?
    var errorMessage: String?
    var isAnimating: Bool?

    let disposeBag = DisposeBag()
    
    func configureTitle(_ title: String) {
        self.title = title
    }
    
    func setTitles(with driver: Driver<DetailDescriptor>) {
        driver.drive(titlesSubject).disposed(by: disposeBag)
    }
    
    func showError(with title: String, message: String) {
        errorTitle = title
        errorMessage = message
    }
    
    func startAnimating() {
        isAnimating = true
    }
    
    func stopAnimating() {
        isAnimating = false
    }
}
