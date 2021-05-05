//
//  ExploreViewController.swift
//  MealSnap
//
//  Created by Asif Shikder on 3/23/21.
//

import UIKit

class ExploreViewController: UIViewController {
    @IBOutlet weak var searchUserTable: UITableView!
    @IBOutlet weak var usernameInput: UITextField!
    
    private var searchedUsers: [UserSummary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchUserTable.register(SearchUserTableViewCell.nib(), forCellReuseIdentifier: SearchUserTableViewCell.ID)
        searchUserTable.delegate = self
        searchUserTable.dataSource = self
        usernameInput.delegate = self
        // Do any additional setup after loading the view.
    }
    
    private func updateSearchUserList(to users: [UserSummary]) {
        self.searchedUsers = users
        DispatchQueue.main.async {
            self.searchUserTable.reloadData()
        }
    }
}

extension ExploreViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(searchedUsers[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO: Send to user gallery
    }
}

extension ExploreViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchUserTableViewCell.ID, for: indexPath) as! SearchUserTableViewCell
        cell.configure(with: self.searchedUsers[indexPath.row])
        return cell
    }
}

extension ExploreViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let username = textField.text else {
            return true
        }
        print(username)
        User.FindUser(username: username) {result in
            switch(result){
            case .success(let user):
                self.updateSearchUserList(to: user)
            case .failure(let error):
                self.updateSearchUserList(to: [])
                print(error)
                AlertComponent.showError(on: self, message: error.localizedDescription)
                return
            }
        }
        return true
    }
}
