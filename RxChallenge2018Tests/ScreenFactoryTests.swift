import XCTest
@testable import RxChallenge2018
import RxChallengeNetwork

class ScreenFactoryTests: XCTestCase {

    override func setUp() {}

    override func tearDown() {}
    
    func testPostScreenFactory() {
        //Given
        let postScreenFactory = PostScreenFactory()
        let appScreenFactory = AppScreenFactory(postScreenFactory: postScreenFactory)
        let appProviders = AppProviders(typicodeProvider: TypicodeServiceMock())
        //When
        let listScreen = appScreenFactory.postScreenFactory.getPostListScreen(router: ListRoutingInterfaceMock(), providers: appProviders)
        let detailScreen = appScreenFactory.postScreenFactory.getPostDetailScreen(with: testPost1, providers: appProviders)
        //Then
        XCTAssertTrue(listScreen is ListView)
        XCTAssertTrue(detailScreen is DetailView)
    }
}
