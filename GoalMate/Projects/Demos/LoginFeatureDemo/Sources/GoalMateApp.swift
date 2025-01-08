import SwiftUI

@main
struct GoalMateApp: App {
    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    let store = Store(
        initialState: AppReducer.State()
    ) {
        AppReducer().transformDependency(\.self) { dependency in
            // 의존성 변환
        }
    }
    
    func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
      self.store.send(.appDelegate(.didFinishLaunching))
      return true
    }

    func application(
      _ application: UIApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
//      self.store.send(.appDelegate(.didRegisterForRemoteNotifications(.success(deviceToken))))
    }

    func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
//      self.store.send(.appDelegate(.didRegisterForRemoteNotifications(.failure(error))))
    }
}
