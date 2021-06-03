//
//  QuestionTrackerView.swift
//  QuizApp
//
//  Created by five on 04.05.2021..
//

import UIKit

class QuestionTrackerView: UIView {
    
    private var numOfQuestions: Int!
    private var views: [UIView]!
    private var stackView: UIStackView!
    
    init(number: Int) {
        super.init(frame: .zero)
        self.numOfQuestions = number
        setupView()
    }
      
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        views = []
        for _ in 1...numOfQuestions {
            let v = UIView()
            v.backgroundColor = UIColor(white: 1, alpha: 0.5)
            v.layer.cornerRadius = 3
            views.append(v)
            stackView.addArrangedSubview(v)
        }
        
        addSubview(stackView)
        stackView.autoPinEdgesToSuperviewEdges()
    }
    
    func animateQuestion(questionIndex: Int, duration: TimeInterval) {
        if questionIndex >= views.count { return }
        let sv = views[questionIndex]
        let av = UIView(frame: .zero)
        
        sv.addSubview(av)
        av.frame = CGRect(x: 0, y: 0, width: 0, height: sv.bounds.height)
        av.backgroundColor = .white
        av.layer.cornerRadius = 3
        
        UIView.animate(withDuration: duration, animations: {
            av.frame = CGRect(x: 0, y: 0, width: sv.bounds.width, height: sv.bounds.height)
        }, completion: {_ in
            av.removeFromSuperview()
        })
    }
    
    func setCurrentQuestion(questionIndex: Int) {
        views[questionIndex-1].backgroundColor = .white
    }
    
    func setCorrectQuestion(questionIndex: Int) {
        views[questionIndex-1].backgroundColor = .green
    }
    
    func setWrongQuestion(questionIndex: Int) {
        views[questionIndex-1].backgroundColor = .red
    }
    
    func getCorrectAnswers() -> Int {
        return views.filter({ $0.backgroundColor == .green }).count
    }

}
