//
//  TabBarController.swift
//  Instagram
//
//  Created by 蓑輪 竜輝 on 2020/04/23.
//  Copyright © 2020 ryuki.minowa. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // タブアイコンの色
        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        // タブの背景色
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        
        // delegateメソッドの呼び出しをこのクラスに指定
        self.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // currentUserがnilならログインしていない
        if Auth.auth().currentUser == nil {
            // 未ログイン時の処理
            guard let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login") else {return}
            self.present(loginViewController, animated: true, completion: nil)
        }
    }
    
    
    /// タブバーが押された時に呼ばれるデリゲートメソッド(true: タブ切り替えを行う, false: タブ切り替えを行わない)
    /// - Parameter tabBarConroller: UITabBarController
    /// - Parameter viewController: UIViewController    /*UIViewControllerインスタンス*/
    func tabBarController(_ tabBarConroller: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is ImageSelectViewController {
            // ImageSelectViewControllerはタブ画面ではなくモーダル画面に移動する
            if let imageViewController = storyboard?.instantiateViewController(withIdentifier: "ImageSelect") {
                present(imageViewController, animated: true)    //モーダル画面に移動
            } //storyboardのimageViewControllerを読み込む
            return false
        } else {
            // その他のViewControllerはタブ切り替え
            return true
        }
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
