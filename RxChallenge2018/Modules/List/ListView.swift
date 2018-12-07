import UIKit

final class ListView: UIViewController, ListViewInterface {
    
    //MARK: Relationships
    var viewOutput: ListInteractorInterface?
    
    //MARK: - Stored properties
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - ListViewInterface
    

}

//MARK: - Private methods
private extension ListView {
    
    func setupView() {
        view.backgroundColor = .white
        layout()
    }
    
    func layout() {
        
    }
}

//MARK: - DisplayData
private extension ListView {
    enum DisplayData {
        
    }
}
