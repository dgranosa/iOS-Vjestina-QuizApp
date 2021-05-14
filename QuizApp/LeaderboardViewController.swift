//
//  LeaderboardViewController.swift
//  QuizApp
//
//  Created by five on 14.05.2021..
//

import UIKit

class LeaderboardViewController: UIViewController {
    
    private var router: AppRouter!
    private var quiz: Quiz!
    
    convenience init(router: AppRouter, quiz: Quiz) {
        self.init()
        self.router = router
        self.quiz = quiz
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        NetworkService().fetchLeaderboard(quiz: quiz, completionHandler: { (result: Result<[LeaderboardResult], RequestError>) -> Void in
            switch result {
            case .success(let leaderboardResults):
                print(leaderboardResults)
            case .failure(_):
                break
            }
        })
    }
    
    private var layGradiant: CAGradientLayer!
    private var bBack: UIButton!
    private var lTitle: UILabel!
    
    func setupView() {
        layGradiant = CAGradientLayer()
        layGradiant.frame = view.bounds
        layGradiant.colors = [CGColor(red: 0.21, green: 0.21, blue: 0.49, alpha: 1),
                                CGColor(red: 0.4, green: 0.29, blue: 0.61, alpha: 1)]
        layGradiant.startPoint = CGPoint(x: 0, y: 1)
        layGradiant.endPoint = CGPoint(x: 1, y: 0)
        view.layer.addSublayer(layGradiant)
        
        lTitle = UILabel()
        lTitle.text = "Leaderboard"
        lTitle.font = UIFont.preferredFont(forTextStyle: .title1)
        lTitle.textColor = .white
        lTitle.textAlignment = .center
        view.addSubview(lTitle)
        lTitle.autoPinEdgesToSuperviewEdges(with: .init(top: 45, left: 0, bottom: -1, right: 0), excludingEdge: .bottom)
        
        bBack = UIButton()
        bBack.setImage(#imageLiteral(resourceName: "CloseButton"), for: .normal)
        bBack.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        view.addSubview(bBack)
        bBack.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        bBack.autoPinEdge(.top, to: .top, of: lTitle)
        bBack.autoPinEdge(.bottom, to: .bottom, of: lTitle)
    }
    
    @objc func goBack(_ sender: UIButton!) {
        router.goBack()
    }
    

}
