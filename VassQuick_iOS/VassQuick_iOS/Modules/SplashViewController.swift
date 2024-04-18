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
//    private let welcomeMessages = ["¡Bienvenido al chat!", "¡Hola! ¿Listo para chatear?", "¡Encantados de verte de nuevo!", "¡Que tengas un gran día de chats!"]
    
    // MARK: - Outlets
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubtitle: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupProgressBar()
    }
    
    // MARK: - Private
    private func setupDesign() {        
        view.backgroundColor = .black
        imgLogo.image = UIImage(named: "iconVassQuick")
        
        //lbTitle.textColor = .white
        //lbTitle.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        //lbSubtitle.textColor = .white
       // lbSubtitle.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    }
    
    private func setupProgressBar() {
        progressBar.progress = 0.0
        progressBar.progressTintColor = .blue40
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgressBar), userInfo: nil, repeats: true)
    }
    
    @objc private func updateProgressBar() {
        progressBar.progress += 0.1
        if progressBar.progress >= 1 {
            progressTimer?.invalidate()
            let loginWireframe = LoginWireframe()
            loginWireframe.push(navigation: self.navigationController)
        }
    }

}
