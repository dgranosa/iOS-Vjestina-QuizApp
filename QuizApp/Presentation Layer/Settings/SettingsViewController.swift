//
//  SettingsViewController.swift
//  QuizApp
//
//  Created by five on 03.05.2021..
//

import UIKit
import PureLayout

class SettingsViewController: UIViewController {
    
    private var router: AppRouter!
    
    private var layGradiant: CAGradientLayer!
    private var lUserlabel: UILabel!
    private var lUsername: UILabel!
    private var bLogout: UIButton!
    
    convenience init(router: AppRouter) {
        self.init()
        self.router = router
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        layGradiant = CAGradientLayer()
        layGradiant.frame = view.bounds
        layGradiant.colors = [CGColor(red: 0.21, green: 0.21, blue: 0.49, alpha: 1),
                                CGColor(red: 0.4, green: 0.29, blue: 0.61, alpha: 1)]
        layGradiant.startPoint = CGPoint(x: 0, y: 1)
        layGradiant.endPoint = CGPoint(x: 1, y: 0)
        
        view.layer.addSublayer(layGradiant)
        
        lUserlabel = UILabel()
        lUserlabel.text = "USERNAME"
        lUserlabel.textAlignment = .left
        lUserlabel.font = UIFont.preferredFont(forTextStyle: .title3)
        lUserlabel.textColor = .white
        
        lUsername = UILabel()
        lUsername.text = "Dorian Granosa"
        lUsername.textAlignment = .left
        lUsername.font = UIFont.preferredFont(forTextStyle: .title1)
        lUsername.textColor = .white
        
        bLogout = UIButton()
        bLogout.setTitle("Log out", for: .normal)
        bLogout.setTitleColor(.purple, for: .normal)
        bLogout.backgroundColor = .white
        bLogout.layer.cornerRadius = 25
        bLogout.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        bLogout.addTarget(self, action: #selector(self.logout), for: .touchUpInside)
        
        view.addSubview(lUserlabel)
        lUserlabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 80)
        lUserlabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        
        view.addSubview(lUsername)
        lUsername.autoPinEdge(.top, to: .bottom, of: lUserlabel, withOffset: 5)
        lUsername.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        
        view.addSubview(bLogout)
        bLogout.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: -1, left: 20, bottom: 40, right: 20), excludingEdge: .top)
        bLogout.autoSetDimension(.height, toSize: 50)
    }
    
    @objc func logout(_ sender: UIButton!) {
        router.showLogin()
    }
}
