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
    
    private var gradiantLayer: CAGradientLayer!
    private var backButton: UIButton!
    private var titleLabel: UILabel!
    private var leaderboardButton: UIButton!
    private var quizView: UIView!
    private var quizTitleLabel: UILabel!
    private var quizDescLabel: UILabel!
    private var quizImageView: UIImageView!
    private var quizStartButton: UIButton!
    
    func setupView() {
        gradiantLayer = CAGradientLayer()
        gradiantLayer.frame = view.bounds
        gradiantLayer.colors = [CGColor(red: 0.21, green: 0.21, blue: 0.49, alpha: 1),
                                CGColor(red: 0.4, green: 0.29, blue: 0.61, alpha: 1)]
        gradiantLayer.startPoint = CGPoint(x: 0, y: 1)
        gradiantLayer.endPoint = CGPoint(x: 1, y: 0)
        view.layer.addSublayer(gradiantLayer)
        
        backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "BackButton"), for: .normal)
        backButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.autoPinEdge(toSuperviewEdge: .top, withInset: 45)
        backButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        
        titleLabel = UILabel()
        titleLabel.text = "QuizApp"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        titleLabel.autoPinEdgesToSuperviewEdges(with: .init(top: 45, left: 0, bottom: -1, right: 0), excludingEdge: .bottom)
        
        quizView = UIView()
        quizView.backgroundColor = .init(white: 1, alpha: 0.3)
        quizView.layer.cornerRadius = 10
        
        quizTitleLabel = UILabel()
        quizTitleLabel.text = quiz.title
        quizTitleLabel.textColor = .white
        quizTitleLabel.textAlignment = .center
        quizTitleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        quizView.addSubview(quizTitleLabel)
        
        quizDescLabel = UILabel()
        quizDescLabel.text = quiz.description
        quizDescLabel.textColor = .white
        quizDescLabel.textAlignment = .center
        quizDescLabel.numberOfLines = 2
        quizDescLabel.font = UIFont.boldSystemFont(ofSize: 18)
        quizView.addSubview(quizDescLabel)
        
        quizImageView = UIImageView(image: UIImage(systemName: "questionmark"))
        quizImageView.contentMode = .scaleAspectFill
        quizImageView.clipsToBounds = true
        quizImageView.layer.cornerRadius = 10
        quizView.addSubview(quizImageView)
        
        quizStartButton = UIButton()
        quizStartButton.setTitle("Start Quiz", for: .normal)
        quizStartButton.setTitleColor(.purple, for: .normal)
        quizStartButton.backgroundColor = .white
        quizStartButton.layer.cornerRadius = 25
        quizStartButton.addTarget(self, action: #selector(self.startQuiz), for: .touchUpInside)
        quizStartButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        quizView.addSubview(quizStartButton)
        
        quizTitleLabel.autoPinEdgesToSuperviewEdges(with: .init(top: 20, left: 20, bottom: -1, right: 20), excludingEdge: .bottom)
        quizDescLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        quizDescLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        quizDescLabel.autoPinEdge(.top, to: .bottom, of: quizTitleLabel, withOffset: 20)
        quizImageView.autoSetDimension(.height, toSize: 200)
        quizImageView.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        quizImageView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        quizImageView.autoPinEdge(.top, to: .bottom, of: quizDescLabel, withOffset: 20)
        quizStartButton.autoSetDimension(.height, toSize: 50)
        quizStartButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        quizStartButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        quizStartButton.autoPinEdge(.top, to: .bottom, of: quizImageView, withOffset: 25)
        
        view.addSubview(quizView)
        quizView.autoSetDimension(.height, toSize: 420)
        quizView.autoPinEdgesToSuperviewEdges(with: .init(top: 200, left: 20, bottom: -1, right: 20), excludingEdge: .bottom)
        
        DispatchQueue.global().async { [self] in // TODO: store image data
            let data = NSData(contentsOf: URL(string: quiz.imageUrl)!)
            DispatchQueue.main.async {
                self.quizImageView.image = UIImage(data: data! as Data)
            }
        }
        
        leaderboardButton = UIButton()
        leaderboardButton.setTitle("Leaderboard", for: .normal)
        leaderboardButton.setTitleColor(.white, for: .normal)
        leaderboardButton.addTarget(self, action: #selector(self.showLeaderboard), for: .touchUpInside)
        leaderboardButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        view.addSubview(leaderboardButton)
        leaderboardButton.autoPinEdge(.bottom, to: .top, of: quizView, withOffset: -20)
        leaderboardButton.autoPinEdge(.trailing, to: .trailing, of: quizView)
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
