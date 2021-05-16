//
//  GalleryViewController.swift
//  MealSnap
//
//  Created by Asif Shikder on 3/22/21.
//

import UIKit
import AVFoundation

enum GalleryViewControllerError : Error {
    case UserIsNotSet
}

class GalleryViewController: UIViewController {
    @IBOutlet weak var galleryTableView: UITableView!
    
    private var userGallery: UserGallery?
    
    private var user: UserSummary?
    
    private var refreshPlayer : AVAudioPlayer? = nil
    
    public func configure(for user: UserSummary) {
        self.user = user
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Audio Player
        do {
            self.refreshPlayer = try AudioService.Player(for: .Refresh)
        }catch let error {
            print(error)
        }
        
        // Setup Gallery Table View
        galleryTableView.register(GalleryImageTableViewCell.nib(), forCellReuseIdentifier: GalleryImageTableViewCell.ID)
        galleryTableView.register(ImageOnlyTableViewCell.nib(), forCellReuseIdentifier: ImageOnlyTableViewCell.ID)
        galleryTableView.delegate = self
        galleryTableView.dataSource = self
        galleryTableView.refreshControl = UIRefreshControl()
        galleryTableView.refreshControl?.addTarget(self, action: #selector(handleRefreshUserGallery), for: .valueChanged)
        if user == nil {
            do {
                self.user = try AuthService.CurrentUser()
            } catch let error {
                print(error)
            }
        }
        self.loadInitialData()
        
        // User Preference Listender
        UserPreference.HideImageDetail() { _ in
            self.reloadGalleryView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        do{
            let currentAuthUser = try AuthService.CurrentUser()
            if currentAuthUser.userId != self.user?.userId {
                self.navigationController?.navigationBar.topItem?.title = self.user?.userName
            }else {
                self.navigationController?.navigationBar.topItem?.title = "Profile"
            }
        }catch {
            print("Unable to fetch current user")
        }
    }
    
    private func reloadGalleryView() {
        DispatchQueue.main.async {
            self.galleryTableView.reloadData()
        }
    }
    
    @objc private func handleRefreshUserGallery() -> Void {
        DispatchQueue.main.async {
            self.galleryTableView.refreshControl?.beginRefreshing()
        }
        self.loadInitialData() { _ in
            DispatchQueue.main.async {
                self.refreshPlayer?.play()
                self.galleryTableView.refreshControl?.endRefreshing()
            }
            self.reloadGalleryView()
        }
    }
    
    private func loadInitialData(callback: ((Result<Bool, Error>) -> Void)? = nil) -> Void {
        guard (self.user != nil) else {
            callback?(.failure(GalleryViewControllerError.UserIsNotSet))
            return
        }
        UserGallery.GetGalleryForUser(userId: self.user!.userId){result in
            switch(result){
            case .success(let gallery):
                self.userGallery = gallery
                self.userGallery?.itemUpdateDelegate = self
                self.reloadGalleryView()
                callback?(.success(true))
            case .failure(let error):
                callback?(.failure(error))
                print(error)
            }
        }
    }
}

extension GalleryViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let detailVc = self.storyboard?.instantiateViewController(identifier: StoryboardId.ImageDetailViewController.rawValue) as? ImageDetailViewController else {
            AlertComponent.showError(on: self, message: "Unable to open image")
            return
        }
        let imageModel = self.userGallery?.items()[indexPath.row]
        guard imageModel != nil else{
            AlertComponent.showError(on: self, message: "Unable to retrieve image data")
            return
        }
        detailVc.configure(with: imageModel!)
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
}

extension GalleryViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if UserPreference.HideImageDetail() {
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageOnlyTableViewCell.ID, for: indexPath) as! ImageOnlyTableViewCell
            cell.configure(with: userGallery!.items()[indexPath.row])
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: GalleryImageTableViewCell.ID, for: indexPath) as! GalleryImageTableViewCell
        cell.configure(with: userGallery!.items()[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userGallery?.items().count ?? 0
    }
}

// ============= Handling Pagination =============
extension GalleryViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard userGallery?.canFetchMore() == true else {
            return
        }
        let position = scrollView.contentOffset.y
        if position > (galleryTableView.contentSize.height - 1000 - scrollView.frame.size.height){
            print("Loading More")
            userGallery?.loadMore()
        }
    }
}

// ============= Handle Update to Gallery List Item =============
extension GalleryViewController : UserGalleryItemsUpdateDelegate {
    func itemListDidUpdate(newItems: [GalleryImage]) {
        self.reloadGalleryView()
    }
    
    func itemListUpdateError(error: UserGalleryError) {
        print(error)
        AlertComponent.showError(on: self, message: "An error occured trying to load more data")
    }
}
