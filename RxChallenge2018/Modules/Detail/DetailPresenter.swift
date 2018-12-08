import Foundation
import RxSwift
import RxCocoa

typealias DetailDescriptor = (bodyText: String, authorText: String, numberOfCommentsText: String)

final class DetailPresenter: DetailPresenterInterface {
    
    //MARK: Relationships
    private weak var presenterOutput: DetailViewInterface?
    
    //MARK: - Lifecycle
    init(outputInterface: DetailViewInterface) {
        self.presenterOutput = outputInterface
    }
    
    //MARK: - DetailPresenterInterface
    func configureTitles() {
        presenterOutput?.configureTitle("Post detail")
    }
    
    func setupTitles(with detailObservable: Observable<DetailData>) {
        presenterOutput?.setTitles(with: detailObservable.map { data in
            let body = data.post.body ?? ""
            let author = "By \(data.user.name ?? "") (@\(data.user.username ?? ""))"
            let numberOfComments = "\(data.comments.count) comments"
            return (body, author, numberOfComments)
        }.asDriver(onErrorJustReturn: ("", "", "")))
    }
}

//MARK: - Private methods
private extension DetailPresenter {
    
}

//MARK: - Constants
private extension DetailPresenter {
    enum Constants {
        
    }
}
