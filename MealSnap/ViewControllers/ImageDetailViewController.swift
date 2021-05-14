//
//  ImageDetailViewController.swift
//  MealSnap
//
//  Created by Asif Shikder on 5/8/21.
//

import UIKit

class ImageDetailViewController: UIViewController {
    
    var imageModel: GalleryImage? = nil
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard imageModel != nil else {
            AlertComponent.showError(on: self, message: "This view has not been properly configured")
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.titleLabel.text = imageModel!.title
        self.descriptionLabel.text = imageModel!.description
        ImageService.fetch(imageUrl: self.imageModel!.imageUrl) {result in
            switch(result) {
            case .success(let image):
                self.imageView.image = image
                return
            case .failure(let error):
                AlertComponent.showError(on: self, message: "Unable to fetch image")
                print(error)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = imageModel?.title
    }
    
    func configure(with image: GalleryImage) {
        self.imageModel = image
//        self.descriptionLabel.text = image.description
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
