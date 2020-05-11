//
//  PostData.swift
//  Instagram
//
//  Created by 蓑輪 竜輝 on 2020/04/30.
//  Copyright © 2020 ryuki.minowa. All rights reserved.
//

import UIKit
import Firebase

class PostData: NSObject {
    var id: String
    var name: String?
    var caption: String?
    var comment: [String] = []
    var commentName: [String] = []
//    var comment: String?
//    var commentName: String?
    var date: Date?
    var likes: [String] = []
    var isLiked: Bool = false
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        let PostDic = document.data()
        self.name = PostDic["name"] as? String
        self.caption = PostDic["caption"] as? String
        if let comment = PostDic["comment"] as? [String] {
            self.comment = comment
        }
        if let commentName = PostDic["commentName"] as? [String] {
            self.commentName = commentName
        }
//        self.comment = PostDic["comment"] as? String
//        self.commentName = PostDic["commentName"] as? String
        let timestamp = PostDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        if let likes = PostDic["likes"] as? [String] {
            self.likes = likes
        }
        if let myid = Auth.auth().currentUser?.uid {
            // likes内に自分のIDが入っているか
            if self.likes.firstIndex(of: myid) != nil { // nilでなければいいねを押していると判定
                self.isLiked = true
            }
        }
    }
    
}
