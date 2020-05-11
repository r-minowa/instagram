//
//  PostTableTableViewCell.swift
//  Instagram
//
//  Created by 蓑輪 竜輝 on 2020/04/30.
//  Copyright © 2020 ryuki.minowa. All rights reserved.
//

import UIKit
import FirebaseUI

class PostTableTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    // MARK: - PrivateMethod
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// PostDataの内容をセルに表示する
    /// - Parameter postData: PostData
    func setPostData(_ postData: PostData) {
        // 画像の表示
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray  // 画像ダウンロード中のインジケーターの指定
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        postImageView.sd_setImage(with: imageRef)   //2度目の画像表示はキャッシュを利用するため素早く表示してくれる

        // captionの表示
        if let caption_name = postData.name, let caption_caption = postData.caption {
            self.captionLabel.text = "\(caption_name) : \(caption_caption)"
        }
        
        // commentの表示
        self.commentLabel.text = ""
        let comment_comment: [String] = postData.comment
        var comment = ""
        for count in 0 ..< comment_comment.count {
            comment += "\(comment_comment[count]) \n"
        }
        self.commentLabel.text = comment
        
        // 日時の表示
        self.dateLabel.text = ""
        if let date = postData.date {   // Dateクラスにある日時をDateFormatterで文字列に変換する必要がある
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
        }
        
        // いいね数の表示
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        // いいねボタンの表示
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
    }
}
