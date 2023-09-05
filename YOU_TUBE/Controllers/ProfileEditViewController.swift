//
//  ProfileEditViewController.swift
//  YOU_TUBE
//
//  Created by t2023-m0053 on 2023/09/05.
//

import UIKit

class ProfileEditViewController: UIViewController {
    let picker = UIImagePickerController()

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet var OpenPhotosButton: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
    }

    @IBAction func EditButton(_ sender: Any) {
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
}

extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 이미지 선택 및 촬영 완료 후 호출되는 메서드 구현
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            ImageView?.image = image
        }

        dismiss(animated: true, completion: nil)
    }
}
