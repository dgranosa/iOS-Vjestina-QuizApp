//
//  LoginViewController.swift
//  QuizApp
//
//  Created by five on 10.04.2021..
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    let networkService = NetworkService()
    private var router: AppRouter!
    private var gradiantLayer: CAGradientLayer!
    
    convenience init(router: AppRouter) {
        self.init()
        
        self.router = router
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradiantLayer = CAGradientLayer()
        gradiantLayer.frame = view.bounds
        gradiantLayer.colors = [CGColor(red: 0.21, green: 0.21, blue: 0.49, alpha: 1),
                                CGColor(red: 0.4, green: 0.29, blue: 0.61, alpha: 1)]
        gradiantLayer.startPoint = CGPoint(x: 0, y: 1)
        gradiantLayer.endPoint = CGPoint(x: 1, y: 0)
        view.layer.insertSublayer(gradiantLayer, at: 0)
        
        usernameTextField.setPlaceholderText("Email")
        passwordTextField.setPlaceholderText("Password")
        
        popInAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradiantLayer.frame = view.bounds
    }

    @IBAction func LoginButton(_ sender: Any) {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        networkService.login(email: username, password: password, completionHandler: { [self] (result: Result<LoginStatus, RequestError>) in
            switch result {
            case .failure(let error):
                var errorMessage: String
                
                switch error {
                case .noConnectionError:
                    noConnectionAlert()
                    errorMessage = "No internet connection"
                case .serverError:
                    errorMessage = "Wrong username or password"
                case .clientError, .decodingError, .noDataError:
                    errorMessage = "Fetching error"
                }
                
                DispatchQueue.main.async {
                    statusLabel.text = errorMessage
                    statusLabel.alpha = 0
                    statusLabel.isHidden = false
                    UIView.animate(withDuration: 0.3, animations: {
                        self.statusLabel.alpha = 1
                    })
                }
            case .success(let loginStatus):
                let userDefaults = UserDefaults.init()
                userDefaults.set(loginStatus.token, forKey: "token")
                userDefaults.set(loginStatus.userId, forKey: "userId")
                
                DispatchQueue.main.async {
                    popOutAnimation(onCompletion: {_ in
                        router.showTab()
                    })
                }
            }
        })
    }
    
    @IBAction func HideStatus(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.statusLabel.alpha = 0
        }) { (finished) in
            self.statusLabel.isHidden = true
        }
        
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor(white: 1, alpha: 0.3)
        } else {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor(white: 1, alpha: 1)
        }
    }
    
    func popInAnimation() {
        titleLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
        titleLabel.alpha = 0
        
        usernameTextField.transform = CGAffineTransform(translationX: -usernameTextField.frame.maxX, y: 0)
        usernameTextField.alpha = 0
        
        passwordTextField.transform = CGAffineTransform(translationX: -passwordTextField.frame.maxX, y: 0)
        passwordTextField.alpha = 0
        
        loginButton.transform = CGAffineTransform(translationX: -loginButton.frame.maxX, y: 0)
        loginButton.alpha = 0
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: { [self] in
            titleLabel.transform = .identity
            titleLabel.alpha = 1
            
            usernameTextField.transform = .identity
            usernameTextField.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0.25, options: .curveEaseInOut, animations: { [self] in
            passwordTextField.transform = .identity
            passwordTextField.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0.5, options: .curveEaseInOut, animations: { [self] in
            loginButton.transform = .identity
            loginButton.alpha = 1
        }, completion: nil)
    }
    
    func popOutAnimation(onCompletion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: { [self] in
            titleLabel.transform = CGAffineTransform(translationX: 0, y: -titleLabel.frame.maxY)
            titleLabel.alpha = 0
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0.25, options: .curveEaseInOut, animations: { [self] in
            usernameTextField.transform = CGAffineTransform(translationX: 0, y: -view.convert(usernameTextField.frame, from: usernameTextField.superview).maxY)
            usernameTextField.alpha = 0
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0.5, options: .curveEaseInOut, animations: { [self] in
            passwordTextField.transform = CGAffineTransform(translationX: 0, y: -view.convert(passwordTextField.frame, from: passwordTextField.superview).maxY)
            passwordTextField.alpha = 0
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0.75, options: .curveEaseInOut, animations: { [self] in
            loginButton.transform = CGAffineTransform(translationX: 0, y: -view.convert(loginButton.frame, from: loginButton.superview).maxY)
            loginButton.alpha = 0
        }, completion: onCompletion)
        
    }
}
