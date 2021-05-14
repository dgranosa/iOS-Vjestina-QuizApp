//
//  QuizViewController.swift
//  QuizApp
//
//  Created by five on 14.05.2021..
//

import UIKit

class QuizViewController: UIViewController {
    
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
    }
    
    private var layGradiant: CAGradientLayer!
    private var bBack: UIButton!
    private var lTitle: UILabel!
    private var bLeaderboard: UIButton!
    private var vQuiz: UIView!
    private var lQTitle: UILabel!
    private var lQDesc: UILabel!
    private var iQImage: UIImageView!
    private var bQStart: UIButton!
    
    func setupView() {
        layGradiant = CAGradientLayer()
        layGradiant.frame = view.bounds
        layGradiant.colors = [CGColor(red: 0.21, green: 0.21, blue: 0.49, alpha: 1),
                                CGColor(red: 0.4, green: 0.29, blue: 0.61, alpha: 1)]
        layGradiant.startPoint = CGPoint(x: 0, y: 1)
        layGradiant.endPoint = CGPoint(x: 1, y: 0)
        view.layer.addSublayer(layGradiant)
        
        bBack = UIButton()
        bBack.setImage(#imageLiteral(resourceName: "BackButton"), for: .normal)
        bBack.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        view.addSubview(bBack)
        bBack.autoPinEdge(toSuperviewEdge: .top, withInset: 45)
        bBack.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        
        lTitle = UILabel()
        lTitle.text = "QuizApp"
        lTitle.font = UIFont.preferredFont(forTextStyle: .title1)
        lTitle.textColor = .white
        lTitle.textAlignment = .center
        view.addSubview(lTitle)
        lTitle.autoPinEdgesToSuperviewEdges(with: .init(top: 45, left: 0, bottom: -1, right: 0), excludingEdge: .bottom)
        
        vQuiz = UIView()
        vQuiz.backgroundColor = .init(white: 1, alpha: 0.3)
        vQuiz.layer.cornerRadius = 10
        
        lQTitle = UILabel()
        lQTitle.text = quiz.title
        lQTitle.textColor = .white
        lQTitle.textAlignment = .center
        lQTitle.font = UIFont.boldSystemFont(ofSize: 32)
        vQuiz.addSubview(lQTitle)
        
        lQDesc = UILabel()
        lQDesc.text = quiz.description
        lQDesc.textColor = .white
        lQDesc.textAlignment = .center
        lQDesc.numberOfLines = 2
        lQDesc.font = UIFont.boldSystemFont(ofSize: 18)
        vQuiz.addSubview(lQDesc)
        
        iQImage = UIImageView(image: UIImage(systemName: "questionmark"))
        iQImage.contentMode = .scaleAspectFill
        iQImage.clipsToBounds = true
        iQImage.layer.cornerRadius = 10
        vQuiz.addSubview(iQImage)
        
        bQStart = UIButton()
        bQStart.setTitle("Start Quiz", for: .normal)
        bQStart.setTitleColor(.purple, for: .normal)
        bQStart.backgroundColor = .white
        bQStart.layer.cornerRadius = 25
        bQStart.addTarget(self, action: #selector(self.startQuiz), for: .touchUpInside)
        bQStart.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        vQuiz.addSubview(bQStart)
        
        lQTitle.autoPinEdgesToSuperviewEdges(with: .init(top: 20, left: 20, bottom: -1, right: 20), excludingEdge: .bottom)
        lQDesc.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        lQDesc.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        lQDesc.autoPinEdge(.top, to: .bottom, of: lQTitle, withOffset: 20)
        iQImage.autoSetDimension(.height, toSize: 200)
        iQImage.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        iQImage.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        iQImage.autoPinEdge(.top, to: .bottom, of: lQDesc, withOffset: 20)
        bQStart.autoSetDimension(.height, toSize: 50)
        bQStart.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        bQStart.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        bQStart.autoPinEdge(.top, to: .bottom, of: iQImage, withOffset: 25)
        
        view.addSubview(vQuiz)
        vQuiz.autoSetDimension(.height, toSize: 420)
        vQuiz.autoPinEdgesToSuperviewEdges(with: .init(top: 200, left: 20, bottom: -1, right: 20), excludingEdge: .bottom)
        
        DispatchQueue.global().async { [self] in // TODO: store image data
            let data = NSData(contentsOf: URL(string: quiz.imageUrl)!)
            DispatchQueue.main.async {
                self.iQImage.image = UIImage(data: data! as Data)
            }
        }
        
        bLeaderboard = UIButton()
        bLeaderboard.setTitle("Leaderboard", for: .normal)
        bLeaderboard.setTitleColor(.white, for: .normal)
        bLeaderboard.addTarget(self, action: #selector(self.showLeaderboard), for: .touchUpInside)
        bLeaderboard.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        view.addSubview(bLeaderboard)
        bLeaderboard.autoPinEdge(.bottom, to: .top, of: vQuiz, withOffset: -20)
        bLeaderboard.autoPinEdge(.trailing, to: .trailing, of: vQuiz)
    }
    
    @objc func showLeaderboard(_ sender: UIButton!) {
        router.showQuizLeaderboard(quiz: quiz)
    }
    
    @objc func startQuiz(_ sender: UIButton!) {
        router.showQuizQuestion(quiz: quiz)
    }
    
    @objc func goBack(_ sender: UIButton!) {
        router.goBack()
    }

}
