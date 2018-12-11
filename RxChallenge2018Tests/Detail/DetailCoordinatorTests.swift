import XCTest
@testable import RxChallenge2018

class DetailCoordinatorTests: XCTestCase {
    
    var postScreenFactory: PostScreenFactoryMock!
    var appScreenFactory: AppScreenFactory!
    var appProviders: AppProviders!
    var navigationController: UINavigationController!
    var listCoordinator: DetailCoordinator!
    
    override func setUp() {
        postScreenFactory = PostScreenFactoryMock()
        appScreenFactory = AppScreenFactory(postScreenFactory: postScreenFactory)
        appProviders = AppProviders(typicodeProvider: TypicodeServiceMock())
        navigationController = MockNavigationController()
        listCoordinator = DetailCoordinator(navigationController: navigationController, screenFactory: appScreenFactory, providers: appProviders, post: testPost1)
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
        XCTAssertEqual(navigationController.viewControllers.last, postScreenFactory.viewControllerDetail)
    }
}
