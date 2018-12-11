import XCTest
@testable import RxChallenge2018

class ListViewTests: XCTestCase {

    var listView: ListView!
    var interactor: ListInteractorInterfaceMock!
    
    override func setUp() {
        interactor = ListInteractorInterfaceMock()
        listView = ListView()
        listView.viewOutput = interactor
    }

    override func tearDown() {
        interactor = nil
        listView = nil
    }
    
    func testViewDidLoad() {
        //When
        _ = listView.view //viewDidLoad is called automatically when request view
        //Then
        XCTAssertTrue(interactor.initializeTitlesTimesCalled == 1)
        XCTAssertTrue((try? interactor.searchSubject.value()) == "")
        XCTAssertTrue(interactor.configureSelectionTimesCalled == 1)
        XCTAssertTrue((try? interactor.selectionIdSubject.value()) ?? nil == nil)
    }
}
