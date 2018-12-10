import XCTest
@testable import RxChallenge2018

class ListCoordinatorTests: XCTestCase {

    override func setUp() {}

    override func tearDown() {}
    
    func testListCoordinator() {
        //Having
        let postScreenFactory = PostScreenFactoryMock()
        let appScreenFactory = AppScreenFactory(postScreenFactory: postScreenFactory)
        let appProviders = AppProviders(typicodeProvider: TypicodeServiceMock())
        let navigationController = MockNavigationController()
        let listCoordinator = ListCoordinator(navigationController: navigationController, screenFactory: appScreenFactory, providers: appProviders)
        //When
        listCoordinator.start()
        //Then
        XCTAssertTrue(navigationController.viewControllers.count == 1)
        XCTAssertEqual(navigationController.viewControllers.last, postScreenFactory.viewControllerList)
    }
    
    func testListCoordinatorRoutingToDetail() {
        //Having
        let postScreenFactory = PostScreenFactoryMock()
        let appScreenFactory = AppScreenFactory(postScreenFactory: postScreenFactory)
        let appProviders = AppProviders(typicodeProvider: TypicodeServiceMock())
        let navigationController = MockNavigationController()
        let listCoordinator = ListCoordinator(navigationController: navigationController, screenFactory: appScreenFactory, providers: appProviders)
        //When
        listCoordinator.start(animated: false)
        listCoordinator.gotoDetail(with: testPost1)
        //Then
        XCTAssertTrue(navigationController.viewControllers.count == 2)
        XCTAssertEqual(navigationController.viewControllers.last, postScreenFactory.viewControllerDetail)
    }
}
