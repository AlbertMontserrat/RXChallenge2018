import XCTest
@testable import RxChallenge2018

class MainCoordinatorTests: XCTestCase {

    override func setUp() {}

    override func tearDown() {}

    func testMainCoordinator() {
        //Having
        let window = UIWindow(frame: .zero)
        let navigationController = UINavigationController()
        let mainCoordinator = MainCoordinatorMock(navigationController: navigationController)
        //When
        mainCoordinator.setRootViewController(in: window)
        //Then
        XCTAssertEqual(window.rootViewController, navigationController)
    }
}
