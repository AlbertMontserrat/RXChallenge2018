import Foundation
import RxSwift

protocol ListRoutingInterface {
    func gotoDetail(with post: Post)
}

protocol ListViewInterface: class {
    func configureTitle(_ title: String)
    func configureSearchBarPlaceholder(_ title: String)
}

protocol ListPresenterInterface {
    func configureTitles()
}

protocol ListInteractorInterface {
    func initializeTitles()
    func configure(with searchObservable: Observable<String>)
}
