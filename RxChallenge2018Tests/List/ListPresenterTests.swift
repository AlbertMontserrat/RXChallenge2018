import XCTest
@testable import RxChallenge2018

class ListPresenterTests: XCTestCase {

    override func setUp() {}

    override func tearDown() {}
    
    func testConfigureTitles() {
        //Having
        let listViewInterface = ListViewInterfaceMock()
        let presenter = ListPresenter(outputInterface: listViewInterface)
        //When
        presenter.configureTitles()
        presenter.setupPosts(with: .just(([testPost1, testPost2], "search")))
        presenter.showError(with: .notFound)
        //Then
        XCTAssertTrue(listViewInterface.title != nil)
        XCTAssertTrue(listViewInterface.placeholder != nil)
        XCTAssertTrue(((try? listViewInterface.cellControllers.value())??.count == 2))
        XCTAssertTrue(listViewInterface.errorTitle != nil)
        XCTAssertTrue(listViewInterface.errorMessage != nil)
    }
}
