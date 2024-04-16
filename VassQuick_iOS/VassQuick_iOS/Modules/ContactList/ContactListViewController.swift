//
//  ContactListViewController.swift
//  VassQuick_iOS
//
//  Created by Daniel Cazorro Frias  on 11/3/24.
//

import Combine
import UIKit

class ContactListViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel: ContactListViewModel?
    private var cancellables = Set<AnyCancellable>()
    private let refreshControl = UIRefreshControl()
    private var sizeOfTable: CGFloat = 56

    // MARK: - Outlets
    @IBOutlet weak var sbSearchBarContactList: UISearchBar!
    @IBOutlet weak var lbContactListLabel: UILabel!
    @IBOutlet weak var tvContactListTableView: UITableView!
    @IBOutlet weak var lbNumberOfUsers: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        configureTableView()
        bindViewModel()
        configureNavigationAppearance()
        viewModel?.activateRefreshTrigger()
        viewModel?.fetchUsers()
        setupNavigationBinding()
    }
    
    // MARK: - Methods
    func set(viewModel: ContactListViewModel) {
        self.viewModel = viewModel
    }
    
    func configureTableView() {
        tvContactListTableView.delegate = self
        tvContactListTableView.dataSource = self
        tvContactListTableView.register(UINib(nibName: "CellContactListTableViewCell", bundle: nil), forCellReuseIdentifier: "CellContactListTableViewCell")
        
        refreshControl.attributedTitle = NSAttributedString(string: "contact_list_view_controller_refresh".localized)
        refreshControl.addTarget(self, action: #selector(refreshContactList), for: .valueChanged)
        tvContactListTableView.refreshControl = refreshControl
        
        lbContactListLabel.text = "contact_list_view_controller_title".localized
    }
    
    func configureNumberOfUsers() {
        lbNumberOfUsers.text = "\(viewModel?.filteredUsers.count ?? 0) " +
        "contact_list_view_controller_number_of_users".localized
        lbNumberOfUsers.font = .systemFont(ofSize: 18)
        lbNumberOfUsers.textColor = .white
    }
    
    private func configureNavigationAppearance() {
        navigationController?.navigationBar.tintColor = .blue40
    }
    
    private func configureSearchBar() {
        sbSearchBarContactList.delegate = self
        sbSearchBarContactList.barTintColor = .black
        sbSearchBarContactList.placeholder =
        "chat_list_view_controller_search_bar_placeholder".localized
        
        if let textFieldInsideSearchBar = sbSearchBarContactList.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.textColor = .white
        }
    }
    
    @objc private func refreshContactList() {
        viewModel?.refreshTrigger.send()
    }

    // MARK: - Private Methods
    private func bindViewModel() {
        viewModel?.$filteredUsers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tvContactListTableView.reloadData()
                self?.refreshControl.endRefreshing()
                self?.configureNumberOfUsers()
            }
            .store(in: &cancellables)
    }

    private func setupNavigationBinding() {
        viewModel?.navigateToChatPublisher
            .sink { [weak self] chatView, user in
                let wireframe = MessageListWireframe()
                wireframe.push(navigation: self?.navigationController, withChatView: chatView, withUser: user)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Extensions
extension ContactListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = viewModel?.allUsers[indexPath.row] else {
            print("Error: No se pudo obtener el usuario seleccionado.")
            return
        }
        
        viewModel?.handleChatSelection(for: user)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        sizeOfTable

    }

}

extension ContactListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.filteredUsers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellContactListTableViewCell.identifier, for: indexPath) as? CellContactListTableViewCell,
              let user = viewModel?.filteredUsers[indexPath.row] else {
            
            fatalError("contact_list_view_controller_error_cell".localized)
        }
        cell.configure(with: user)
        return cell
    }
}

extension ContactListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.filterUsers(by: searchText)
    }
}
