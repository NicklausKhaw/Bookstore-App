//
//  BookTableViewCell.swift
//  Bookstore App
//
//  Created by Nicklaus Khaw on 11/10/2021.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet weak var bookView: UIView!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
