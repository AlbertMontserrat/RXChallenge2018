import XCTest
@testable import RxChallenge2018
import RxSwift
import RxCocoa
import GenericCellControllers

class ListViewTests: XCTestCase {

    var listView: ListView!
    var interactor: ListInteractorInterfaceMock!
    var messagePresentable: MessagesManagerMock!
    
    override func setUp() {
        messagePresentable = MessagesManagerMock()
        interactor = ListInteractorInterfaceMock()
        listView = ListView(messagePresentable: messagePresentable)
        listView.viewOutput = interactor
    }

    override func tearDown() {
        interactor = nil
        listView = nil
        messagePresentable = nil
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
    
    func testConfigureTitle() {
        //Given
        let title = "title"
        //When
        listView.configureTitle(title)
        //Then
        XCTAssertTrue(listView.title == title)
    }
    
    func testSetupControllers() {
        //Given
        let postCellDescriptor1 = PostCellDescriptor(title: "title1")
        let postCellDescriptor2 = PostCellDescriptor(title: "title2")
        let postCellController1 = PostCellController(descriptor: postCellDescriptor1, didSelectCell: {
            self.listView.didSelectCell(with: 1)
        })
        let postCellController2 = PostCellController(descriptor: postCellDescriptor2, didSelectCell: {
            self.listView.didSelectCell(with: 2)
        })
        let driver = Observable<[TableCellController]>.just([postCellController1, postCellController2]).asDriver(onErrorJustReturn: [])
        //When
        listView.setupControllers(with: driver)
        //Then
        XCTAssertTrue(listView.cellControllers.count == 2)
        XCTAssertTrue((listView.cellControllers.first as? PostCellController)?.descriptor.title == postCellDescriptor1.title)
    }
    
    func testSelectCellControllers() {
        //Given
        let postCellDescriptor1 = PostCellDescriptor(title: "title1")
        let postCellDescriptor2 = PostCellDescriptor(title: "title2")
        let id1 = 1
        let id2 = 2
        let postCellController1 = PostCellController(descriptor: postCellDescriptor1, didSelectCell: {
            self.listView.didSelectCell(with: id1)
        })
        let postCellController2 = PostCellController(descriptor: postCellDescriptor2, didSelectCell: {
            self.listView.didSelectCell(with: id2)
        })
        let driver = Observable<[TableCellController]>.just([postCellController1, postCellController2]).asDriver(onErrorJustReturn: [])
        //When
        _ = listView.view
        listView.setupControllers(with: driver)
        postCellController1.didSelectCell()
        //Then
        XCTAssertTrue((try? interactor.selectionIdSubject.value()) == id1)
        //When
        postCellController2.didSelectCell()
        //Then
        XCTAssertTrue((try? interactor.selectionIdSubject.value()) == id2)
        //When
        listView.tableView(UITableView(), didSelectRowAt: IndexPath(row: 0, section: 0))
        //Then
        XCTAssertTrue((try? interactor.selectionIdSubject.value()) == id1)
    }
    
    func testShowError() {
        let title = "title"
        let message = "message"
        //When
        listView.showError(with: title, message: message)
        //Then
        XCTAssertTrue(messagePresentable.errorTitle == title)
        XCTAssertTrue(messagePresentable.errorMessage == message)
    }
    
    func testInitDecoder() {
        //When
        listView = ListView(coder: NSCoder())
        //Then
        XCTAssertTrue(listView == nil)
    }
    
    func testTableviewCellInitDecoder() {
        //When
        let cell = PostTableViewCell(coder: NSCoder())
        //Then
        XCTAssertTrue(cell == nil)
    }
    
    func testStartAnimating() {
        //When
        listView.startAnimating()
        //Then
        XCTAssertTrue(listView.activityIndicator.isAnimating == true)
    }
    
    func testStopAnimating() {
        //When
        listView.startAnimating()
        listView.stopAnimating()
        //Then
        XCTAssertTrue(listView.activityIndicator.isAnimating == false)
    }
}
