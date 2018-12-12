import XCTest
@testable import RxChallenge2018

class ListPresenterTests: XCTestCase {
    
    var listViewInterface: ListViewInterfaceMock!
    var presenter: ListPresenter!

    override func setUp() {
        listViewInterface = ListViewInterfaceMock()
        presenter = ListPresenter(outputInterface: listViewInterface)
    }

    override func tearDown() {
        listViewInterface = nil
        presenter = nil
    }
    
    func testConfigureTitles() {
        //When
        presenter.configureTitles()
        //Then
        XCTAssertTrue(listViewInterface.title != nil)
        XCTAssertTrue(listViewInterface.placeholder != nil)
    }
    
    func testSetupPosts() {
        //When
        presenter.setupObservables(postsObservable: .just(([testPost1, testPost2], "search")), selectionObservable: .just(()))
        //Then
        XCTAssertTrue(((try? listViewInterface.cellControllersSubject.value())??.count == 2))
    }
    
    func testSetupPostsNilTitle() {
        //When
        presenter.setupObservables(postsObservable: .just(([testPostNil1, testPost2], "search")), selectionObservable: .just(()))
        //Then
        XCTAssertTrue((try? listViewInterface.cellControllersSubject.value())??.count == 2)
        let controller = (try? listViewInterface.cellControllersSubject.value())??.first as! PostCellController
        XCTAssertTrue(controller.descriptor.title == "")
    }
    
    func testSetupPostsNilId() {
        //When
        presenter.setupObservables(postsObservable: .just(([testPostNil1, testPost2], "search")), selectionObservable: .just(()))
        let controller = (try? listViewInterface.cellControllersSubject.value())??.first as! PostCellController
        controller.didSelectCell()
        //Then
        XCTAssertTrue((try? listViewInterface.cellControllersSubject.value())??.count == 2)
        XCTAssertTrue(listViewInterface.selectedId == 0)
    }
    
    func testShowError() {
        //When
        presenter.showError(with: .notFound)
        //Then
        XCTAssertTrue(listViewInterface.errorTitle != nil)
        XCTAssertTrue(listViewInterface.errorMessage != nil)
    }
}
