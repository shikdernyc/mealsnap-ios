//
//  CreatePostTableViewCells.swift
//  MealSnap
//
//  Created by Asif Shikder on 5/15/21.
//

import UIKit

class CreatePostTitleTextInputCell : UITableViewCell {
    @IBOutlet weak var titleInput: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleInput.addBorder()
    }
    
    func inputValue() -> String {
        guard let value = titleInput.text else {
            return ""
        }
        return value
    }
}

class CreatePostDescriptionTextViewCell : UITableViewCell {
    @IBOutlet weak var descriptionTextField: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionTextField.addBorder()
    }
    
    func inputValue() -> String {
        guard let value = descriptionTextField.text else {
            return ""
        }
        return value
    }
}

class CreatePostImageViewCell : UITableViewCell {
    @IBOutlet weak var imagePreview: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func image() -> UIImage? {
        return imagePreview.image
    }
    
    func setImage(to image: UIImage) -> Void {
        self.imagePreview.image = image
        self.imagePreview.contentMode = .scaleToFill
        self.imagePreview.layer.cornerRadius = 7
    }
}
