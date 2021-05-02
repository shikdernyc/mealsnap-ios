//
//  GalleryViewController.swift
//  MealSnap
//
//  Created by Asif Shikder on 3/22/21.
//

import UIKit

class GalleryViewController: UIViewController {
    public static let StoryboardId = "gallery_vc"
    @IBOutlet weak var galleryTableView: UITableView!
    
    private var userGallery: UserGallery?
    
    private var userId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userId.count == 0 {
            do {
                let user = try AuthManager.CurrentUser()
                self.userId = user.userId
                print(user)
            } catch let error {
                print(error)
            }
        }
        galleryTableView.register(GalleryImageTableViewCell.nib(), forCellReuseIdentifier: GalleryImageTableViewCell.ID)
        galleryTableView.delegate = self
        galleryTableView.dataSource = self
        galleryTableView.refreshControl = UIRefreshControl()
        galleryTableView.refreshControl?.addTarget(self, action: #selector(loadInitialData), for: .valueChanged)
        self.loadInitialData()
    }
    
    func reloadGalleryData() {
        DispatchQueue.main.async {
            self.galleryTableView.reloadData()
        }
    }

    @objc func loadInitialData() -> Void {
        DispatchQueue.main.async {
            self.galleryTableView.refreshControl?.beginRefreshing()
        }
        UserGallery.GetGalleryForUser(userId: self.userId){result in
            switch(result){
            case .success(let gallery):
                self.userGallery = gallery
                self.reloadGalleryData()
            case .failure(let error):
                print(error)
            }
            DispatchQueue.main.async {
                self.galleryTableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    func loadMoreData() {
        if self.userGallery?.canFetchMore() == true {
            print("Loading More data")
            self.userGallery?.loadMore() { result in
                switch(result){
                case .success:
                    self.reloadGalleryData()
                case .failure(let error):
                    print(error)
                }
                
            }
        }
    }
}

extension GalleryViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension GalleryViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GalleryImageTableViewCell.ID, for: indexPath) as! GalleryImageTableViewCell
        cell.configure(with: userGallery!.items()[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userGallery?.items().count ?? 0
    }
}

extension GalleryViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard userGallery?.canFetchMore() == true else {
            return
        }
        let position = scrollView.contentOffset.y
        if position > (galleryTableView.contentSize.height - 600 - scrollView.frame.size.height){
                print("Loading More")
                userGallery?.loadMore() { result in
                    switch(result){
                    case .success:
                        self.reloadGalleryData()
                        return
                    case .failure(let error):
                        print("Failed to load more")
                        print(error)
                    }
                }
        }
    }
}
