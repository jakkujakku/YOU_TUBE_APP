//
//  LoginController.swift
//  YOU_TUBE
//
//  Created by (^ㅗ^)7 iMac on 2023/09/04.
//

import UIKit

class LoginController: UIViewController {
    @IBOutlet weak var youtubeLogo: UIImageView!
    
    @IBOutlet weak var text1: UITextField!
    
    @IBOutlet weak var text2: UITextField!
    
    @IBOutlet weak var loginbutton: UIButton!
    
    @IBOutlet weak var loginbutton2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    @IBAction func loginbuttonTapped(_ sender: Any) {
        // text1.placeholder = "이메일을 적으시오"
        // 회원가입 페이지 뷰 컨트롤러를 생성
//        let registerViewController = RegisterViewController()
        
        // navigationController를 사용하여 회원가입 페이지로 이동
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(identifier: "TabBarViewController") as? TabBarViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func registerbuttonTapped(_ sender: Any) {}
}
