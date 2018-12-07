import Foundation
import RxSwift

typealias ListData = ()

final class ListInteractor: ListInteractorInterface {
    
    //MARK: Relationships
    private let interactorOutput: ListPresenterInterface
    private let gateway: ListGateway
    private let router: ListRoutingInterface
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Lifecycle
    init(router: ListRoutingInterface,
        outputInterface: ListPresenterInterface,
        gateway: ListGateway) {
        self.interactorOutput = outputInterface
        self.gateway = gateway
        self.router = router
        
//        gateway.getPosts().subscribe(onSuccess: { posts in
//            print("\(posts.count) posts loaded")
//        }) { error in
//            print(error)
//        }.disposed(by: disposeBag)
    }
    
    //MARK: - ListInteractorInterface
    func initializeTitles() {
        interactorOutput.configureTitles()
    }
    
    func configure(with searchObservable: Observable<String>) {
        Observable
            .zip(gateway.getPosts().asObservable(), searchObservable) { posts, searchString -> [Post] in
                return posts.filter { $0.title.lowercased().contains(searchString.lowercased()) || $0.body.lowercased().contains(searchString.lowercased()) }
            }
            .subscribe(onNext: { posts in
                print("\(posts.count) posts loaded")
            })
            .disposed(by: disposeBag)
    }
    
}

//MARK: - Private methods
private extension ListInteractor {
    
}
