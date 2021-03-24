//
//  GalleryViewController.swift
//  MealSnap
//
//  Created by Asif Shikder on 3/22/21.
//

import UIKit

class GalleryViewController: UIViewController {
    public static let StoryboardId = "gallery_vc"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
        
    @objc private func handleSelectCreatePost() {
        print("Selected create post")
    }
    
    @objc private func handleSelectSearchUser() {
        print("Selected search user")
    }

}
