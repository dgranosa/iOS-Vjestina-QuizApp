//
//  QuizViewController.swift
//  QuizApp
//
//  Created by five on 04.05.2021..
//

import UIKit
import Dispatch

class QuestionViewController: UIViewController {
    
    private var router: AppRouter!
    private var quiz: Quiz!
    private var startTime: DispatchTime!
    private var currentQuestionIndex: Int = 0
    
    convenience init(router: AppRouter, quiz: Quiz) {
        self.init()
        self.router = router
        self.quiz = quiz
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        showNextQuestion()
        startTime = DispatchTime.now()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradiantLayer.frame = view.bounds
    }
    
    private var gradiantLayer: CAGradientLayer!
    private var backButton: UIButton!
    private var titleLabel: UILabel!
    private var currQuestionLabel: UILabel!
    private var questionTracker: QuestionTrackerView!
    private var questionLabel: UILabel!
    private var answer1Button: UIButton!
    private var answer2Button: UIButton!
    private var answer3Button: UIButton!
    private var answer4Button: UIButton!
    private var answerButtons: [UIButton]!
    
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
        
        currQuestionLabel = UILabel()
        currQuestionLabel.text = "?/?"
        currQuestionLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        currQuestionLabel.textColor = .white
        view.addSubview(currQuestionLabel)
        currQuestionLabel.autoSetDimension(.height, toSize: 25)
        currQuestionLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 100)
        currQuestionLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        
        questionTracker = QuestionTrackerView(number: quiz.questions.count)
        view.addSubview(questionTracker)
        questionTracker.autoSetDimension(.height, toSize: 5)
        questionTracker.autoPinEdge(.top, to: .bottom, of: currQuestionLabel, withOffset: 10)
        questionTracker.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        questionTracker.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        
        questionLabel = UILabel()
        questionLabel.text = "Who was the most famous Croatian basketball player in the NBA?"
        questionLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        questionLabel.textColor = .white
        questionLabel.numberOfLines = 0
        view.addSubview(questionLabel)
        questionLabel.autoSetDimension(.height, toSize: 110)
        questionLabel.autoPinEdgesToSuperviewEdges(with: .init(top: 180, left: 20, bottom: -1, right: 20), excludingEdge: .bottom)
        
        answer1Button = UIButton()
        answer1Button.setTitle("Answer #1", for: .normal)
        answer1Button.backgroundColor = .init(white: 1, alpha: 0.3)
        answer1Button.layer.cornerRadius = 27
        answer1Button.contentHorizontalAlignment = .left
        answer1Button.titleEdgeInsets = .init(top: 0, left: 30, bottom: 0, right: 0)
        answer1Button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        answer1Button.addTarget(self, action: #selector(self.answer), for: .touchUpInside)
        view.addSubview(answer1Button)
        answer1Button.autoSetDimension(.height, toSize: 55)
        answer1Button.autoPinEdge(.top, to: .bottom, of: questionLabel, withOffset: 40)
        answer1Button.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        answer1Button.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        
        answer2Button = UIButton()
        answer2Button.setTitle("Answer #2", for: .normal)
        answer2Button.backgroundColor = .init(white: 1, alpha: 0.3)
        answer2Button.layer.cornerRadius = 27
        answer2Button.contentHorizontalAlignment = .left
        answer2Button.titleEdgeInsets = .init(top: 0, left: 30, bottom: 0, right: 0)
        answer2Button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        answer2Button.addTarget(self, action: #selector(self.answer), for: .touchUpInside)
        view.addSubview(answer2Button)
        answer2Button.autoSetDimension(.height, toSize: 55)
        answer2Button.autoPinEdge(.top, to: .bottom, of: answer1Button, withOffset: 15)
        answer2Button.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        answer2Button.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        
        answer3Button = UIButton()
        answer3Button.setTitle("Answer #3", for: .normal)
        answer3Button.backgroundColor = .init(white: 1, alpha: 0.3)
        answer3Button.layer.cornerRadius = 27
        answer3Button.contentHorizontalAlignment = .left
        answer3Button.titleEdgeInsets = .init(top: 0, left: 30, bottom: 0, right: 0)
        answer3Button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        answer3Button.addTarget(self, action: #selector(self.answer), for: .touchUpInside)
        view.addSubview(answer3Button)
        answer3Button.autoSetDimension(.height, toSize: 55)
        answer3Button.autoPinEdge(.top, to: .bottom, of: answer2Button, withOffset: 15)
        answer3Button.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        answer3Button.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        
        answer4Button = UIButton()
        answer4Button.setTitle("Answer #4", for: .normal)
        answer4Button.backgroundColor = .init(white: 1, alpha: 0.3)
        answer4Button.layer.cornerRadius = 27
        answer4Button.contentHorizontalAlignment = .left
        answer4Button.titleEdgeInsets = .init(top: 0, left: 30, bottom: 0, right: 0)
        answer4Button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        answer4Button.addTarget(self, action: #selector(self.answer), for: .touchUpInside)
        view.addSubview(answer4Button)
        answer4Button.autoSetDimension(.height, toSize: 55)
        answer4Button.autoPinEdge(.top, to: .bottom, of: answer3Button, withOffset: 15)
        answer4Button.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        answer4Button.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        
        answerButtons = [answer1Button, answer2Button, answer3Button, answer4Button]
    }
    
    @objc func showNextQuestion() {
        currentQuestionIndex += 1
        
        if currentQuestionIndex > quiz.questions.count {
            end()
            return
        }
        
        questionTracker.setCurrentQuestion(questionIndex: currentQuestionIndex)
        currQuestionLabel.text = "\(currentQuestionIndex)/\(quiz.questions.count)"
        
        let question = quiz.questions[currentQuestionIndex-1]
        questionLabel.text = question.question
        
        for (index, bAnswer) in answerButtons.enumerated() {
            bAnswer.setTitle(question.answers[index], for: .normal)
            bAnswer.backgroundColor = .init(white: 1, alpha: 0.3)
            bAnswer.isEnabled = true
        }
    }
    
    @objc func goBack(_ sender: UIButton!) {
        router.goBack()
    }
    
    @objc func answer(_ sender: UIButton!) {
        let answeredIndex = answerButtons.firstIndex(of: sender)
        let correctAnswerIndex = quiz.questions[currentQuestionIndex-1].correctAnswer
        
        if answeredIndex == correctAnswerIndex {
            questionTracker.setCorrectQuestion(questionIndex: currentQuestionIndex)
            sender.backgroundColor = .green
        } else {
            questionTracker.setWrongQuestion(questionIndex: currentQuestionIndex)
            sender.backgroundColor = .red
            answerButtons[correctAnswerIndex].backgroundColor = .green
        }
        
        answerButtons.forEach({ $0.isEnabled = false })
        
        questionTracker.animateQuestion(questionIndex: currentQuestionIndex, duration: 0.5)
        perform(#selector(self.showNextQuestion), with: nil, afterDelay: 0.5)
    }
    
    func end() {
        let quizResult = QuizResult(
            quizId: quiz.id,
            userId: UserDefaults.init().integer(forKey: "userId"),
            time: Double(DispatchTime.now().uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000_000,
            noOfCorrect: questionTracker.getCorrectAnswers()
        )
        
        router.showQuizResult(quiz: quiz, quizResult: quizResult)
    }

}
