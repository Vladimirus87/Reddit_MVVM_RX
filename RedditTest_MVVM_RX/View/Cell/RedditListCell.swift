//
//  RedditListCell.swift
//  TestWorkRaketa
//
//  Created by Vladimirus on 28.10.2020.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

protocol RedditListCellDelegate: class {
    func imageTapped(cell: UITableViewCell)
}
//TODO: - Implement RX instead delegate pattern
class RedditListCell: UITableViewCell {
    
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var entryDate: UILabel!
    @IBOutlet weak var titleInfo: UILabel!
    @IBOutlet weak var numberOfComments: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    weak var delegate: RedditListCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addGestures()
    }
    
    
    private func addGestures() {
        thumbnail.isUserInteractionEnabled = true
        let gr = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        thumbnail.addGestureRecognizer(gr)
    }
    
    @objc func imageTapped() {
        delegate?.imageTapped(cell: self)
    }
    
    func updateData(_ childData: ChildData?) {
        if let data = childData {
            let dateCreated = Date(timeIntervalSince1970: data.dateCreated)
            entryDate.text = dateCreated.getString()
            titleInfo.text = data.title
            authorName.text = data.author
            
            let placeholderImage = #imageLiteral(resourceName: "image_not_available")
            if let urlString = childData?.thumbnailUrl, let urlImage = URL(string: urlString) {
                thumbnail.kf.setImage(with: urlImage, placeholder: placeholderImage)
            } else {
                thumbnail.image = placeholderImage
            }
            
            if data.numberOfComments > 0 {
                numberOfComments.text = "Comments: \(data.numberOfComments)"
            } else {
                numberOfComments.text = ""
            }
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnail?.image = nil
    }
    
}


