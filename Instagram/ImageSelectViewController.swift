//
//  ImageSelectViewController.swift
//  Instagram
//
//  Created by 蓑輪 竜輝 on 2020/04/23.
//  Copyright © 2020 ryuki.minowa. All rights reserved.
//

import UIKit
import CLImageEditor

class ImageSelectViewController: UIViewController {

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBAction
    
    @IBAction func handleLibraryButton(_ sender: Any) {
        // ライブラリを指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {   // .photoLibraryが利用可能か
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func handleCameraButton(_ sender: Any) {
        // カメラを指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(.camera) {     // .cameraが利用可能か
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func handleCancelButton(_ sender: Any) {
        // 画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerController

extension ImageSelectViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// 写真を撮影/選択した時に呼ばれる
    /// - Parameter picker: UIImagePickerController
    /// - Parameter info: [UIImagePickerController.InfoKey : Any]
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[.originalImage] != nil {
            //  撮影/選択された写真を取得する
            guard let image = info[.originalImage] as? UIImage else {return}
            
            // 後でCLImageEditorライブラリで加工する
            print("DEBUG_PRINT: image = \(image)")
            // CLImageEditerにImageを渡して、加工画面を起動する
            guard let editor = CLImageEditor(image: image) else {return}
            editor.delegate = self
            picker.present(editor, animated: true, completion: nil)
        }
    }
    
    /// キャンセルした時に呼ばれる
    /// - Parameter picker: UIImagePickerController
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // ImageSelectViewController画面を閉じてタブに戻る
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - CLImageEditer

extension ImageSelectViewController: CLImageEditorDelegate {
    
    /// CLImageEditorで編集が終わった時に呼び出す
    /// - Parameter editor: CLImageEditor!
    /// - Parameter image: UIImage!
    func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
        // 投稿画面を開く
        guard let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as? PostViewController else {return}
        postViewController.image = image
        editor.present(postViewController, animated: true, completion: nil)
    }
    
    /// CLImageEditorの編集画面がさキャンセルされた時に呼び出す
    /// - Parameter editor: CLImageEditor!
    func imageEditorDidCancel(_ editor: CLImageEditor!) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
