import UIKit
import RxChallengeNetwork

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Generate the application screen factory
        let screenFactory = AppScreenFactory(postScreenFactory: PostScreenFactory())
        
        //Generate the application providers
        let providers = AppProviders(typicodeProvider: TypicodeProvider(networkProvider: MoyaNetworkProvider.shared))
        
        //Start main coordinator
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        let naviationController = UINavigationController()
        let listCoordinator = ListCoordinator(navigationController: naviationController, screenFactory: screenFactory, providers: providers)
        listCoordinator.start()
        listCoordinator.setRootViewController(in: window)
        return true
    }
}

