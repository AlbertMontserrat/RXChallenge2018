import UIKit
import RxSwift
import RxCocoa
import GenericCellControllers

final class ListView: UIViewController, ListViewInterface {
    
    //MARK: Relationships
    var viewOutput: ListInteractorInterface?
    
    //MARK: - Stored properties
    private var cellControllers: [TableCellController] = []
    private let selectionSubject = ReplaySubject<Int>.create(bufferSize: 1)
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Elements
    let searchController = UISearchController(searchResultsController: nil)

    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero)
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 100
        tableview.delegate = self
        tableview.dataSource = self
        DisplayData.cellControllers.forEach { $0.registerCell(on: tableview) }
        return tableview
    }()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewOutput?.initializeTitles()
        viewOutput?.configure(with: searchController.searchBar.rx.value.map { $0 ?? "" })
        viewOutput?.configureSelection(with: selectionSubject)
    }
    
    //MARK: - ListViewInterface
    func configureTitle(_ title: String) {
        self.title = title
    }
    
    func configureSearchBarPlaceholder(_ title: String) {
        searchController.searchBar.placeholder = title
    }

    func setupControllers(with controllersObservable: Driver<[TableCellController]>) {
        controllersObservable.drive(onNext: { [weak self] controllers in
            self?.cellControllers = controllers
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    func didSelectCell(with id: Int) {
        selectionSubject.onNext(id)
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

//MARK: - UITableView Datasource and Delegates
extension ListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellControllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let controller = cellControllers[indexPath.row]
        return controller.cellFromReusableCellHolder(tableView, forIndexPath: indexPath)
    }
}

extension ListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = cellControllers[indexPath.row]
        controller.didSelectCell()
    }
}

//MARK: - DisplayData
private extension ListView {
    enum DisplayData {
        static var cellControllers: [TableCellController.Type] { return [PostCellController.self] }
    }
}
