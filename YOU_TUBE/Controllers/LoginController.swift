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
        
        text1.placeholder = "이메일을 적으시오"
    }
    
    
    @IBAction func registerbuttonTapped(_ sender: Any) {
    }
    
}



