//
//  MessageListViewController.swift
//  VassQuick_iOS
//
//  Created by Daniel Cazorro Frias  on 18/3/24.
//

import Combine
import UIKit

class MessageListViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: MessageListViewModel?
    var chat: ChatView?
    var user: User?
    private var cancellables = Set<AnyCancellable>()
    private let refreshControl = UIRefreshControl()
    private let loadMoreActivityIndicator = UIActivityIndicatorView(style: .medium)
        
    // MARK: - Outlets
    @IBOutlet weak var btSendMessageButton: UIButton!
    @IBOutlet weak var tvMessageListTableView: UITableView!
    @IBOutlet weak var messageTextView: UITextView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureTableView()
        configureTextView()
        configureSendMessageButton()
        configureBackButton()
        showMessages()
        setupTitle()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func sendMessageButtonTapped(_ sender: UIButton) {
        guard let messageText = messageTextView.text, !messageText.isEmpty,
              let chatID = chat?.chat, let sourceID = viewModel?.getCurrentUserId() else { return }
        viewModel?.postNewMessage(chatID: chatID, sourceID: sourceID, message: messageText)
        
        self.messageTextView.text = nil
        self.btSendMessageButton.isHidden = true
    }

    // MARK: - Public methods
    func set (viewModel: MessageListViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Private methods
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func showMessages() {
        viewModel?.getMessagesList(for: chat?.chat ?? "")
    }
    
    private func configureBackButton() {
        let backButton = UIBarButtonItem(title: "Chats", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        backButton.tintColor = .blue40
    }
    
    private func setupTitle() {
        if let user = user {
            navigationItem.title = user.nick ?? user.login
        } else if let chat = chat {
            let title = chat.source == viewModel?.getCurrentUserId() ? chat.targetnick : chat.sourcenick
            navigationItem.title = title
        }
    }
    
    @objc private func backButtonTapped() {
        let chatListViewController = ChatListWireframe().viewController
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        
        navigationController?.pushViewController(chatListViewController, animated: false)
    }
    
    @objc private func refreshMessages() {
        viewModel?.loadOlderMessages(for: chat?.chat ?? "", offset: viewModel?.messages.count ?? 0, limit: 16)
        refreshControl.endRefreshing()
    }
    
    private func bindViewModel() {
        viewModel?.$messages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tvMessageListTableView.reloadData()
                self?.refreshControl.endRefreshing()
                self?.loadMoreActivityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
    }

    private func configureTableView() {
        tvMessageListTableView.delegate = self
        tvMessageListTableView.dataSource = self
        tvMessageListTableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageTableViewCell")
        tvMessageListTableView.backgroundColor = .black
        tvMessageListTableView.separatorStyle = .none 
        tvMessageListTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
        tvMessageListTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)

        tvMessageListTableView.estimatedRowHeight = 100
        tvMessageListTableView.rowHeight = UITableView.automaticDimension
        
        loadMoreActivityIndicator.color = .white
        tvMessageListTableView.tableFooterView = loadMoreActivityIndicator

        refreshControl.addTarget(self, action: #selector(refreshMessages), for: .valueChanged)
        tvMessageListTableView.refreshControl = refreshControl
    }

    private func configureTextView() {
        messageTextView.delegate = self
        messageTextView.layer.borderColor = UIColor.lightGray.cgColor
        messageTextView.layer.borderWidth = 1
        messageTextView.layer.cornerRadius = 8
        messageTextView.textColor = .white
        messageTextView.backgroundColor = .black
        messageTextView.isScrollEnabled = false
        messageTextView.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        messageTextView.font = UIFont.systemFont(ofSize: 16)
    
    }
    
    private func configureSendMessageButton() {
        btSendMessageButton.addTarget(self, action: #selector(sendMessageButtonTapped), for: .touchUpInside)
        btSendMessageButton.tintColor = .blue40
        btSendMessageButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
    }

}

extension MessageListViewController: UITableViewDelegate {
    
}

extension MessageListViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        btSendMessageButton.isHidden = textView.text.isEmpty
    }
}

extension MessageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.messages.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as? MessageTableViewCell,
              let message = viewModel?.messages[indexPath.row] else {
            return UITableViewCell()
        }
        
        let isCurrentUser = message.source == chat?.source
        let messageDate = Date.formatTime(from: message.date) 
        cell.configure(with: message.message, date: messageDate, isCurrentUser: isCurrentUser)
        return cell
    }
}

extension MessageListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tvMessageListTableView.contentSize.height - 100 - scrollView.frame.size.height) {
            guard !loadMoreActivityIndicator.isAnimating else { return }

            loadMoreActivityIndicator.startAnimating()
            viewModel?.loadOlderMessages(for: chat?.chat ?? "", offset: viewModel?.messages.count ?? 0, limit: 16)
        }
    }
}
