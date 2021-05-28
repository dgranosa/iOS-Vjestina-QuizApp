//
//  QuizzesViewController.swift
//  QuizApp
//
//  Created by five on 11.04.2021..
//

import UIKit
import PureLayout

class QuizzesViewController: UIViewController {
    
    let cellId = "quizzesCellId"
    private var router: AppRouter!
    private var quizRepository: QuizRepository!
    private var data: [[Quiz]]!
    
    private var gradiantLayer: CAGradientLayer!
    private var stackView: UIStackView!
    private var tableView: UITableView!
    private var funFactStackView: UIStackView!
    private var funFactTitleLabel: UILabel!
    private var funFactLabel: UILabel!
    
    convenience init(router: AppRouter, quizRepository: QuizRepository) {
        self.init()
        self.router = router
        self.quizRepository = quizRepository
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getQuizzes()
    }
    
    func setupView() {
        gradiantLayer = CAGradientLayer()
        gradiantLayer.frame = view.bounds
        gradiantLayer.colors = [CGColor(red: 0.21, green: 0.21, blue: 0.49, alpha: 1),
                                CGColor(red: 0.4, green: 0.29, blue: 0.61, alpha: 1)]
        gradiantLayer.startPoint = CGPoint(x: 0, y: 1)
        gradiantLayer.endPoint = CGPoint(x: 1, y: 0)
        
        view.layer.addSublayer(gradiantLayer)
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        
        funFactStackView = UIStackView()
        funFactStackView.axis = .vertical
        
        funFactTitleLabel = UILabel()
        funFactTitleLabel.text = "Fun fact"
        funFactTitleLabel.textAlignment = .left
        funFactTitleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        funFactTitleLabel.textColor = .white
        
        funFactLabel = UILabel()
        funFactLabel.text = "None"
        funFactLabel.numberOfLines = 2
        funFactLabel.textAlignment = .left
        funFactLabel.textColor = .white
        
        funFactStackView.addArrangedSubview(funFactTitleLabel)
        funFactStackView.addArrangedSubview(funFactLabel)
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .none
        tableView.register(QuizzesViewCell.self, forCellReuseIdentifier: cellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.dataSource = self
        tableView.delegate = self
        
        funFactTitleLabel.autoSetDimension(.height, toSize: 40)
        
        stackView.addArrangedSubview(funFactStackView)
        stackView.addArrangedSubview(tableView)
        
        view.addSubview(stackView)
        
        stackView.autoPinEdgesToSuperviewSafeArea(with: .init(top: 5, left: 20, bottom: 0, right: 20))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradiantLayer.frame = view.bounds
    }

    func getQuizzes() {
        quizRepository.fetchData(completionHandler: { [self] quizzes in
            guard quizzes.count > 0 else { return }
            
            data = QuizCategory.allCases.map { category -> [Quiz] in
                return quizzes.filter { $0.category == category }
            }
            let questions = quizzes.flatMap { $0.questions }.map { $0.question }
            
            DispatchQueue.main.async { [weak self] in
                self?.funFactLabel.text = "There are \(questions.filter({ $0.contains("NBA") }).count) questions that contain the word \"NBA\""
                
                self?.tableView.reloadData()
            }
        })
    }
    
    /*@objc func getQuizzes(_ sender: UIButton!) {
        getQuizzesButton.isEnabled = false
        networkService.fetchQuizes(completionHandler: { [self] (result: Result<Quizzes, RequestError>) in
            DispatchQueue.main.async { self.getQuizzesButton.isEnabled = true }
            
            switch result {
            case .failure(let error):
                handleError(error)
            case .success(let q):
                let quizzes = q.quizzes
                data = Array(Set(quizzes.map({ $0.category }))).map({ (category) -> [Quiz] in
                    return quizzes.filter({ $0.category == category })
                })
                
                DispatchQueue.main.async { [self] in
                    tableView.reloadData()
                    
                    funFactLabel.text = "There are \(quizzes.flatMap({ $0.questions }).map({ $0.question }).filter({ $0.contains("NBA") }).count) questions that contain the word \"NBA\""
                }
            }
        })
    }*/
}

extension QuizzesViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if data == nil {
            return 0
        }
        
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data == nil {
            return 0
        }
        
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router.showQuiz(quiz: data[indexPath.section][indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! QuizzesViewCell
        
        cell.setQuiz(quiz: data[indexPath.section][indexPath.row])
        
        return cell
    }
}

extension QuizzesViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        
        let label = UILabel()
        label.text = "\(data[section].first!.category)".capitalized
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textColor = .white
        
        view.addSubview(label)
        label.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
        label.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        label.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        
        return view
    }
}
