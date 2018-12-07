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
        
        gateway.getPosts().subscribe(onSuccess: { posts in
            print("\(posts.count) posts loaded")
        }) { error in
            print(error)
        }.disposed(by: disposeBag)
    }
    
    //MARK: - ListInteractorInterface
    
    
}

//MARK: - Private methods
private extension ListInteractor {
    
}
