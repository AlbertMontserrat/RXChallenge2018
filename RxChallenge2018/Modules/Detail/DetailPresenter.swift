import RxChallengeDomain
import RxChallengeUtils
import RxSwift
import RxCocoa

typealias DetailDescriptor = (titleText: String, bodyText: String, authorText: String, numberOfCommentsText: String)

final class DetailPresenter: DetailPresenterInterface {
    
    //MARK: Relationships
    private weak var presenterOutput: DetailViewInterface?
    
    //MARK: - Lifecycle
    init(outputInterface: DetailViewInterface) {
        self.presenterOutput = outputInterface
    }
    
    //MARK: - DetailPresenterInterface
    func configureTitles() {
        presenterOutput?.configureTitle(Constants.postDetailsTitle)
    }
    
    func setupTitles(with detailObservable: Observable<DetailData>) {
        let driver: Driver<DetailDescriptor> = detailObservable
            .do(onNext: { [unowned self] _ in
                self.presenterOutput?.stopAnimating()
                }, onSubscribe: {
                    self.presenterOutput?.startAnimating()
            })
            .map { data in
                let title = data.post.title ?? ""
                let body = data.post.body ?? ""
                let author = Constants.byAuthorTitle.replacingVariables([data.user.name ?? "", data.user.username ?? ""])
                let numberOfComments = Constants.numberCommentsTitle.replacingVariables(["\(data.comments.count)"])
                return (title, body, author, numberOfComments)
            }
            .asDriver(onErrorJustReturn: ("", "", "", ""))
        presenterOutput?.setTitles(with: driver)
    }
    
    func showError(with error: NetworkError) {
        var text: String? = nil
        switch error {
        //Option to show different errors for each network error
        default:
            text = Constants.errorLoadingErrorMessage
        }
        guard let errorMessage = text else { return }
        presenterOutput?.showError(with: Constants.errorLoadingErrorTitle, message: errorMessage)
    }
}

//MARK: - Constants
private extension DetailPresenter {
    enum Constants {
        static var errorLoadingErrorTitle: String { return .str_error }
        static var errorLoadingErrorMessage: String { return .str_error_loading_data }
        static var postDetailsTitle: String { return .str_post_details }
        static var byAuthorTitle: String { return .str_by_user_username }
        static var numberCommentsTitle: String { return .str_x_comments }
    }
}
