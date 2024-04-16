//
//  CellContactListTableViewCell.swift
//  VassQuick_iOS
//
//  Created by Daniel Cazorro Frias  on 12/3/24.
//

import UIKit

class CellContactListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "CellContactListTableViewCell"
    
    // MARK: - Outlets
    @IBOutlet weak var imImageViewContact: UIImageView!
    @IBOutlet weak var svNameNickStackView: UIStackView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbNick: UILabel!
    
    // MARK: - Lifecycle
    func configure(with user: User) {
        lbName.text = user.login ?? "cell_contact_list_table_view_cell_title".localized
        lbNick.text = "cell_contact_list_table_view_cell_message_default".localized
        
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let defaultAvatar = UIImage(systemName: "person.crop.circle")
        
        if let avatarUrlString = user.avatar, let avatarUrl = URL(string: avatarUrlString), !avatarUrlString.isEmpty {
        } else {
            imImageViewContact.image = defaultAvatar
            imImageViewContact.tintColor = .grey40
        }
    }
}
