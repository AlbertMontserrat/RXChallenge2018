@testable import RxChallenge2018
import UIKit

final class MainCoordinatorMock: MainCoordinator {
    var navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
