import UIKit
import RxSwift
import RxCocoa

final class ListView: UIViewController, ListViewInterface {
    
    //MARK: Relationships
    var viewOutput: ListInteractorInterface?
    
    //MARK: - Stored properties
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Elements
    let searchController = UISearchController(searchResultsController: nil)

    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero)
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 100
        tableview.separatorStyle = .none
        return tableview
    }()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewOutput?.initializeTitles()
        viewOutput?.configure(with: searchController.searchBar.rx.value.map { $0 ?? "" })
    }
    
    //MARK: - ListViewInterface
    func configureTitle(_ title: String) {
        self.title = title
    }
    
    func configureSearchBarPlaceholder(_ title: String) {
        searchController.searchBar.placeholder = title
    }

}

//MARK: - Private methods
private extension ListView {
    
    func setupView() {
        view.backgroundColor = .white
        
        // Setup the Search Controller
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        layout()
    }
    
    func layout() {
        view.addSubviewWithAutolayout(tableView)
        tableView.fillSuperview()
    }
}

//MARK: - DisplayData
private extension ListView {
    enum DisplayData {
        
    }
}
