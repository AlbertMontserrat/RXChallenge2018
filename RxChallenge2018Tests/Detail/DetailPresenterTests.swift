import XCTest
@testable import RxChallenge2018

class DetailPresenterTests: XCTestCase {
    
    var detailViewInterface: DetailViewInterfaceMock!
    var presenter: DetailPresenter!
    
    override func setUp() {
        detailViewInterface = DetailViewInterfaceMock()
        presenter = DetailPresenter(outputInterface: detailViewInterface)
    }
    
    override func tearDown() {
        detailViewInterface = nil
        presenter = nil
    }
    
    func testConfigureTitles() {
        //When
        presenter.configureTitles()
        //Then
        XCTAssertTrue(detailViewInterface.title != nil)
    }
    
    func testSetupTitles() {
        //Having
        let data: DetailData = (testPost1, testUser, validComments)
        let author = String.str_by_user_username.replacingVariables([data.user.name ?? "", data.user.username ?? ""])
        let numberOfComments = String.str_x_comments.replacingVariables(["\(data.comments.count)"])
        //When
        presenter.setupTitles(with: .just(data))
        //Then
        XCTAssertTrue(((try? detailViewInterface.titlesSubject.value())??.titleText == testPost1.title!))
        XCTAssertTrue(((try? detailViewInterface.titlesSubject.value())??.bodyText == testPost1.body!))
        XCTAssertTrue(((try? detailViewInterface.titlesSubject.value())??.authorText == author))
        XCTAssertTrue(((try? detailViewInterface.titlesSubject.value())??.numberOfCommentsText == numberOfComments))
    }
    
    func testSetupTitlesNils() {
        //Having
        let data: DetailData = (testPostNil1, testUserNil, nilComments)
        let author = String.str_by_user_username.replacingVariables(["", ""])
        let numberOfComments = String.str_x_comments.replacingVariables(["\(data.comments.count)"])
        //When
        presenter.setupTitles(with: .just(data))
        //Then
        XCTAssertTrue(((try? detailViewInterface.titlesSubject.value())??.titleText == ""))
        XCTAssertTrue(((try? detailViewInterface.titlesSubject.value())??.bodyText == ""))
        XCTAssertTrue(((try? detailViewInterface.titlesSubject.value())??.authorText == author))
        XCTAssertTrue(((try? detailViewInterface.titlesSubject.value())??.numberOfCommentsText == numberOfComments))
    }
    
    func testShowError() {
        //When
        presenter.showError(with: .notFound)
        //Then
        XCTAssertTrue(detailViewInterface.errorTitle != nil)
        XCTAssertTrue(detailViewInterface.errorMessage != nil)
    }
}
