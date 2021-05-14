//
//  QuizViewController.swift
//  QuizApp
//
//  Created by five on 04.05.2021..
//

import UIKit

class QuizViewController: UIViewController {
    
    private var router: AppRouter!
    private var quiz: Quiz!
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
    }
    
    private var layGradiant: CAGradientLayer!
    private var bBack: UIButton!
    private var lTitle: UILabel!
    private var lCurrQuestion: UILabel!
    private var questionTracker: QuestionTrackerView!
    private var lQuestion: UILabel!
    private var bAnswer1: UIButton!
    private var bAnswer2: UIButton!
    private var bAnswer3: UIButton!
    private var bAnswer4: UIButton!
    private var bsAnswer: [UIButton]!
    
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
        
        lCurrQuestion = UILabel()
        lCurrQuestion.text = "?/?"
        lCurrQuestion.font = UIFont.preferredFont(forTextStyle: .title2)
        lCurrQuestion.textColor = .white
        view.addSubview(lCurrQuestion)
        lCurrQuestion.autoSetDimension(.height, toSize: 25)
        lCurrQuestion.autoPinEdge(toSuperviewEdge: .top, withInset: 100)
        lCurrQuestion.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        
        questionTracker = QuestionTrackerView(number: quiz.questions.count)
        view.addSubview(questionTracker)
        questionTracker.autoSetDimension(.height, toSize: 5)
        questionTracker.autoPinEdge(.top, to: .bottom, of: lCurrQuestion, withOffset: 10)
        questionTracker.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        questionTracker.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        
        lQuestion = UILabel()
        lQuestion.text = "Who was the most famous Croatian basketball player in the NBA?"
        lQuestion.font = UIFont.preferredFont(forTextStyle: .title1)
        lQuestion.textColor = .white
        lQuestion.numberOfLines = 0
        view.addSubview(lQuestion)
        lQuestion.autoSetDimension(.height, toSize: 110)
        lQuestion.autoPinEdgesToSuperviewEdges(with: .init(top: 180, left: 20, bottom: -1, right: 20), excludingEdge: .bottom)
        
        bAnswer1 = UIButton()
        bAnswer1.setTitle("Answer #1", for: .normal)
        bAnswer1.backgroundColor = .init(white: 1, alpha: 0.3)
        bAnswer1.layer.cornerRadius = 27
        bAnswer1.contentHorizontalAlignment = .left
        bAnswer1.titleEdgeInsets = .init(top: 0, left: 27, bottom: 0, right: 0)
        bAnswer1.addTarget(self, action: #selector(self.answer), for: .touchUpInside)
        view.addSubview(bAnswer1)
        bAnswer1.autoSetDimension(.height, toSize: 55)
        bAnswer1.autoPinEdge(.top, to: .bottom, of: lQuestion, withOffset: 40)
        bAnswer1.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        bAnswer1.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        
        bAnswer2 = UIButton()
        bAnswer2.setTitle("Answer #2", for: .normal)
        bAnswer2.backgroundColor = .init(white: 1, alpha: 0.3)
        bAnswer2.layer.cornerRadius = 27
        bAnswer2.contentHorizontalAlignment = .left
        bAnswer2.titleEdgeInsets = .init(top: 0, left: 27, bottom: 0, right: 0)
        bAnswer2.addTarget(self, action: #selector(self.answer), for: .touchUpInside)
        view.addSubview(bAnswer2)
        bAnswer2.autoSetDimension(.height, toSize: 55)
        bAnswer2.autoPinEdge(.top, to: .bottom, of: bAnswer1, withOffset: 15)
        bAnswer2.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        bAnswer2.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        
        bAnswer3 = UIButton()
        bAnswer3.setTitle("Answer #3", for: .normal)
        bAnswer3.backgroundColor = .init(white: 1, alpha: 0.3)
        bAnswer3.layer.cornerRadius = 27
        bAnswer3.contentHorizontalAlignment = .left
        bAnswer3.titleEdgeInsets = .init(top: 0, left: 27, bottom: 0, right: 0)
        bAnswer3.addTarget(self, action: #selector(self.answer), for: .touchUpInside)
        view.addSubview(bAnswer3)
        bAnswer3.autoSetDimension(.height, toSize: 55)
        bAnswer3.autoPinEdge(.top, to: .bottom, of: bAnswer2, withOffset: 15)
        bAnswer3.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        bAnswer3.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        
        bAnswer4 = UIButton()
        bAnswer4.setTitle("Answer #4", for: .normal)
        bAnswer4.backgroundColor = .init(white: 1, alpha: 0.3)
        bAnswer4.layer.cornerRadius = 27
        bAnswer4.contentHorizontalAlignment = .left
        bAnswer4.titleEdgeInsets = .init(top: 0, left: 27, bottom: 0, right: 0)
        bAnswer4.addTarget(self, action: #selector(self.answer), for: .touchUpInside)
        view.addSubview(bAnswer4)
        bAnswer4.autoSetDimension(.height, toSize: 55)
        bAnswer4.autoPinEdge(.top, to: .bottom, of: bAnswer3, withOffset: 15)
        bAnswer4.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        bAnswer4.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        
        bsAnswer = [bAnswer1, bAnswer2, bAnswer3, bAnswer4]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layGradiant.frame = view.bounds
    }
    
    @objc func showNextQuestion() {
        currentQuestionIndex += 1
        
        if currentQuestionIndex > quiz.questions.count {
            router.showQuizResult(result: "\(questionTracker.getCorrectAnswers())/\(quiz.questions.count)")
            return
        }
        
        questionTracker.setCurrentQuestion(questionIndex: currentQuestionIndex)
        lCurrQuestion.text = "\(currentQuestionIndex)/\(quiz.questions.count)"
        
        let question = quiz.questions[currentQuestionIndex-1]
        lQuestion.text = question.question
        
        for (index, bAnswer) in bsAnswer.enumerated() {
            bAnswer.setTitle(question.answers[index], for: .normal)
            bAnswer.backgroundColor = .init(white: 1, alpha: 0.3)
            bAnswer.isEnabled = true
        }
    }
    
    @objc func goBack(_ sender: UIButton!) {
        router.goBack()
    }
    
    @objc func answer(_ sender: UIButton!) {
        let answeredIndex = bsAnswer.firstIndex(of: sender)
        let correctAnswerIndex = quiz.questions[currentQuestionIndex-1].correctAnswer
        
        if answeredIndex == correctAnswerIndex {
            questionTracker.setCorrectQuestion(questionIndex: currentQuestionIndex)
            sender.backgroundColor = .green
        } else {
            questionTracker.setWrongQuestion(questionIndex: currentQuestionIndex)
            sender.backgroundColor = .red
            bsAnswer[correctAnswerIndex].backgroundColor = .green
        }
        
        bsAnswer.forEach({ $0.isEnabled = false })
        
        questionTracker.animateQuestion(questionIndex: currentQuestionIndex, duration: 0.5)
        perform(#selector(self.showNextQuestion), with: nil, afterDelay: 0.5)
    }

}
