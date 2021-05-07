//
//  LoginViewController.swift
//  QuizApp
//
//  Created by five on 10.04.2021..
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var _username: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var _login_button: UIButton!
    @IBOutlet weak var _status: UILabel!
    
    let dataService = DataService()
    private var router: AppRouter!
    
    convenience init(router: AppRouter) {
        self.init()
        
        self.router = router
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func LoginButton(_ sender: Any) {
        let username = _username.text!
        let password = _password.text!
        
        let loginResponse = dataService.login(email: username, password: password)
        
        switch loginResponse {
        case .success:
            router.showTab()
        case .error(let code, let desc):
            _status.text = "Error \(code): \(desc)"
            _status.textColor = .red
            print("Error \(code): \(desc)")
            
            _status.alpha = 0
            _status.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self._status.alpha = 1
            }
        }
    }
    
    @IBAction func HideStatus(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self._status.alpha = 0
        }) { (finished) in
            self._status.isHidden = true
        }
    }
}
