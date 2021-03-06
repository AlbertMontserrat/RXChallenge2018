import UIKit
import RxChallengeUtils
import RxSwift
import RxCocoa

final class DetailView: UIViewController, DetailViewInterface {
    
    //MARK: Relationships
    var viewOutput: DetailInteractorInterface?
    
    //MARK: - Stored properties
    private let startupSubject = ReplaySubject<()>.create(bufferSize: 1)
    private let disposeBag = DisposeBag()
    private let messagePresenter: MessagePresentable
    
    //MARK: - UI Elements
    private(set) lazy var activityIndicator = UIActivityIndicatorView(style: .gray)
    
    private lazy var stackView: ScrolledStackView = {
        let stackView = ScrolledStackView(direction: .vertical, insets: DisplayData.stackViewInsets)
        stackView.stackView.spacing = 16
        return stackView
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .customDarkBlue
        lbl.font = .boldSystemFont(ofSize: 22)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private(set) lazy var bodyLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .customDarkBlue
        lbl.font = .systemFont(ofSize: 18)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private(set) lazy var authorLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .customBlueGray
        lbl.font = .systemFont(ofSize: 15)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private(set) lazy var numberOfCommentsLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .customBlueGray
        lbl.font = .systemFont(ofSize: 15)
        lbl.numberOfLines = 0
        return lbl
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
        viewOutput?.setupStartupObservable(startupSubject)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startupSubject.onNext(())
    }
    
    //MARK: - DetailViewInterface
    func configureTitle(_ title: String) {
        self.title = title
    }
    
    func setTitles(with driver: Driver<DetailDescriptor>) {
        driver.map { $0.titleText }.drive(titleLabel.rx.text).disposed(by: disposeBag)
        driver.map { $0.bodyText }.drive(bodyLabel.rx.text).disposed(by: disposeBag)
        driver.map { $0.authorText }.drive(authorLabel.rx.text).disposed(by: disposeBag)
        driver.map { $0.numberOfCommentsText }.drive(numberOfCommentsLabel.rx.text).disposed(by: disposeBag)
    }
    
    func showError(with title: String, message: String) {
        messagePresenter.showErrorMessage(with: title, message: message)
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
}

//MARK: - Private methods
private extension DetailView {
    
    func setupView() {
        view.backgroundColor = .customBackground
        layout()
    }
    
    func layout() {
        view.addSubviewWithAutolayout(stackView)
        stackView.fillSuperview()
        [titleLabel, bodyLabel, authorLabel, numberOfCommentsLabel].forEach { stackView.stackView.addArrangedSubview($0) }
        view.addSubviewWithAutolayout(activityIndicator)
        activityIndicator.anchorCenterToSuperview()
    }
}

//MARK: - DisplayData
private extension DetailView {
    enum DisplayData {
        static var stackViewInsets: UIEdgeInsets { return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16) }
    }
}
