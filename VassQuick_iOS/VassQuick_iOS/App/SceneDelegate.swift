//
//  SceneDelegate.swift
//  VassQuick_iOS
//
//  Created by Markel Juaristi Mendarozketa   on 5/3/24.
//

import Combine
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var apiClient = ApiClientManager()
    private var cancellables = Set<AnyCancellable>()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        
        let splashViewWireframe = SplashWireframe()
        let navigationController = UINavigationController(rootViewController: splashViewWireframe.viewController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).

    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.

    }

    func sceneWillResignActive(_ scene: UIScene) {
        apiClient.putOfflineStatus()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error poniendo el estado offline: \(error)")
                case .finished:
                    print("La solicitud de estado offline se completó")
                }
            }, receiveValue: { response in
                print("Respuesta de la solicitud de estado offline: \(response)")
            })
            .store(in: &cancellables)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.

    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        apiClient.putOfflineStatus()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error poniendo el estado offline: \(error)")
                case .finished:
                    print("La solicitud de estado offline se completó")
                }
            }, receiveValue: { response in
                print("Respuesta de la solicitud de estado offline: \(response)")
            })
            .store(in: &cancellables)
    }

}
