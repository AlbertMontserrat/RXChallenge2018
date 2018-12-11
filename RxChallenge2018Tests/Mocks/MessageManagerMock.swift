import RxChallengeUtils

class MessagesManagerMock: MessagePresentable {
    
    var errorTitle: String?
    var errorMessage: String?
    var hideAllTimesCalled = 0
    
    public init() {}
    
    public func showErrorMessage(with title: String, message: String) {
        errorTitle = title
        errorMessage = message
    }
    
    public func hideAll() {
        hideAllTimesCalled += 1
    }
}
