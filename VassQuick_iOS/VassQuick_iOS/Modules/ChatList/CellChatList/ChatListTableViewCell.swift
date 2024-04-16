//
//  CellChatListTableViewCell.swift
//  VassQuick_iOS
//
//  Created by Daniel Cazorro Frias  on 12/3/24.
//

import Combine
import UIKit

class ChatListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "CellChatListTableViewCell"
    private var viewModel: ChatListViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Outlets
    @IBOutlet weak var ivCellImage: UIImageView!
    @IBOutlet weak var svNameMessageStackView: UIStackView!
    @IBOutlet weak var svNameDateStackView: UIStackView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbDateLastMessage: UILabel!
    @IBOutlet weak var lbMessageInformation: UILabel!
    @IBOutlet weak var btOnlineStatus: UIButton!
    
    // MARK: Methods
    func configureCell(with chatView: ChatView, lastMessage: String, lastMessageDate: String) {
        backgroundColor = .black
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        lbName.text = chatView.targetnick
        lbDateLastMessage.text = Date.formatDate(from: chatView.chatcreated)
        lbDateLastMessage.textColor = .grey40
        
        let baseURL = "https://mock-movilidad.vass.es/chatvass"
        let imageURL = baseURL + chatView.targetavatar
        
        if let avatarURL = URL(string: imageURL) {
            downloadImage(from: avatarURL)
        } else {
            ivCellImage.image = UIImage(systemName: "person.crop.circle")
        }
        ivCellImage.tintColor = .grey40
        
        lbName.textColor = .white
        lbDateLastMessage.textColor = .grey40
        
        lbMessageInformation.textColor = .grey40
        lbMessageInformation.font = UIFont.systemFont(ofSize: 12)
        
        btOnlineStatus.tintColor = chatView.targetonline ? .green : .red
        btOnlineStatus.backgroundColor = .clear
        btOnlineStatus.isUserInteractionEnabled = false
        
        lbDateLastMessage.text = lastMessageDate
        lbMessageInformation.text = lastMessage
    }
    
    // MARK: Private Methods
    private func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error downloading image: \(error)")
                DispatchQueue.main.async {
                    self.ivCellImage.image = UIImage(systemName: "person")
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Invalid image data")
                DispatchQueue.main.async {
                    self.ivCellImage.image = UIImage(systemName: "person.crop.circle")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.ivCellImage.image = image
            }
        }.resume()
    }
}
