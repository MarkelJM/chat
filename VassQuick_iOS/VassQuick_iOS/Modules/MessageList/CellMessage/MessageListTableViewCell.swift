//
//  MessageListTableViewCell.swift
//  VassQuick_iOS
//
//  Created by Daniel Cazorro Frias  on 18/3/24.
//

import UIKit

class MessageListTableViewCell: UITableViewCell {

    // MARK: - Properties
    static let identifier = "MessageListTableViewCell"
    
    // MARK: - Outlets
    @IBOutlet weak var lbMessageLabel: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var svStackViewCell: UIStackView!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!    
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
        
        leadingConstraint.isActive = false
        trailingConstraint.isActive = false
      
        // Ahora establece los nuevos constraints con prioridades
        leadingConstraint = svStackViewCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50)
        trailingConstraint = svStackViewCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50)
      
        // Establece la prioridad para evitar conflictos
        leadingConstraint.priority = UILayoutPriority(999)
        trailingConstraint.priority = UILayoutPriority(999)
      
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
    }

    // MARK: - Configuration
    func configure(with message: MessageListModel, currentUserID: String) {
        contentView.backgroundColor = .black
        svStackViewCell.layer.cornerRadius = 8
        
        let isCurrentUser = message.source == currentUserID
        
        // Ajusta los constraints basado en el propietario del mensaje
        leadingConstraint.constant = isCurrentUser ? 8 : 50
        trailingConstraint.constant = isCurrentUser ? -50 : -8
        
        // No necesitas configurar `svStackViewCell.alignment` ya que lo haces aquí abajo
        svStackViewCell.backgroundColor = isCurrentUser ? .systemCyan : .systemBlue
        
        lbMessageLabel.textColor = .white
        lbDate.textColor = .white
        
        // Configuración de la alineación del texto en base a quién envía el mensaje
        lbMessageLabel.textAlignment = isCurrentUser ? .right : .left
        lbDate.textAlignment = isCurrentUser ? .right : .left
        
        lbMessageLabel.text = message.message
        lbDate.text = Date.formatTime(from: message.date)
        
    }
}
