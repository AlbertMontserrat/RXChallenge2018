import Foundation

typealias ListData = ()

final class ListInteractor: ListInteractorInterface {
    
    //MARK: Relationships
    private let interactorOutput: ListPresenterInterface
    private let gateway: ListGateway
    private let router: ListRoutingInterface
    
    //MARK: - Lifecycle
    init(router: ListRoutingInterface,
        outputInterface: ListPresenterInterface,
        gateway: ListGateway) {
        self.interactorOutput = outputInterface
        self.gateway = gateway
        self.router = router
    }
    
    //MARK: - ListInteractorInterface
    
    
}

//MARK: - Private methods
private extension ListInteractor {
    
}
