//
//  ProfileEditViewController.swift
//  YOU_TUBE
//
//  Created by t2023-m0053 on 2023/09/05.
//

import UIKit

class ProfileEditViewController: UIViewController {
    let picker = UIImagePickerController()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var openPhotosButton: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
    }
    
    @IBAction func editButton(_ sender: Any) {
        let alert = UIAlertController(title: "프로필 수정", message: "프로필을 수정하시겠습니까?", preferredStyle: .actionSheet)
        
        let library = UIAlertAction(title: "사진앨범", style: .default) { _ in self.openLibrary()
        }
        
        let camera = UIAlertAction(title: "카메라", style: .default) { _ in
            
            self.openCamera()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        
        alert.addAction(camera)
        
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func openLibrary() {
        picker.sourceType = .photoLibrary
        
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            
            present(picker, animated: false, completion: nil)
        }
        
        else {
            print("Camera not available")
        }
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        // 데이터 전달
        UserDefaults.standard.set(imageView.image?.pngData(), forKey: "Image")
        UserDefaults.standard.set(nameTextField.text, forKey: "Name")
        UserDefaults.standard.set(emailTextField.text, forKey: "Email")
            
        // NotificationCenter를 사용하여 데이터 전달
        NotificationCenter.default.post(name: NSNotification.Name("ProfileDataUpdated"), object: nil)
            
        navigationController?.popViewController(animated: true)
    }
}

extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 이미지 선택 및 촬영 완료 후 호출되는 메서드 구현
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView?.image = image
        }

        dismiss(animated: true, completion: nil)
    }
}
