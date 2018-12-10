import XCTest
@testable import RxChallenge2018

class DetailCoordinatorTests: XCTestCase {
    
    override func setUp() {}
    
    override func tearDown() {}
    
    func testListCoordinator() {
        //Having
        let postScreenFactory = PostScreenFactoryMock()
        let appScreenFactory = AppScreenFactory(postScreenFactory: postScreenFactory)
        let appProviders = AppProviders(typicodeProvider: TypicodeServiceMock())
        let navigationController = MockNavigationController()
        let listCoordinator = DetailCoordinator(navigationController: navigationController, screenFactory: appScreenFactory, providers: appProviders, post: testPost1)
        //When
        listCoordinator.start()
        //Then
        XCTAssertTrue(navigationController.viewControllers.count == 1)
        XCTAssertEqual(navigationController.viewControllers.last, postScreenFactory.viewControllerDetail)
    }
}
