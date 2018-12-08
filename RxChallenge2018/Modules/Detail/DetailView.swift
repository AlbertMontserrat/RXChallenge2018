import UIKit
import RxSwift
import RxCocoa

final class DetailView: UIViewController, DetailViewInterface {
    
    //MARK: Relationships
    var viewOutput: DetailInteractorInterface?
    
    //MARK: - Stored properties
    private let startupSubject = ReplaySubject<()>.create(bufferSize: 1)
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Elements
    private lazy var stackView: ScrolledStackView = {
        let stackView = ScrolledStackView(direction: .vertical, insets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        stackView.stackView.spacing = 16
        return stackView
    }()
    
    private lazy var bodyLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = .boldSystemFont(ofSize: 16)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private lazy var authorLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = .systemFont(ofSize: 12)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private lazy var numberOfCommentsLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .gray
        lbl.font = .systemFont(ofSize: 12)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    //MARK: - View Lifecycle
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
    
    func setTitles(with descriptorObservable: Driver<DetailDescriptor>) {
        descriptorObservable.drive(onNext: { [unowned self] descriptor in
            self.bodyLabel.text = descriptor.bodyText
            self.authorLabel.text = descriptor.authorText
            self.numberOfCommentsLabel.text = descriptor.numberOfCommentsText
        }).disposed(by: disposeBag)
    }
}

//MARK: - Private methods
private extension DetailView {
    
    func setupView() {
        view.backgroundColor = .white
        layout()
    }
    
    func layout() {
        view.addSubviewWithAutolayout(stackView)
        stackView.fillSuperview()
        [bodyLabel, authorLabel, numberOfCommentsLabel].forEach { stackView.stackView.addArrangedSubview($0) }
    }
}

//MARK: - DisplayData
private extension DetailView {
    enum DisplayData {
        
    }
}
