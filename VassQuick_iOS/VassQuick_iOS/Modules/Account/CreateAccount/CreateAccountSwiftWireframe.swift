//
//  CreateAccountSwiftWireframe.swift
//  VassQuick_iOS
//
//  Created by Markel Juaristi Mendarozketa   on 12/3/24.
//

import Foundation
import SwiftUI
 
enum CreateAccountSwiftWireframe {
    // MARK: - Methods
    static func composeView() -> AnyView {
        
        let apiClient = ApiClientRegisterManager()
        let dataManager = CreateAccountSwiftUIDataManager(apiClient: apiClient)
        
        let viewModel = CreateAccountSwiftUIViewModel(dataManager: dataManager)
        
        let view = CreateAccountSwiftUIView(viewModel: viewModel)
        return AnyView(view)
        
    }
}
