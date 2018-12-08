import Foundation
import RxSwift
import RxCocoa

protocol DetailViewInterface: class {
    func configureTitle(_ title: String)
    func setTitles(with descriptorObservable: Driver<DetailDescriptor>)
    func showError(with text: String)
}

protocol DetailPresenterInterface {
    func configureTitles()
    func setupTitles(with detailObservable: Observable<DetailData>)
    func showError(with error: NetworkError)
}

protocol DetailInteractorInterface {
    func initializeTitles()
    func setupStartupObservable(_ startupObservable: Observable<()>)
}
