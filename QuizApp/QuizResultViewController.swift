//
//  QuizResultViewController.swift
//  QuizApp
//
//  Created by five on 05.05.2021..
//

import UIKit

class QuizResultViewController: UIViewController {

    private var router: AppRouter!
    private var result: String!
    
    private var layGradiant: CAGradientLayer!
    private var lResult: UILabel!
    private var bFinish: UIButton!
    
    convenience init(router: AppRouter, result: String) {
        self.init()
        self.router = router
        self.result = result
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
        
        bFinish = {
            let b = UIButton()
            b.setTitle("Finish Quiz", for: .normal)
            b.setTitleColor(.purple, for: .normal)
            b.backgroundColor = .white
            b.layer.cornerRadius = 25
            b.addTarget(self, action: #selector(self.finishQuiz), for: .touchUpInside)
            return b
        }()
        bFinish.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(bFinish)
        bFinish.autoSetDimension(.height, toSize: 50)
        bFinish.autoPinEdgesToSuperviewEdges(with: .init(top: -1, left: 40, bottom: 50, right: 40), excludingEdge: .top)
        
        lResult = UILabel()
        lResult.text = result
        lResult.font = UIFont.boldSystemFont(ofSize: 88)
        lResult.textColor = .white
        lResult.textAlignment = .center
        view.addSubview(lResult)
        lResult.autoPinEdgesToSuperviewEdges(with: .init(top: 0, left: 0, bottom: -1, right: 0), excludingEdge: .bottom)
        lResult.autoPinEdge(.bottom, to: .top, of: bFinish)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layGradiant.frame = view.bounds
    }
    
    @objc func finishQuiz() {
        router.goBackToQuizzes()
    }
}
