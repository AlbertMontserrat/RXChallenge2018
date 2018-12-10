@testable import RxChallenge2018
import RxChallengeDomain

class ListRoutingInterfaceMock: ListRoutingInterface {
    var gotoDetailsTimesCalled = 0
    var postPushed: Post?
    
    func gotoDetail(with post: Post) {
        gotoDetailsTimesCalled += 1
        postPushed = post
    }
}
