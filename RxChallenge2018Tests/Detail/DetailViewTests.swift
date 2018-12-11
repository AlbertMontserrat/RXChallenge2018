import XCTest
@testable import RxChallenge2018
import RxSwift
import RxCocoa

class DetailViewTests: XCTestCase {
    
    var detailView: DetailView!
    var interactor: DetailInteractorInterfaceMock!
    var messagePresentable: MessagesManagerMock!
    
    override func setUp() {
        messagePresentable = MessagesManagerMock()
        interactor = DetailInteractorInterfaceMock()
        detailView = DetailView(messagePresentable: messagePresentable)
        detailView.viewOutput = interactor
    }
    
    override func tearDown() {
        interactor = nil
        detailView = nil
        messagePresentable = nil
    }
    
    func testViewDidLoad() {
        //When
        _ = detailView.view //viewDidLoad is called automatically when request view
        detailView.viewWillAppear(false)
        //Then
        XCTAssertTrue(interactor.initializeTitlesTimesCalled == 1)
        XCTAssertTrue((try? interactor.startupSubject.value())! != nil)
    }
    
    func testConfigureTitle() {
        //Given
        let title = "title"
        //When
        detailView.configureTitle(title)
        //Then
        XCTAssertTrue(detailView.title == title)
    }
    
    func testSetTitles() {
        //Given
        let title = "title"
        let body = "body"
        let author = "author"
        let comments = "coments"
        let driver = Observable<DetailDescriptor>.just((title, body, author, comments)).asDriver(onErrorJustReturn: ("", "", "", ""))
        //When
        detailView.setTitles(with: driver)
        //Then
        XCTAssertTrue(detailView.titleLabel.text == title)
        XCTAssertTrue(detailView.bodyLabel.text == body)
        XCTAssertTrue(detailView.authorLabel.text == author)
        XCTAssertTrue(detailView.numberOfCommentsLabel.text == comments)
    }
    
    func testShowError() {
        let title = "title"
        let message = "message"
        //When
        detailView.showError(with: title, message: message)
        //Then
        XCTAssertTrue(messagePresentable.errorTitle == title)
        XCTAssertTrue(messagePresentable.errorMessage == message)
    }
    
    func testInitDecoder() {
        //When
        detailView = DetailView(coder: NSCoder())
        //Then
        XCTAssertTrue(detailView == nil)
    }
    
    func testStartAnimating() {
        //When
        detailView.startAnimating()
        //Then
        XCTAssertTrue(detailView.activityIndicator.isAnimating == true)
    }
    
    func testStopAnimating() {
        //When
        detailView.startAnimating()
        detailView.stopAnimating()
        //Then
        XCTAssertTrue(detailView.activityIndicator.isAnimating == false)
    }
}
