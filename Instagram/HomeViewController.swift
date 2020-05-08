//
//  HomeViewController.swift
//  Instagram
//
//  Created by 蓑輪 竜輝 on 2020/04/23.
//  Copyright © 2020 ryuki.minowa. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // コメント用postData
    var commentPostData: PostData?
    // 投稿データを格納する配列
    var postArray: [PostData] = []
    // Firestoreのリスナー(Firestoreのdeta更新の監視)
    var listener: ListenerRegistration!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // カスタムセルを登録する(セル名：Cell)
        let nib = UINib(nibName: "PostTableTableViewCell", bundle: nil) //xibファイルを読み込む
        tableView.register(nib, forCellReuseIdentifier: "Cell") //nibを登録する
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
        if Auth.auth().currentUser != nil {
            // ログイン済
            if listener == nil {
                // listenerに未登録なら登録してスナップショットを受信する
                let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
                listener = postsRef.addSnapshotListener(){ (querySnapshot, error) in    // ドキュメントが投稿・更新されるたびにこのクロージャが呼ばれる
                    if let error = error {
                        print("DEBUG_PRINT: snapshotの取得が失敗しました。\(error)")
                        return
                    }
                    // 取得したdocumentデータを元にPostDataを作成、postArrayの配列にする
                    self.postArray = querySnapshot!.documents.map{ document in
                        print("DEBUG_PRINT: document取得 \(document.documentID)")
                        let postData = PostData(document: document)
                        return postData
                    }
                    
                    self.tableView.reloadData()
                }
            }
        } else {
            // 未ログイン
            if listener != nil {
                // listener登録済なら消去
                listener.remove()
                listener = nil
                postArray = []
                tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let commentViewController:CommentViewController = segue.destination as! CommentViewController

        if segue.identifier == "commentSegue" {
            commentViewController.postData = self.commentPostData
        }
    }
    
    // MARK: - Private Method
    
    /// セル内のボタンがタップされた時に呼ばれるメソッド
    /// - Parameter sender: UIButton
    /// - Parameter event: UIEvent
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました。")
        
        // タップされたセルのインデックスを求める
        guard let touch = event.allTouches?.first else {return}
        let point = touch.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        // 配列からタップされたインデックスのデータを取り出す
        guard let indexPath_ = indexPath else {return}
        let postData = postArray[indexPath_.row]
        
        // likesを更新する
        if let myid = Auth.auth().currentUser?.uid {
            // 更新データを作成する
            var updateValue: FieldValue
            if postData.isLiked {
                // すでにいいねをしている場合は、いいね解除のためにmyidを取り除く更新データを作成
                updateValue = FieldValue.arrayRemove([myid])
            } else {
                // 今回新たにいいねを押した場合は、myidを追加する更新データを作成
                updateValue = FieldValue.arrayUnion([myid])
            }
            // likesに更新データを取り込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes": updateValue])
        }
    }
    
    /// コメントボタンがタップされた時に呼ばれるメソッド
    /// - Parameter sender: UIButton
    /// - Parameter event: UIEvent
    @objc func handleCommentButton(_ sender: UIButton, forEvent event:UIEvent) {
        print("DEBUG_PRINT: コメントボタンがタップされました。")
        
        // タップされたセルのインデックスを求める
        guard let touch = event.allTouches?.first else {return}
        let point = touch.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)

        // 配列からタップされたインデックスのデータを取り出す
        guard let indexPath_ = indexPath else {return}
        commentPostData = postArray[indexPath_.row]
        
        // コメント入力画面に遷移する
        performSegue(withIdentifier: "commentSegue", sender: nil)
    }
}

// MARK: - TableView

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableTableViewCell
        cell.setPostData(postArray[indexPath.row])
        
        cell.likeButton.addTarget(self, action: #selector(handleButton(_:forEvent:)), for: .touchUpInside)
        cell.commentButton.addTarget(self, action: #selector(handleCommentButton(_:forEvent:)), for: .touchUpInside)
        
        return cell
    }
}
