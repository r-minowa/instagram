//
//  PostViewController.swift
//  Instagram
//
//  Created by 蓑輪 竜輝 on 2020/04/23.
//  Copyright © 2020 ryuki.minowa. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    var image: UIImage!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 受け取った画像imageViewに表示する
        imageView.image = image
    }
    
    // MARK: - IBAction
    
    /// 投稿ボタンが押された時に呼ばれる
    /// - Parameter sender: Any
    @IBAction func handlePostButton(_ sender: Any) {
        // 画像をJPEG形式に変換する
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        // 画像と投稿データの保存場所を定義する
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
        // HUDで投稿処理中の表示を開始
        SVProgressHUD.show()
        // Storageに画像をアップロードする
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        imageRef.putData(imageData, metadata: metadata) {(metadata, error) in
            if error != nil {
                // 画像のアップロード失敗
                if let error = error {
                    print(error)
                }
                SVProgressHUD.showError(withStatus: "画像のアップロードに失敗しました")
                // 投稿処理をキャンセルし、先頭画面に戻る
                UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                return
            }
            // Firestoreに投稿データを保存する
            guard let name = Auth.auth().currentUser?.displayName, let caption = self.textField.text else {return}
            let postDic = [
                "name": name,
                "caption": caption,
                "date": FieldValue.serverTimestamp()
                ] as [String: Any]
            postRef.setData(postDic)
            // HUDで投稿完了を表示する
            SVProgressHUD.showSuccess(withStatus: "投稿しました")
            // 投稿処処理が完了したので先頭画面に戻る
            UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    /// キャンセルボタンが押された時に呼ばれる
    /// - Parameter sender: Any
    @IBAction func handleCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
