//
//  RegisterViewController.swift
//  YOU_TUBE
//
//  Created by clone1 on 2023/09/06.
//

import UIKit

class RegisterController: UIViewController {
    @IBOutlet weak var signUp: UILabel!
    
    @IBOutlet weak var text1: UITextField!
    
    @IBOutlet weak var text2: UITextField!
    
    @IBOutlet weak var text3: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        guard let nextVC = storyboard?.instantiateViewController(identifier: "RegisterController") as? RegisterController else { return }
        nextVC.modalPresentationStyle = .fullScreen
    }
}
