import Foundation
import SwiftMessages

public protocol MessagePresentable {
    func showErrorMessage(with title: String, message: String)
    func hideAll()
}

public struct MessagesManager: MessagePresentable {
    
    public init() {}
    
    public func showErrorMessage(with title: String, message: String) {
        var config = SwiftMessages.Config()
        config.presentationStyle = .bottom
        config.presentationContext = .automatic
        config.duration = .automatic
        config.dimMode = .none
        config.interactiveHide = true
        config.preferredStatusBarStyle = .default
        
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(backgroundColor: .customRed, foregroundColor: .customWhite)
        view.configureContent(title: title, body: message, iconImage: #imageLiteral(resourceName: "error_icon"), iconText: nil, buttonImage: nil, buttonTitle: nil, buttonTapHandler: nil)
        view.button?.isHidden = true
        view.titleLabel?.font = .boldSystemFont(ofSize: 15)
        view.bodyLabel?.font = .systemFont(ofSize: 15)
        
        let layer = view.backgroundView.layer
        layer.shadowColor = UIColor.customBlack.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        
        SwiftMessages.show(config: config, view: view)
    }
    
    public func hideAll() {
        SwiftMessages.hideAll()
    }
}
