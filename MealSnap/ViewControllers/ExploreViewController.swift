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
    private var searchLoadingIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchUserTable.register(SearchUserTableViewCell.nib(), forCellReuseIdentifier: SearchUserTableViewCell.ID)
        searchUserTable.delegate = self
        searchUserTable.dataSource = self
        searchUserTable.separatorColor = UIColor.clear
        usernameInput.delegate = self
        usernameInput.addBorder()
        self.searchLoadingIndicator = LoadingIndicatorAddon.Attach(to: searchUserTable)
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
        tableView.deselectRow(at: indexPath, animated: true)
        guard let user = searchedUsers[indexPath.row] as UserSummary? else {
            return
        }
        DispatchQueue.main.async {
            guard let galleryVC = self.storyboard?.instantiateViewController(identifier: StoryboardId.GalleryViewController.rawValue) as? GalleryViewController else {
                AlertComponent.showError(on: self, message: "Unable to navigate to user's page")
                return
            }
            galleryVC.configure(for: user)
            self.navigationController?.pushViewController(galleryVC, animated: true)
        }
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
    private func showLoading(to value: Bool = true) {
        DispatchQueue.main.async {
            if value {
                self.searchLoadingIndicator?.startAnimating()
            }else{
                self.searchLoadingIndicator?.stopAnimating()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text else {
            return true
        }
        self.showLoading()
        User.FindUser(query: query) {result in
            switch(result){
            case .success(let user):
                self.updateSearchUserList(to: user)
            case .failure(let error):
                self.updateSearchUserList(to: [])
                print(error)
                AlertComponent.showError(on: self, message: error.localizedDescription)
            }
            self.showLoading(to: false)
        }
        return true
    }
}
