import UIKit
import RxSwift
import RxCocoa
import GenericCellControllers
import RxKeyboard

final class ListView: UIViewController, ListViewInterface {
    
    //MARK: Relationships
    var viewOutput: ListInteractorInterface?
    
    //MARK: - Stored properties
    private var cellControllers: [TableCellController] = []
    private let selectionSubject = ReplaySubject<Int>.create(bufferSize: 1)
    private let disposeBag = DisposeBag()
    private var contentViewBottomConstraint: NSLayoutConstraint?
    var animating = false
    var firstAnimation = true
    
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
        
        RxKeyboard.instance.visibleHeight.drive(onNext: { [weak self] height in
            self?.animate(to: height)
        }).disposed(by: disposeBag)
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
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        contentViewBottomConstraint = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        contentViewBottomConstraint?.isActive = true
    }
    
    func animate(to height: CGFloat) {
        animating = true
        contentViewBottomConstraint?.constant = -height
        
        UIView.animate(withDuration: firstAnimation ? 0.0 : 0.3, delay: 0.0, options: .beginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
        }) { complete in
            self.firstAnimation = false
            self.animating = false
        }
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
