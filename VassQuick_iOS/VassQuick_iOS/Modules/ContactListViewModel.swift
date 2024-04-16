//
//  ContactListViewModel.swift
//  VassQuick_iOS
//
//  Created by Daniel Cazorro Frias  on 11/3/24.
//

import Combine
import Foundation

class ContactListViewModel {
    
    // MARK: - Properties
    let dataManager: ContactListDataManager?
    
    // MARK: - Init
    init(dataManager: ContactListDataManager) {
        self.dataManager = dataManager
    }
    
    // MARK: - Methods
    func countUsers() -> Int {
        dataManager?.users.count ?? 0
    }
    
    func getUsers() -> AnyPublisher<[User], BaseError> {
        print("ViewModel getUsers: \(String(describing: dataManager?.getUsers()))")
        
        guard let dataManager = dataManager else {
            return Fail(error: BaseError.generic).eraseToAnyPublisher()
        }
        return dataManager.getUsers()
    }
}
