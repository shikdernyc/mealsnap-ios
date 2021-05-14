//
//  GalleryViewController.swift
//  MealSnap
//
//  Created by Asif Shikder on 3/22/21.
//

import UIKit
import AVFoundation

class GalleryViewController: UIViewController {
    @IBOutlet weak var galleryTableView: UITableView!
    
    private var userGallery: UserGallery?
    
    private var userId: String = ""
    
    private var requestedTitle = ""
    
    private var refreshPlayer : AVAudioPlayer? = nil
        
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
        galleryTableView.refreshControl?.addTarget(self, action: #selector(handleRefreshData), for: .valueChanged)
        if userId.count == 0 {
            do {
                let user = try AuthManager.CurrentUser()
                self.configure(for: user.userId)
            } catch let error {
                print(error)
            }
        }
        self.loadInitialData()

        // User Preference Listender
        UserPreference.HideImageDetail() { _ in
            self.reloadGalleryData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (requestedTitle.count != 0) {
            self.navigationController?.navigationBar.topItem?.title = requestedTitle
            requestedTitle = ""
        }
    }
    
    public func configure(for userId: String, username:String? = nil) {
        print("Configuring for " + userId)
        if username != nil{
            // TODO: This is confusing. Centralize starting this activity using configure from both other pages as well as view controller
            self.requestedTitle = username!
        }
        self.userId = userId
    }
    
    private func reloadGalleryData() {
        DispatchQueue.main.async {
            self.galleryTableView.reloadData()
        }
    }
    
    @objc private func handleRefreshData() -> Void {
        DispatchQueue.main.async {
            self.galleryTableView.refreshControl?.beginRefreshing()
        }
        self.loadInitialData() { _ in
            DispatchQueue.main.async {
                self.refreshPlayer?.play()
                self.galleryTableView.refreshControl?.endRefreshing()
            }
            self.reloadGalleryData()
        }
    }
    
    private func loadInitialData(callback: ((Result<Bool, Error>) -> Void)? = nil) -> Void {
        UserGallery.GetGalleryForUser(userId: self.userId){result in
            switch(result){
            case .success(let gallery):
                self.userGallery = gallery
                self.reloadGalleryData()
                callback?(.success(true))
            case .failure(let error):
                callback?(.failure(error))
                print(error)
            }
        }
    }
    
    private func loadMoreData() {
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
