//
//  PhotoDetailViewController.swift
//  MealSnap
//
//  Created by Asif Shikder on 5/7/21.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    private var imageData: GalleryImage? = nil
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard imageData != nil else {
            print("Image not set")
            return
        }
        self.titleLabel.text = imageData?.title
        self.descriptionTextView.text = imageData?.description
        self.updateImageView()
        // Do any additional setup after loading the view.
    }
    
    func configure(with image: GalleryImage) {
        self.imageData = image
    }
    
    private func setGalleryImage(to image: UIImage) {
        self.postImageView.image = image
        self.postImageView.contentMode = .scaleAspectFill
    }
    
    private func updateImageView() {
        ImageService.fetch(imageUrl: self.imageData!.imageUrl) {result in
            switch(result){
            case .success(let image):
                self.setGalleryImage(to: image)
                return
            case .failure:
                print("Failed to fetch image")
                return
            }
            
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
