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

class RedditListCell: UITableViewCell {
    
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var entryDate: UILabel!
    @IBOutlet weak var titleInfo: UILabel!
    @IBOutlet weak var numberOfComments: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    func updateData(_ childData: ChildData?) {
        if let data = childData {
            let dateCreated = Date(timeIntervalSince1970: data.dateCreated)
            entryDate.text = dateCreated.getString()
            titleInfo.text = data.title
            authorName.text = data.author
            
            if data.numberOfComments > 0 {
                numberOfComments.text = "Comments: \(data.numberOfComments)"
            } else {
                numberOfComments.text = ""
            }
            // load image
            let placeholderImage = #imageLiteral(resourceName: "image_not_available")
            if let urlString = childData?.thumbnailUrl, let urlImage = URL(string: urlString) {
                thumbnail.kf.setImage(with: urlImage, completionHandler: { [weak self] kfResult in
                    switch kfResult {
                    case .success(let value):
                        if value.source.url == urlImage {
                            DispatchQueue.main.async {
                                self?.thumbnail.image = value.image
                            }
                        }
                    case .failure(_):
                        self?.thumbnail.image = placeholderImage
                    }
                })
            } else {
                thumbnail.image = placeholderImage
            }
            
            
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnail?.image = nil
    }
    
}


