//
//  ImageDetailViewController.swift
//  MealSnap
//
//  Created by Asif Shikder on 5/8/21.
//

import UIKit

class ImageDetailViewController: UIViewController {
    
    var imageModel: GalleryImage? = nil
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard imageModel != nil else {
            AlertComponent.showError(on: self, message: "This view has not been properly configured")
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.descriptionLabel.text = imageModel!.description
        self.imageView.setImage(url: imageModel!.imageUrl, delegate: self)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = imageModel?.title
    }
    
    func configure(with image: GalleryImage) {
        self.imageModel = image
    }
}

extension ImageDetailViewController : UIImageViewSetImageUrlDelegate {
    func onImageSetByUrlError(error: Error) {
        AlertComponent.showError(on: self, message: "Unable to display image")
        print(error)
    }
}
