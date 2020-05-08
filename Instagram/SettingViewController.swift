//
//  SettingViewController.swift
//  Instagram
//
//  Created by 蓑輪 竜輝 on 2020/04/23.
//  Copyright © 2020 ryuki.minowa. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SettingViewController: UIViewController {
    /// 表示名(テキストフィールド)
    @IBOutlet weak var displayNameTextField: UITextField!
    
    /// 表示名を変更
    /// - Parameter sender: Any
    @IBAction func handleChangeButton(_ sender: Any) {
        if let displayName = displayNameTextField.text {
            
            // displayNameに何も文字が入力されていない場合
            if displayName.isEmpty {
                SVProgressHUD.showError(withStatus: "表示名を入力してください。")
                return
            }
            
            // 表示名を設定する
            let user = Auth.auth().currentUser
            if let user = user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.commitChanges{ error in
                    if let error = error {
                        SVProgressHUD.showError(withStatus: "表示名の変更に失敗しました。")
                        print("DEBUG_PRINT: " + error.localizedDescription)
                        return
                    }
                    if let displayname = user.displayName {
                        print("DEBUG_PRINT: [displayName = \(displayname)]の設定に成功しました。")
                    }
                    
                    //HUDで完了を知らせる
                    SVProgressHUD.showSuccess(withStatus: "表示名を変更しました。")
                }
            }
            // キーボードを閉じる
            self.view.endEditing(true)
        }
    }
    
    /// ログアウト
    /// - Parameter sender: Any
    @IBAction func handleLogoutButton(_ sender: Any) {
        //ログアウトする(書き換え済)
//        do{
            try? Auth.auth().signOut()
//             print("DEBUG_PRINT: ログアウトできました。")
//        } catch {
//            print("DEBUG_PRINT: ログアウトできませんでした。")
//            return
//        }
        
        //ログイン画面を表示する
        guard let roginVireController = self.storyboard?.instantiateViewController(withIdentifier: "Login") else {return}
        self.present(roginVireController, animated: true, completion: nil)
        
        // ログイン画面から戻っときた時にホーム画面にしておく
        tabBarController?.selectedIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 表示名を取得してTextFieldに設定する
        let user = Auth.auth().currentUser
        if let user = user {
            displayNameTextField.text = user.displayName
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
