@testable import RxChallenge2018
import RxSwift
import RxCocoa
import GenericCellControllers

class ListViewInterfaceMock: ListViewInterface {
    var title: String?
    var placeholder: String?
    let cellControllers = BehaviorSubject<[TableCellController]?>(value: nil)
    var selectedId: Int?
    var errorTitle: String?
    var errorMessage: String?
    var isAnimating: Bool?
    
    private let disposeBag = DisposeBag()
    
    func configureTitle(_ title: String) {
        self.title = title
    }
    
    func configureSearchBarPlaceholder(_ title: String) {
        self.placeholder = title
    }
    
    func setupControllers(with driver: SharedSequence<DriverSharingStrategy, Array<CellController<UITableView>>>) {
        driver.drive(cellControllers).disposed(by: disposeBag)
    }
    
    func didSelectCell(with id: Int) {
        selectedId = id
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
