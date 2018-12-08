import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        let naviationController = UINavigationController()
        let listCoordinator = ListCoordinator(navigationController: naviationController)
        listCoordinator.start()
        listCoordinator.setRootViewController(in: window)
        return true
    }
}

