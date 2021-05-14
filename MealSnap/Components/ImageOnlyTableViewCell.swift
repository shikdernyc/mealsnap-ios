//
//  ImageOnlyTableViewCell.swift
//  MealSnap
//
//  Created by Asif Shikder on 5/13/21.
//

import UIKit

class ImageOnlyTableViewCell: UITableViewCell {
    @IBOutlet weak var galleryImage: UIImageView!
    static let ID = "ImageOnlyTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setGalleryImage(to image: UIImage) {
        self.galleryImage.image = image
        self.galleryImage.contentMode = .scaleAspectFill
        self.galleryImage.layer.borderWidth = 0.3
        self.galleryImage.layer.cornerRadius = 7
        self.galleryImage.layer.masksToBounds = true
        self.galleryImage.layer.borderColor = UIColor.gray.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(with image: GalleryImage) {
        ImageService.fetch(imageUrl: image.imageUrl) { result in
            switch(result){
            case .success(let image):
                self.setGalleryImage(to: image)
                return
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: ID, bundle: nil)
    }
}
