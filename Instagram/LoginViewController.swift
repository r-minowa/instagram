//
//  LoginViewController.swift
//  Instagram
//
//  Created by 蓑輪 竜輝 on 2020/04/23.
//  Copyright © 2020 ryuki.minowa. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    
    /// ログインボタンタップ時に呼び出される
    /// - Parameter sender: Any
    @IBAction func handleLoginButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text {
            // アドレスかパスワードが入力されていない場合
            if address.isEmpty || password.isEmpty {
                SVProgressHUD.showError(withStatus: "必須項目を入力してください。")
                return
            }
            
            Auth.auth().signIn(withEmail: address, password: password) { authResult, error in
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "サインインに失敗しました。")
                    return
                }
                print("DEBUG_PRINT: ログインに成功しました。")
                
                // 画面を閉じる
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    /// アカウント作成ボタンタップ時に呼び出される
    /// - Parameter sender: Any
    @IBAction func handleCreateAccountButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text {
            // いずれかが何も入力されていない場合
            if address.isEmpty || password.isEmpty || displayName.isEmpty {
                print("DEBUG_PRINT: 何かが空文字です。")
                SVProgressHUD.showError(withStatus: "必須項目を入力してください。")
                return  //このメソッドを抜ける
            }
            
            // アドレスとパスワードでユーザ作成、作成成功後自動ログイン
            Auth.auth().createUser(withEmail: address, password: password) {authReslt, error in
                if let error = error {
                    // エラー発生時、エラー事項をプリントしてメソッドを抜ける
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "ユーザー作成に失敗しました。")
                    return
                }
                print("DEBUG_PRINT: ユーザ作成に成功しました。")
                
                // 表示名の設定
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges{ error in
                        if let error = error {
                            // プロフィール更新でエラー発生
                            print("DEBUG_PRINT: " + error.localizedDescription)
                            SVProgressHUD.showError(withStatus: "表示名の作成に失敗しました。")
                            return
                        }
                        
                        if let displayName = user.displayName {
                            print("DEBUG_PRINT: [displayName = \(displayName)]の設定に成功しました。")
                        }
                        
                        // 画面を閉じる
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
