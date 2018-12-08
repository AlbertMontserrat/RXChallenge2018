import Foundation
import SwiftMessages

struct MessagesManager {
    
    static func showErrorMessage(_ text: String) {
        var config = SwiftMessages.Config()
        config.presentationStyle = .bottom
        config.presentationContext = .automatic
        config.duration = .automatic
        config.dimMode = .none
        config.interactiveHide = true
        config.preferredStatusBarStyle = .default
        
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(backgroundColor: .customRed, foregroundColor: .customWhite)
        view.configureContent(title: .str_error, body: text, iconImage: #imageLiteral(resourceName: "error_icon"), iconText: nil, buttonImage: nil, buttonTitle: nil, buttonTapHandler: nil)
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
    
    static func hideAll() {
        SwiftMessages.hideAll()
    }
}
