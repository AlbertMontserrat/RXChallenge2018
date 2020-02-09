import UIKit

protocol CoordinatorType {
    var navigationController: UINavigationController { get }
    func setRootViewController(in window: UIWindow)
}

extension CoordinatorType {
    func setRootViewController(in window: UIWindow) {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
