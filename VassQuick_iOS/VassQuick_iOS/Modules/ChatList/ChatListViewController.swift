//
//  ChatListViewController.swift
//  VassQuick_iOS
//
//  Created by Daniel Cazorro Frias  on 12/3/24.
//

import Combine
import SwiftUI
import UIKit

class ChatListViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel: ChatListViewModel?
    private var cancellables = Set<AnyCancellable>()
    private let refreshControl = UIRefreshControl()
    private var keyChainManager = KeyChainManager.shared
    private var sizeOfTable: CGFloat = 56

    // MARK: - Outlets
    @IBOutlet weak var svButtonsStackView: UIStackView!
    @IBOutlet weak var btProfileButton: UIButton!
    @IBOutlet weak var btContactListButton: UIButton!
    @IBOutlet weak var lbTitleChats: UILabel!
    @IBOutlet weak var sbChatsSearchBar: UISearchBar!
    @IBOutlet weak var tvChatsTableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupTableView()
        setupSearchBar()
        bindViewModel()
        initialConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - IBActions
    @IBAction func btTapContactListButton(_ sender: Any) {
        let contactListWireframe = ContactListWireframe()
        contactListWireframe.push(navigation: self.navigationController)
    }
    
    @IBAction func btTapProfileButton(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let navigateToProfileAction = UIAlertAction(title:
                                                        "chat_list_view_controller_view_profile".localized,
                                                    style: .default) { [weak self] _ in
            let profileSettingSwiftUIController = UIHostingController(rootView: ProfileSettingView(
                viewModel: ProfileSettingViewModel(dataManager: ProfileDataManager(apiClient: ApiClientSettingManager())),
                dismiss: { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                },
                navigateBackToLogin: { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
            ))
            self?.navigationController?.pushViewController(profileSettingSwiftUIController, animated: true)
        }
        
        alertController.addAction(navigateToProfileAction)
        
        let loginViewController = LoginWireframe().viewController
        let logoutAction = UIAlertAction(title:
                                            "chat_list_view_controller_log_out".localized
                                         , style: .destructive) { [weak self] _ in
            self?.viewModel?.logOut()
            self?.keyChainManager.deleteToken()
            
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            self?.navigationController?.view.layer.add(transition, forKey: kCATransition)
            
            self?.navigationController?.pushViewController(loginViewController, animated: false)
        }
        
        alertController.addAction(logoutAction)
        
        let cancelAction = UIAlertAction(title:
                                            "chat_list_view_controller_cancel".localized,
                                         style: .cancel,
                                         handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Public methods
    func set (viewModel: ChatListViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Private methods
    private func initialConfiguration() {
        viewModel?.fetchCurrentUserProfile()
        viewModel?.activateRefreshTrigger()
    }
    
    private func setupSearchBar() {
        sbChatsSearchBar.barTintColor = .black
        sbChatsSearchBar.placeholder =
        "chat_list_view_controller_search_bar_placeholder".localized

        if let textFieldInsideSearchBar = sbChatsSearchBar.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.textColor = .white
        }
    }
    
    private func setupTableView() {
        tvChatsTableView.delegate = self
        tvChatsTableView.dataSource = self
        tvChatsTableView.register(UINib(nibName: ChatListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ChatListTableViewCell.identifier)
        tvChatsTableView.backgroundColor = .black
        
        refreshControl.attributedTitle = NSAttributedString(string: "chat_list_view_controller_refresh".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        refreshControl.addTarget(self, action: #selector(refreshContactList), for: .valueChanged)
        
        tvChatsTableView.refreshControl = refreshControl
        tvChatsTableView.allowsMultipleSelectionDuringEditing = true
    }
    
    private func bindViewModel() {
        viewModel?.$filteredChats
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.tvChatsTableView.reloadData()
                self?.refreshControl.endRefreshing()
            })
            .store(in: &cancellables)
    }
    
    @objc private func refreshContactList() {
        viewModel?.refreshTrigger.send()
    }
    
}

// MARK: - UITableViewDelegate
extension ChatListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        sizeOfTable
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let chat = viewModel?.filteredChats[indexPath.row] {
            let wireframe = MessageListWireframe()
            wireframe.push(navigation: navigationController, withChatView: chat)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "chat_list_view_controller_delete_chat".localized
                                                ) { [weak self] (_, _, completion) in
            guard let chatID = self?.viewModel?.filteredChats[indexPath.row].chat else {
                completion(false)
                return
            }
            self?.deleteChat(chatID: chatID)
            completion(true)
        }
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    private func deleteChat(chatID: String) {
        viewModel?.deleteChat(chatID: chatID)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.refreshContactList()
        }
    }
}

// MARK: - UITableViewDataSource
extension ChatListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.filteredChats.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatListTableViewCell.identifier, for: indexPath) as? ChatListTableViewCell,
              let chatView = viewModel?.filteredChats[indexPath.row] else {
            return UITableViewCell()
        }

        viewModel?.getLastMessageForChat(chatID: chatView.chat) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let messageListResponse):
                    if let lastMessage = messageListResponse.rows.first {
                        let formattedDate = Date.formatDate(from: lastMessage.date) ?? ""
                        cell.configureCell(with: chatView, lastMessage: lastMessage.message, lastMessageDate: formattedDate)
                    } else {
                        cell.configureCell(with: chatView, lastMessage: "cell_chat_list_view_table_view_cell_message_empty".localized, lastMessageDate: "")                    }
                case .failure:
                    cell.configureCell(with: chatView, lastMessage: "Error al cargar mensajes", lastMessageDate: "")
                }
            }
        }

        return cell
    }

}

extension ChatListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.filterChats(by: searchText)
    }
}
