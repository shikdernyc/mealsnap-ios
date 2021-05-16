//
//  SearchUserTableViewCell.swift
//  MealSnap
//
//  Created by Asif Shikder on 5/4/21.
//

import UIKit

class SearchUserTableViewCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var displayNameLabel: UILabel!
    
    static let ID = "SearchUserTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(with user: UserSummary) {
        self.usernameLabel.text = user.userName
        contentView.alpha = 0
        if((user.firstName != nil) && (user.lastName != nil)) {
            self.displayNameLabel.text = "\(user.firstName!) \(user.lastName!)"
        }else {
            self.displayNameLabel.text = user.userName
        }
        UIView.animate(withDuration: 1) {
            self.contentView.alpha = 1
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: ID, bundle: nil)
    }
}
