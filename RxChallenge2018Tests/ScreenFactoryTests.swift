import XCTest
@testable import RxChallenge2018
import RxChallengeNetwork

class ScreenFactoryTests: XCTestCase {

    var postScreenFactory: PostScreenFactory!
    var appScreenFactory: AppScreenFactory!
    var appProviders: AppProviders!
    
    override func setUp() {
        postScreenFactory = PostScreenFactory()
        appScreenFactory = AppScreenFactory(postScreenFactory: postScreenFactory)
        appProviders = AppProviders(typicodeProvider: TypicodeServiceMock())
    }

    override func tearDown() {
        postScreenFactory = nil
        appScreenFactory = nil
        appProviders = nil
    }
    
    func testPostScreenFactory() {
        //When
        let listScreen = appScreenFactory.postScreenFactory.getPostListScreen(router: ListRoutingInterfaceMock(), providers: appProviders)
        let detailScreen = appScreenFactory.postScreenFactory.getPostDetailScreen(with: testPost1, providers: appProviders)
        //Then
        XCTAssertTrue(listScreen is ListView)
        XCTAssertTrue(detailScreen is DetailView)
    }
}
