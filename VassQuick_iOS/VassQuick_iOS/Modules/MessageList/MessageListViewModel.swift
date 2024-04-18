//
//  MessageListViewModel.swift
//  VassQuick_iOS
//
//  Created by Daniel Cazorro Frias  on 18/3/24.
//

import Combine
import Foundation

class MessageListViewModel {
    
    // MARK: - Properties
    var dataManager: MessageListDataManager
    @Published var messages: [MessageListModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(dataManager: MessageListDataManager) {
        self.dataManager = dataManager
    }
    
    // MARK: - Methods
    func getMessagesList(for chatID: String) {
        dataManager.getMessagesList(chatID: chatID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Error al obtener mensajes: \(error.localizedDescription)")
                case .finished:
                    print(self?.messages.count ?? "")
                    print("Se completó la obtención de mensajes.")
                }
            }, receiveValue: { [weak self] (count, messages) in
                print("Number of messages: \(count)")
                print("Mensajes: \(messages)")
                let sortedMessages = messages.sorted(by: { Int($0.id)! > Int($1.id)! })
                self?.messages = sortedMessages
            })
            .store(in: &cancellables)
    }
    
    func countMessages() -> Int {
        messages.count
    }
    
    func loadOlderMessages(for chatID: String, offset: Int, limit: Int) {
        dataManager.loadOlderMessages(chatID: chatID, offset: offset, limit: limit)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Error al obtener mensajes antiguos: \(error.localizedDescription)")
                case .finished:
                    print("Se completó la obtención de mensajes antiguos.")
                }
            }, receiveValue: { [weak self] (count, messages) in
                print("Number of older messages: \(count)")
                print("Mensajes antiguos: \(messages)")
                /*
                let newMessages = messages.sorted(by: { Int($0.id)! > Int($1.id)! })
                self?.messages = (self?.messages ?? []) + newMessages
                self?.messages.sort(by: { Int($0.id)! > Int($1.id)! })
                 */
                let newMessagesSorted = messages.compactMap { message -> (Int, MessageListModel)? in
                    guard let idInt = Int(message.id) else { return nil }
                    return (idInt, message)
                }.sorted(by: { $0.0 < $1.0 })
                
                // Luego, extraemos solo la parte de MessageListModel de cada tupla y la añadimos a la lista de mensajes.
                let newMessages = newMessagesSorted.map { $0.1 }
                self?.messages.append(contentsOf: newMessages)
            })
            .store(in: &cancellables)
    }
    
    func getCurrentUserId() -> String? {
        return dataManager.getCurrentUserId()
    }
    
    func postNewMessage(chatID: String, sourceID: String, message: String) {
        dataManager.postNewMessage(chatID: chatID, sourceID: sourceID, message: message)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error al enviar mensaje: \(error.localizedDescription)")
                case .finished:
                    print("Mensaje enviado correctamente")
                    self.getMessagesList(for: chatID)
                }
            }, receiveValue: { response in
                print("Respuesta del servidor: \(response)")
            })
            .store(in: &cancellables)
    }

}
