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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryTableView.register(GalleryImageTableViewCell.nib(), forCellReuseIdentifier: GalleryImageTableViewCell.ID)
        galleryTableView.delegate = self
        galleryTableView.dataSource = self
        loadInitialData()
    }
    
    func reloadGallery() {
        DispatchQueue.main.async {
            self.galleryTableView.reloadData()
        }
    }
    

    func loadInitialData() -> Void {
        UserGallery.GetGalleryForUser(userId: "8b8b14a9-b180-4116-a73c-b6dc5a5fb291"){result in
            switch(result){
            case .success(let gallery):
                self.userGallery = gallery
                self.reloadGallery()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadMoreData() {
        if self.userGallery?.canFetchMore() == true {
            print("Loading More data")
            self.userGallery?.loadMore() { result in
                switch(result){
                case .success:
                    self.reloadGallery()
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
        print("selected")
    }
}

extension GalleryViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Retrieving Cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: GalleryImageTableViewCell.ID, for: indexPath) as! GalleryImageTableViewCell
        print(cell)
//        let cell = tableView.dequeueReusableCell(withIdentifier: UserGalleryTableViewCell.identifier, for: indexPath) as! UserGalleryTableViewCell
        cell.configure(with: userGallery!.items()[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userGallery?.items().count ?? 0
    }
}
