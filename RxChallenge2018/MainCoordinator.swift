import UIKit

protocol MainCoordinator {
    var navigationController: UINavigationController { get }
    func setRootViewController(in window: UIWindow)
}

extension MainCoordinator {
    func setRootViewController(in window: UIWindow) {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
