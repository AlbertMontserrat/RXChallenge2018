import UIKit
import RxChallengeUtils
import RxSwift
import RxCocoa
import GenericCellControllers
import RxKeyboard

final class ListView: UIViewController, ListViewInterface {
    
    //MARK: Relationships
    var viewOutput: ListInteractorInterface?
    
    //MARK: - Stored properties
    private(set) var cellControllers: [TableCellController] = []
    private let selectionSubject = ReplaySubject<Int>.create(bufferSize: 1)
    private let startupSubject = ReplaySubject<()>.create(bufferSize: 1)
    private let disposeBag = DisposeBag()
    private var contentViewBottomConstraint: NSLayoutConstraint?
    private var animating = false
    private var firstAnimation = true
    private let messagePresenter: MessagePresentable
    
    //MARK: - UI Elements
    private let searchController = UISearchController(searchResultsController: nil)
    private(set) lazy var activityIndicator = UIActivityIndicatorView(style: .gray)
    private lazy var refreshControl = UIRefreshControl(frame: .zero)
    
    private lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero)
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 100
        tableview.delegate = self
        tableview.dataSource = self
        DisplayData.cellControllers.forEach { $0.registerCell(on: tableview) }
        tableview.addSubview(refreshControl)
        return tableview
    }()
    
    //MARK: - View Lifecycle
    init(messagePresentable: MessagePresentable = MessagesManager()) {
        self.messagePresenter = messagePresentable
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewOutput?.initializeTitles()
        viewOutput?.configureObservables(startupObservable: startupSubject, refreshObservable: refreshControl.rx.controlEvent(.valueChanged).asObservable(), searchObservable: searchController.searchBar.rx.value.orEmpty.distinctUntilChanged().asObservable(), selectionIdObservable: selectionSubject)
        
        RxKeyboard.instance.visibleHeight.drive(onNext: { [weak self] height in
            self?.animate(to: height)
        }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startupSubject.onNext(())
    }
    
    //MARK: - ListViewInterface
    func configureTitle(_ title: String) {
        self.title = title
    }
    
    func configureSearchBarPlaceholder(_ title: String) {
        searchController.searchBar.placeholder = title
    }

    func setupObservables(controllers: Driver<[TableCellController]>, selection: Driver<()>) {
        //NOTE: I don't use tableview.rx.items data binding and tableview.rx.itemSelected because I use the Generic cell controllers
        //which gives the option to create fully heterogenic lists with a common controller type.
        //Moreover, with this architecture, we cannot be 100% sure that the indexPath will be the same from interactor to presenter -> view.
        //So we cannot use itemSelected and send back to interactor directly. We could send the model, but then, the view wouldn't be 100% model agnostic.
        controllers.drive(onNext: { [weak self] controllers in
            self?.refreshControl.endRefreshing()
            self?.cellControllers = controllers
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        selection.drive().disposed(by: disposeBag)
    }
    
    func showError(with title: String, message: String) {
        refreshControl.endRefreshing()
        messagePresenter.showErrorMessage(with: title, message: message)
    }
    
    func didSelectCell(with id: Int) {
        selectionSubject.onNext(id)
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
}

//MARK: - Private methods
private extension ListView {
    
    func setupView() {
        view.backgroundColor = .customBackground
        
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
        view.addSubviewWithAutolayout(activityIndicator)
        activityIndicator.anchorCenterToSuperview()
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
