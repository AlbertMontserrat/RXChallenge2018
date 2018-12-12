import XCTest
@testable import RxChallenge2018
import RxChallengeDomain
import RxSwift

class ListInteractorTests: XCTestCase {

    var typicodeService: TypicodeServiceMock!
    var appProvider: AppProviders!
    var presenter: ListPresenterInterfaceMock!
    var routing: ListRoutingInterfaceMock!
    var interactor: ListInteractor!
    
    override func setUp() {
        typicodeService = TypicodeServiceMock()
        appProvider = AppProviders(typicodeProvider: typicodeService)
        presenter = ListPresenterInterfaceMock()
        routing = ListRoutingInterfaceMock()
        interactor = ListInteractor(router: routing, outputInterface: presenter, providers: appProvider)
    }

    override func tearDown() {
        typicodeService = nil
        appProvider = nil
        presenter = nil
        routing = nil
        interactor = nil
    }
    
    func testInitializeTitles() {
        //When
        interactor.initializeTitles()
        //Then
        XCTAssertTrue(presenter.configureTitlesTimesCalled == 1)
    }
    
    func testConfigurePostsEmptyString() {
        //When
        typicodeService.returnNils = false
        interactor.configure(with: .just(()), refreshObservable: .just(()), searchObservable: .just(""))
        //Then
        XCTAssertTrue((try? presenter.postsSubject.value())??.posts.count == validPosts.count)
        XCTAssertTrue((try? presenter.postsSubject.value())??.query == "")
    }
    
    func testConfigurePostsNotEmptyString() {
        //When
        typicodeService.returnNils = false
        interactor.configure(with: .just(()), refreshObservable: .just(()), searchObservable: .just(testPost1.title!))
        //Then
        XCTAssertTrue((try? presenter.postsSubject.value())??.posts.count == 1)
        XCTAssertTrue((try? presenter.postsSubject.value())??.query == testPost1.title!)
    }
    
    func testConfigurePostsEmptyStringPostNil() {
        //When
        typicodeService.returnNils = true
        interactor.configure(with: .just(()), refreshObservable: .just(()), searchObservable: .just(""))
        //Then
        XCTAssertTrue((try? presenter.postsSubject.value())??.posts.count == nilPosts.count)
        XCTAssertTrue((try? presenter.postsSubject.value())??.query == "")
    }
    
    func testConfigurePostsNotEmptyStringPostNil() {
        //When
        typicodeService.returnNils = true
        interactor.configure(with: .just(()), refreshObservable: .just(()), searchObservable: .just(testPost1.title!))
        //Then
        XCTAssertTrue((try? presenter.postsSubject.value())??.posts.count == nilPosts.count)
        XCTAssertTrue((try? presenter.postsSubject.value())??.query == testPost1.title!)
    }
    
    func testConfigurePostsError() {
        //When
        typicodeService.returnNils = true
        interactor.configure(with: .just(()), refreshObservable: .just(()), searchObservable: Observable<String>.just("").map { _ in throw NetworkError.undefined })
        //Then
        XCTAssertTrue((try? presenter.postsSubject.value())??.posts.count == nil)
        XCTAssertTrue((try? presenter.postsSubject.value())??.query == nil)
        XCTAssertTrue(presenter.error == .undefined)
    }
    
    func testConfigurePostsCommonError() {
        //When
        typicodeService.returnNils = true
        interactor.configure(with: .just(()), refreshObservable: .just(()), searchObservable: Observable<String>.just("").map { _ in throw NSError(domain: "test", code: 0, userInfo: nil) })
        //Then
        XCTAssertTrue((try? presenter.postsSubject.value())??.posts.count == nil)
        XCTAssertTrue((try? presenter.postsSubject.value())??.query == nil)
        XCTAssertTrue(presenter.error == .undefined)
    }
    
    func testConfigureOnSelection() {
        //When
        typicodeService.returnNils = false
        interactor.configure(with: .just(()), refreshObservable: .just(()), searchObservable: .just(testPost1.title!))
        interactor.configureSelection(with: .just(testPost1.id!))
        //Then
        XCTAssertTrue(routing.gotoDetailsTimesCalled == 1)
    }
    
    func testConfigureOnSelectionIncorrectId() {
        //When
        typicodeService.returnNils = false
        interactor.configure(with: .just(()), refreshObservable: .just(()), searchObservable: .just(""))
        interactor.configureSelection(with: .just(-1000))
        //Then
        XCTAssertTrue(routing.gotoDetailsTimesCalled == 0)
    }
    
    func testConfigureOnSelectionNilsPosts() {
        //When
        typicodeService.returnNils = true
        interactor.configure(with: .just(()), refreshObservable: .just(()), searchObservable: .just(testPost1.title!))
        interactor.configureSelection(with: .just(0))
        //Then
        XCTAssertTrue(routing.gotoDetailsTimesCalled == 0)
    }
}
