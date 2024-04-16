//
//  SplashWireframe.swift
//  VassQuick_iOS
//
//  Created by Markel Juaristi Mendarozketa   on 11/3/24.
//

import Foundation
import UIKit

class SplashWireframe {
    
    var viewController: SplashViewController {
        
        let viewController = SplashViewController(nibName: "SplashViewController", bundle: nil)
        
        return viewController
    }
    
    func push(navigation: UINavigationController?) {
        guard let navigation = navigation else { return }
        navigation.pushViewController(viewController, animated: true)
    }
}
