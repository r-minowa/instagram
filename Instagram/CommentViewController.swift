//
//  CommentViewController.swift
//  Instagram
//
//  Created by 蓑輪 竜輝 on 2020/05/01.
//  Copyright © 2020 ryuki.minowa. All rights reserved.
//

import UIKit
import Firebase

class CommentViewController: UIViewController { //継承するのは使いたいところを継承する(HomeViewControllerではTableViewを使っていないため継承できない)
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendingButton: UIButton!
    
    var postData: PostData?
    
    // MARK: - IBAction
    
    @IBAction func handleSendingButton(_ sender: Any) {
        
        //コメントを更新する
        // 更新データを作成する
        guard let postData = self.postData else {return}
        if let commentName = Auth.auth().currentUser?.displayName, let commentData = commentTextField.text {
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)    //場所の指定
            
            let comment = "\(commentName) : \(commentData)"
            var updateValue_commentData: FieldValue
            updateValue_commentData = FieldValue.arrayUnion([comment])
            // データの追加更新
            postRef.updateData([
                "comment": updateValue_commentData
            ])
        }

        print("DEBUG_PRINT: 送信されました")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commentTextField.text = ""
//        self.sendingButton.layer.cornerRadius = 50.0
    }
}
