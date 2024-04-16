//
//  ProfileSettingWireframe.swift
//  VassQuick_iOS
//
//  Created by Markel Juaristi Mendarozketa   on 19/3/24.
//

import Foundation
import SwiftUI
 
enum ProfileSettingWireframe {
    // MARK: - Methods
    static func composeView() -> AnyView {
        
        let apiClient = ApiClientSettingManager()
        let dataManager = ProfileDataManager(apiClient: apiClient)
        
        let viewModel = ProfileSettingViewModel(dataManager: dataManager)
        
        let view = ProfileSettingView(viewModel: viewModel)
        return AnyView(view)
        
    }
}
