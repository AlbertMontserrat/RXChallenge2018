import RxChallengeDomain
import RxSwift
import RxCocoa

protocol DetailViewInterface: class {
    func configureTitle(_ title: String)
    func setTitles(with driver: Driver<DetailDescriptor>)
    func showError(with title: String, message: String)
    func startAnimating()
    func stopAnimating()
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
