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
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordEyeButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var openPhotosButton: UIView!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var editPhotoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        // ImageView를 원형으로 만들기
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        updateButtonColorsForCurrentInterfaceStyle()
        // 이미지와 텍스트의 정렬 설정
    }
    
    // 다크모드 버튼 텍스트 즉각 대응
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateButtonColorsForCurrentInterfaceStyle()
        }
    }
    
    private func updateButtonColorsForCurrentInterfaceStyle() {
        if traitCollection.userInterfaceStyle == .dark {
            editPhotoButton.setTitleColor(UIColor.white, for: [])
            saveButton.setTitleColor(UIColor.white, for: [])
        } else {
            editPhotoButton.setTitleColor(UIColor.black, for: [])
            saveButton.setTitleColor(UIColor.black, for: [])
        }
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
            print("카메라를 사용할 수 없습니다.")
        }
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        // 데이터 전달
        UserDefaults.standard.set(imageView.image?.pngData(), forKey: "Image")
        UserDefaults.standard.set(nameTextField.text, forKey: "Name")
        UserDefaults.standard.set(emailTextField.text, forKey: "Email")
        UserDefaults.standard.set(passwordTextField.text, forKey: "Password")
        // NotificationCenter를 사용하여 데이터 전달
        NotificationCenter.default.post(name: NSNotification.Name("ProfileDataUpdated"), object: nil)

        navigationController?.popViewController(animated: true)
    }

    // 패스워드 보이기 버튼
    @IBAction func eyeButton(_ sender: UIButton) {
        // 보안 설정 반전
        passwordTextField.isSecureTextEntry.toggle()
        // 버튼 선택 상태 반전
        passwordEyeButton.isSelected.toggle()
        // 버튼 선택 상태에 따른 눈모양 이미지 변경
        if traitCollection.userInterfaceStyle == .dark {
            // 다크 모드일 때 이미지 변경
            let eyeImage = passwordEyeButton.isSelected ? "password shown eye icon dark" : "password hidden eye icon dark"
            passwordEyeButton.setImage(UIImage(named: eyeImage), for: .normal)
              
            // 버튼 선택된 경우 자동으로 들어가는 틴트 컬러를 투명으로 변경해줌
            passwordEyeButton.tintColor = .clear
        } else {
            // 라이트 모드일 때 이미지 변경
            let eyeImage = passwordEyeButton.isSelected ? "password shown eye icon" : "password hidden eye icon"
            passwordEyeButton.setImage(UIImage(named: eyeImage), for: .normal)
        }
    }
}

extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            // 이미지 회전 조정
            let orientedImage = fixOrientation(of: image)
            imageView.image = orientedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // 이미지 회전 조정 메서드
    private func fixOrientation(of image: UIImage) -> UIImage {
        if image.imageOrientation == .up {
            return image
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        image.draw(in: rect)
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
}
