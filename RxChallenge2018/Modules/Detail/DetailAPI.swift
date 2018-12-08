import Foundation
import RxSwift
import RxCocoa

protocol DetailRoutingInterface {
    
}

protocol DetailViewInterface: class {
    func configureTitle(_ title: String)
    func setTitles(with descriptorObservable: Driver<DetailDescriptor>)
}

protocol DetailPresenterInterface {
    func configureTitles()
    func setupTitles(with detailObservable: Observable<DetailData>)
}

protocol DetailInteractorInterface {
    func initializeTitles()
    func setupStartupObservable(_ startupObservable: Observable<()>)
}
