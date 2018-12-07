import Foundation

typealias ListDescriptor = ()

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
    
}

//MARK: - Private methods
private extension ListPresenter {
    
}

//MARK: - Constants
private extension ListPresenter {
    enum Constants {
        
    }
}
