@testable import RxChallenge2018
import UIKit

final class MainCoordinatorMock: CoordinatorType {
    var navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
