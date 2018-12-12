@testable import RxChallenge2018
import RxSwift
import RxCocoa
import GenericCellControllers

class ListViewInterfaceMock: ListViewInterface {
    var title: String?
    var placeholder: String?
    let cellControllersSubject = BehaviorSubject<[TableCellController]?>(value: nil)
    let selectionSubject = BehaviorSubject<()?>(value: nil)
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
    
    func setupObservables(controllers: Driver<[TableCellController]>, selection: Driver<()>) {
        controllers.drive(cellControllersSubject).disposed(by: disposeBag)
        selection.drive(selectionSubject).disposed(by: disposeBag)
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
