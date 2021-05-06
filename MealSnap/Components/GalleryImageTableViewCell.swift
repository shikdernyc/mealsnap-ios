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
    private var imageModel : GalleryImage? = nil
    @IBOutlet weak var galleryImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateLikeView(eagerlyLike: Bool = false) {
        let imageName = self.imageModel?.alreadyLiked == true || eagerlyLike == true ? "heart-filled" : "heart-unfilled"
        let image = UIImage(named: imageName)
        let newlikeCounter = eagerlyLike ? self.imageModel!.likeCount + 1 : self.imageModel!.likeCount
        DispatchQueue.main.async {
            self.likeButton.setImage(image, for: .normal)
            self.likeCountLabel.text = String(newlikeCounter)
        }
        
    }
    
    @IBAction func onTapLike(_ sender: Any) {
        self.updateLikeView(eagerlyLike: true)
        self.imageModel?.like() {result in
            switch (result){
            case .failure(let error):
                print(error)
                self.updateLikeView()
                return
            case .success(_):
                print("Image liked")
                return
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
        return UINib(nibName: ID, bundle: nil)
    }
    
    private func setGalleryImage(to image: UIImage) {
        self.galleryImageView.image = image
        self.galleryImageView.contentMode = .scaleAspectFill
    }
    
    public func configure(with image: GalleryImage) {
        self.imageModel = image
        titleLabel.text = image.title
        likeCountLabel.text = String(image.likeCount)
        self.updateLikeView()
        if let cachedImage = GalleryImageTableViewCell.cache.object(forKey: image.imageUrl as NSString) {
            self.setGalleryImage(to: cachedImage)
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
                self.setGalleryImage(to: uiImage!)
            }
        }.resume()
    }
}
