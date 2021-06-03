//
//  QuizResultViewController.swift
//  QuizApp
//
//  Created by five on 05.05.2021..
//

import UIKit

class QuizResultViewController: UIViewController {

    private var router: AppRouter!
    private var quiz: Quiz!
    private var quizResult: QuizResult!
    let networkService = NetworkService()
    
    private var gradiantLayer: CAGradientLayer!
    private var resultLabel: UILabel!
    private var finishButton: UIButton!
    private var leadeboardButton: UIButton!
    
    convenience init(router: AppRouter, quiz: Quiz, quizResult: QuizResult) {
        self.init()
        self.router = router
        self.quiz = quiz
        self.quizResult = quizResult
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        submitResult()
    }
    
    func setupView() {
        gradiantLayer = CAGradientLayer()
        gradiantLayer.frame = view.bounds
        gradiantLayer.colors = [CGColor(red: 0.21, green: 0.21, blue: 0.49, alpha: 1),
                                CGColor(red: 0.4, green: 0.29, blue: 0.61, alpha: 1)]
        gradiantLayer.startPoint = CGPoint(x: 0, y: 1)
        gradiantLayer.endPoint = CGPoint(x: 1, y: 0)
        view.layer.addSublayer(gradiantLayer)
        
        finishButton = {
            let b = UIButton()
            b.setTitle("Finish Quiz", for: .normal)
            b.setTitleColor(.purple, for: .normal)
            b.backgroundColor = .white
            b.layer.cornerRadius = 25
            b.addTarget(self, action: #selector(self.finishQuiz), for: .touchUpInside)
            return b
        }()
        finishButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(finishButton)
        finishButton.autoSetDimension(.height, toSize: 50)
        finishButton.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: -1, left: 40, bottom: 50, right: 40), excludingEdge: .top)
        
        leadeboardButton = UIButton()
        leadeboardButton.setTitle("Show leaderboard", for: .normal)
        leadeboardButton.setTitleColor(.purple, for: .normal)
        leadeboardButton.backgroundColor = .white
        leadeboardButton.layer.cornerRadius = 25
        leadeboardButton.addTarget(self, action: #selector(self.showLeaderboard), for: .touchUpInside)
        leadeboardButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(leadeboardButton)
        leadeboardButton.autoSetDimension(.height, toSize: 50)
        leadeboardButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 40)
        leadeboardButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 40)
        leadeboardButton.autoPinEdge(.bottom, to: .top, of: finishButton, withOffset: -20)
        
        resultLabel = UILabel()
        resultLabel.text = "\(quizResult.noOfCorrect)/\(quiz.questions.count)"
        resultLabel.font = UIFont.boldSystemFont(ofSize: 88)
        resultLabel.textColor = .white
        resultLabel.textAlignment = .center
        view.addSubview(resultLabel)
        resultLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 0, bottom: -1, right: 0), excludingEdge: .bottom)
        resultLabel.autoPinEdge(.bottom, to: .top, of: finishButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradiantLayer.frame = view.bounds
    }
    
    @objc func showLeaderboard(_ sender: UIButton!) {
        router.showQuizLeaderboard(quiz: quiz)
    }
    
    @objc func finishQuiz(_ sender: UIButton!) {
        router.goBackToQuizzes()
    }
    
    func submitResult() {
        networkService.submitResult(quizResult: quizResult, completionHandler: { [self] (result: Result<EmtpyResponse, RequestError>) in
            switch result {
            case .success(_): break
            case .failure(_):
                let alert = UIAlertController(title: "Error", message: "Was not able to submit quiz result", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
                
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: {_ in
                    submitResult()
                }))
                
                DispatchQueue.main.async {
                    present(alert, animated: true, completion: nil)
                }
            }
        })
    }
}
