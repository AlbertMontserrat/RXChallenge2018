import XCTest
@testable import RxChallenge2018
import RxChallengeDomain
import RxSwift

class DetailInteractorTests: XCTestCase {
    
    var typicodeService: TypicodeServiceMock!
    var appProvider: AppProviders!
    var presenter: DetailPresenterInterfaceMock!
    var interactor: DetailInteractor!
    
    override func setUp() {
        typicodeService = TypicodeServiceMock()
        appProvider = AppProviders(typicodeProvider: typicodeService)
        presenter = DetailPresenterInterfaceMock()
    }
    
    override func tearDown() {
        typicodeService = nil
        appProvider = nil
        presenter = nil
    }
    
    func testInitializeTitles() {
        //Having
        interactor = DetailInteractor(outputInterface: presenter, providers: appProvider, post: testPost1)
        //When
        interactor.initializeTitles()
        //Then
        XCTAssertTrue(presenter.configureTitlesTimesCalled == 1)
    }
    
    func testSetupStartupObservable() {
        //Having
        interactor = DetailInteractor(outputInterface: presenter, providers: appProvider, post: testPost1)
        //When
        typicodeService.returnNils = false
        interactor.setupStartupObservable(.just(()))
        //Then
        XCTAssertTrue((try? presenter.setupTitlesSubject.value())??.post.id == testPost1.id)
        XCTAssertTrue((try? presenter.setupTitlesSubject.value())??.post.title == testPost1.title)
        XCTAssertTrue((try? presenter.setupTitlesSubject.value())??.post.body == testPost1.body)
        XCTAssertTrue((try? presenter.setupTitlesSubject.value())??.user.id == testUser.id)
        XCTAssertTrue((try? presenter.setupTitlesSubject.value())??.user.name == testUser.name)
        XCTAssertTrue((try? presenter.setupTitlesSubject.value())??.user.username == testUser.username)
        XCTAssertTrue((try? presenter.setupTitlesSubject.value())??.comments.count == validComments.count)
        XCTAssertTrue((try? presenter.setupTitlesSubject.value())??.comments.first!.id == validComments.first!.id)
        XCTAssertTrue((try? presenter.setupTitlesSubject.value())??.comments.first!.name == validComments.first!.name)
    }
    
    func testSetupStartupObservableNils() {
        //Having
        interactor = DetailInteractor(outputInterface: presenter, providers: appProvider, post: testPostNil1)
        //When
        typicodeService.returnNils = true
        interactor.setupStartupObservable(.just(()))
        //Then
        XCTAssertTrue((try? presenter.setupTitlesSubject.value())??.post.id == nil)
        XCTAssertTrue((try? presenter.setupTitlesSubject.value())??.post.title == nil)
        XCTAssertTrue((try? presenter.setupTitlesSubject.value())??.post.body == nil)
        XCTAssertTrue((try? presenter.setupTitlesSubject.value())??.user.id == nil)
        XCTAssertTrue((try? presenter.setupTitlesSubject.value())??.user.name == nil)
        XCTAssertTrue((try? presenter.setupTitlesSubject.value())??.user.username == nil)
        XCTAssertTrue((try? presenter.setupTitlesSubject.value())??.comments.count == nilComments.count)
        XCTAssertTrue((try? presenter.setupTitlesSubject.value())??.comments.first!.id == nil)
        XCTAssertTrue((try? presenter.setupTitlesSubject.value())??.comments.first!.name == nil)
    }
    
    func testSetupStartupObservableError() {
        //Having
        interactor = DetailInteractor(outputInterface: presenter, providers: appProvider, post: testPostNil1)
        //When
        typicodeService.returnNils = true
        interactor.setupStartupObservable(Observable<()>.just(()).map { _ in throw NetworkError.undefined })
        //Then
        XCTAssertTrue((try? presenter.setupTitlesSubject.value())??.post == nil)
        XCTAssertTrue((try? presenter.setupTitlesSubject.value())??.user == nil)
        XCTAssertTrue((try? presenter.setupTitlesSubject.value())??.comments == nil)
        XCTAssertTrue(presenter.error == .undefined)
    }
    
    func testSetupStartupObservableCommonError() {
        //Having
        interactor = DetailInteractor(outputInterface: presenter, providers: appProvider, post: testPostNil1)
        //When
        typicodeService.returnNils = true
        interactor.setupStartupObservable(Observable<()>.just(()).map { _ in throw NSError(domain: "test", code: 0, userInfo: nil) })
        //Then
        XCTAssertTrue((try? presenter.setupTitlesSubject.value())??.post == nil)
        XCTAssertTrue((try? presenter.setupTitlesSubject.value())??.user == nil)
        XCTAssertTrue((try? presenter.setupTitlesSubject.value())??.comments == nil)
        XCTAssertTrue(presenter.error == .undefined)
    }
}
