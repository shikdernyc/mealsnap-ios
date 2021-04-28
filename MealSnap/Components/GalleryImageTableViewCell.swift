//
//  GalleryImageTableViewCell.swift
//  MealSnap
//
//  Created by Asif Shikder on 4/28/21.
//

import UIKit

class GalleryImageTableViewCell: UITableViewCell {
    static let ID = "GalleryImageTableViewCell"
    private static let cache = NSCache<NSString, UIImage>()
    @IBOutlet weak var galleryImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
        return UINib(nibName: ID, bundle: nil)
    }
    
    public func configure(with image: GalleryImage) {
        titleLabel.text = image.title
        likeCountLabel.text = String(image.likeCount)
        if let cachedImage = GalleryImageTableViewCell.cache.object(forKey: image.imageUrl as NSString) {
            self.galleryImageView.image = cachedImage
            return
        }
        
        let url = URL(string: image.imageUrl)
        URLSession.shared.dataTask(with: url!) {data,response,error in
            if error != nil {
                print("Error Loading Photo")
                print(error!)
                return
            }
            DispatchQueue.main.async {
                let uiImage = UIImage(data: data!)
                GalleryImageTableViewCell.cache.setObject(uiImage!, forKey: image.imageUrl as NSString)
                self.galleryImageView.image = uiImage
                self.galleryImageView.contentMode = .scaleAspectFill
            }
        }.resume()
    }
}
