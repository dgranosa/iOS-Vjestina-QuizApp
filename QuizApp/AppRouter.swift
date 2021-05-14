//
//  AppRouter.swift
//  QuizApp
//
//  Created by five on 03.05.2021..
//

import Foundation
import UIKit

protocol AppRouterProtocol {
    func setStartScreen(in window: UIWindow?)
}

class AppRouter : AppRouterProtocol {
    private let navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.isHidden = true
    }
    
    func setStartScreen(in window: UIWindow?) {
        showLogin(animated: false)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func showLogin(animated: Bool = true) {
        let vc = LoginViewController(router: self)
        
        navigationController.setViewControllers([vc], animated: animated)
    }
    
    func showQuizzes(animated: Bool = true) {
        let vc = QuizzesViewController(router: self)
        
        navigationController.setViewControllers([vc], animated: animated)
    }
    
    func showTab(animated: Bool = true) {
        let vQuizzes = QuizzesViewController(router: self)
        vQuizzes.tabBarItem = UITabBarItem(title: "Quizzes", image: #imageLiteral(resourceName: "QuizzesU"), selectedImage: #imageLiteral(resourceName: "QuizzesS"))
        let vSettings = SettingsViewController(router: self)
        vSettings.tabBarItem = UITabBarItem(title: "Settings", image: #imageLiteral(resourceName: "SettingsU"), selectedImage: #imageLiteral(resourceName: "SettingsS"))
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [vQuizzes, vSettings]
        tabBarController.tabBar.tintColor = .purple
        tabBarController.tabBar.backgroundColor = .white
        
        navigationController.setViewControllers([tabBarController], animated: animated)
    }
    
    func showQuiz(quiz: Quiz!, animated: Bool = true) {
        let vc = QuizViewController(router: self, quiz: quiz)
        
        navigationController.pushViewController(vc, animated: animated)
    }
    
    func showQuizResult(result: String!, animated: Bool = true) {
        let vc = QuizResultViewController(router: self, result: result)
        
        navigationController.pushViewController(vc, animated: animated)
    }
    
    func goBack(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }
    
    func goBackToQuizzes(animated: Bool = true) {
        guard let vc = navigationController.viewControllers.last(where: { $0 is UITabBarController }) else {
            showTab()
            return
        }
        navigationController.popToViewController(vc, animated: animated)
    }
}
