//
//  SplashViewController.swift
//  VassQuick_iOS
//
//  Created by Markel Juaristi Mendarozketa   on 11/3/24.
//

import UIKit
import SwiftUI
import Combine

class SplashViewController: UIViewController {
    
    // MARK: - Properties
    private var keyChainManager = KeyChainManager.shared
    private var timer: Timer?
    private var progressTimer: Timer?
    
    // MARK: - Outlets
    @IBOutlet weak var imgLogo: UIImageView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigateToLoginAfterDelay()
    }
    
    // MARK: - Private

    private func navigateToLoginAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            let loginWireframe = LoginWireframe()
            loginWireframe.push(navigation: self.navigationController)
        }
    }
}
