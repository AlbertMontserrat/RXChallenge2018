import Foundation
import RxSwift
import RxCocoa

final class ListPresenter: ListPresenterInterface {
    
    //MARK: Relationships
    private weak var presenterOutput: ListViewInterface?
    
    //MARK: - Lifecycle
    init(outputInterface: ListViewInterface) {
        self.presenterOutput = outputInterface
    }
    
    //MARK: - ListPresenterInterface
    func configureTitles() {
        presenterOutput?.configureTitle("Posts")
        presenterOutput?.configureSearchBarPlaceholder("Search post")
    }
    
    func setupPosts(with postsObservable: Observable<PostsWithQuery>) {
        presenterOutput?.setupControllers(with: postsObservable.map { [unowned self] posts, searchQuery in
            return posts.map { PostCellController(descriptor: PostCellDescriptor(title: $0.title ?? ""), didSelectCell: self.didSelectCell(with: $0.id ?? 0)) }
        }.asDriver(onErrorJustReturn: []))
    }
}

//MARK: - Private methods
private extension ListPresenter {
    func didSelectCell(with id: Int) -> VoidClosure {
        return { [weak self] in
            self?.presenterOutput?.didSelectCell(with: id)
        }
    }
}

//MARK: - Constants
private extension ListPresenter {
    enum Constants {
    }
}
