//
//  GalleryImageTableViewCell.swift
//  MealSnap
//
//  Created by Asif Shikder on 4/28/21.
//

import UIKit

class GalleryImageTableViewCell: UITableViewCell {
    static let ID = "GalleryImageTableViewCell"
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
    
    public func configure(with image: GalleryImage) {
        self.imageModel = image
        titleLabel.text = image.title
        likeCountLabel.text = String(image.likeCount)
        self.updateLikeView()
        self.galleryImageView.setImage(url: image.imageUrl)
        self.galleryImageView.contentMode = .scaleAspectFill
    }
}
