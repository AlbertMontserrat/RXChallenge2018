import XCTest
@testable import RxChallenge2018

class ListCoordinatorTests: XCTestCase {
    
    var postScreenFactory: PostScreenFactoryMock!
    var appScreenFactory: AppScreenFactory!
    var appProviders: AppProviders!
    var navigationController: UINavigationController!
    var listCoordinator: ListCoordinator!

    override func setUp() {
        postScreenFactory = PostScreenFactoryMock()
        appScreenFactory = AppScreenFactory(postScreenFactory: postScreenFactory)
        appProviders = AppProviders(typicodeProvider: TypicodeServiceMock())
        navigationController = MockNavigationController()
        listCoordinator = ListCoordinator(navigationController: navigationController, screenFactory: appScreenFactory, providers: appProviders)
    }

    override func tearDown() {
        postScreenFactory = nil
        appScreenFactory = nil
        appProviders = nil
        navigationController = nil
        listCoordinator = nil
    }
    
    func testListCoordinator() {
        //When
        listCoordinator.start()
        //Then
        XCTAssertTrue(navigationController.viewControllers.count == 1)
        XCTAssertEqual(navigationController.viewControllers.last, postScreenFactory.viewControllerList)
    }
    
    func testListCoordinatorRoutingToDetail() {
        //When
        listCoordinator.start(animated: false)
        listCoordinator.gotoDetail(with: testPost1)
        //Then
        XCTAssertTrue(navigationController.viewControllers.count == 2)
        XCTAssertEqual(navigationController.viewControllers.last, postScreenFactory.viewControllerDetail)
    }
}
