//
//  MessageTableViewCell.swift
//  VassQuick_iOS
//
//  Created by Markel Juaristi Mendarozketa   on 26/3/24.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    var topConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bubbleBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(bubbleBackgroundView)
        bubbleBackgroundView.addSubview(messageLabel)
        bubbleBackgroundView.addSubview(dateLabel)

        // Bubble Margins
        let bubbleMargin: CGFloat = 32
        let bubblePadding: CGFloat = 10

        // Top and Bottom Constraints for Bubble View
        topConstraint = bubbleBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 16)
        bottomConstraint = bubbleBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)

        // Leading and Trailing Constraints for Bubble View
        leadingConstraint = bubbleBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: bubbleMargin)
        trailingConstraint = bubbleBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -bubbleMargin)
        
        // Restricción para el ancho máximo de bubbleBackgroundView
        let maxWidthConstraint = bubbleBackgroundView.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 0.75)
        maxWidthConstraint.priority = UILayoutPriority(rawValue: 999)
        maxWidthConstraint.isActive = true

        // Activate Common Constraints
        NSLayoutConstraint.activate([
            topConstraint,
            bottomConstraint,
            leadingConstraint,
            trailingConstraint,
            
            messageLabel.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor, constant: bubblePadding),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: bubblePadding),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -bubblePadding),
            
            dateLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: bubblePadding),
            dateLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -bubblePadding),
            dateLabel.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -bubblePadding)
        ])
    }
    /*
    func configure(with message: String, date: String, isCurrentUser: Bool) {
        messageLabel.text = message
        dateLabel.text = date
        
        bubbleBackgroundView.backgroundColor = isCurrentUser ? .systemBlue : .systemCyan
        messageLabel.textAlignment = isCurrentUser ? .right : .left
        dateLabel.textAlignment = isCurrentUser ? .right : .left
        
        messageLabel.textAlignment = .left
        dateLabel.textAlignment = isCurrentUser ? .right : .left

        // Adjust Constraints for User
        leadingConstraint.isActive = !isCurrentUser
        trailingConstraint.isActive = isCurrentUser
        
        // Priority Adjustment for Content Hugging
        messageLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        dateLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        if isCurrentUser {
            trailingConstraint.constant = -16
            leadingConstraint.constant = CGFloat.greatestFiniteMagnitude
        } else {
            leadingConstraint.constant = 16
            trailingConstraint.constant = -CGFloat.greatestFiniteMagnitude
        }
        
        // Force Layout
        layoutIfNeeded()
    }
     */
    func configure(with message: String, date: String, isCurrentUser: Bool) {
        messageLabel.text = message
        dateLabel.text = date
        
        if isCurrentUser {
            bubbleBackgroundView.backgroundColor = .blue20
            messageLabel.textColor = .blue80
            dateLabel.textColor = .blue80
            messageLabel.textAlignment = .right
            dateLabel.textAlignment = .right

            trailingConstraint.constant = -16
            leadingConstraint.constant = CGFloat.greatestFiniteMagnitude
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
        } else {
            bubbleBackgroundView.backgroundColor = .blue80
            messageLabel.textColor = .blue20
            dateLabel.textColor = .blue20
            messageLabel.textAlignment = .left
            dateLabel.textAlignment = .left

            leadingConstraint.constant = 16
            trailingConstraint.constant = -CGFloat.greatestFiniteMagnitude
            leadingConstraint.isActive = true
            trailingConstraint.isActive = false
        }
        
        // Ajustes comunes independientemente del usuario
        messageLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        dateLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        // Forzar actualización del layout
        layoutIfNeeded()
    }


    override func prepareForReuse() {
        super.prepareForReuse()
        leadingConstraint.isActive = false
        trailingConstraint.isActive = false
    }
}
