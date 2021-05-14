//
//  QuizzesViewController.swift
//  QuizApp
//
//  Created by five on 11.04.2021..
//

import UIKit
import PureLayout

class QuizzesViewController: UIViewController {
    
    let cellId = "cellId"
    let networkService = NetworkService()
    private var router: AppRouter!
    private var data: [[Quiz]]!
    
    private var layGradiant: CAGradientLayer!
    private var stackView: UIStackView!
    private var tableView: UITableView!
    private var vFunFact: UIStackView!
    private var bGetQuizzes: UIButton!
    private var lFunFactTitle: UILabel!
    private var lFunFact: UILabel!
    
    convenience init(router: AppRouter) {
        self.init()
        self.router = router
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getQuizzes(bGetQuizzes) // asdafohasiufhajsfihasfhaishfihas
    }
    
    func setupView() {
        layGradiant = CAGradientLayer()
        layGradiant.frame = view.bounds
        layGradiant.colors = [CGColor(red: 0.21, green: 0.21, blue: 0.49, alpha: 1),
                                CGColor(red: 0.4, green: 0.29, blue: 0.61, alpha: 1)]
        layGradiant.startPoint = CGPoint(x: 0, y: 1)
        layGradiant.endPoint = CGPoint(x: 1, y: 0)
        
        view.layer.addSublayer(layGradiant)
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        
        bGetQuizzes = UIButton()
        bGetQuizzes.setTitle("Get Quizzes", for: .normal)
        bGetQuizzes.addTarget(self, action: #selector(self.getQuizzes), for: .touchUpInside)
        
        vFunFact = UIStackView()
        vFunFact.axis = .vertical
        
        lFunFactTitle = UILabel()
        lFunFactTitle.text = "Fun fact"
        lFunFactTitle.textAlignment = .left
        lFunFactTitle.font = UIFont.preferredFont(forTextStyle: .title2)
        lFunFactTitle.textColor = .white
        
        lFunFact = UILabel()
        lFunFact.text = "None"
        lFunFact.numberOfLines = 2
        lFunFact.textAlignment = .left
        lFunFact.textColor = .white
        
        vFunFact.addArrangedSubview(lFunFactTitle)
        vFunFact.addArrangedSubview(lFunFact)
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .none
        tableView.register(QuizzesViewCell.self, forCellReuseIdentifier: cellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.dataSource = self
        tableView.delegate = self
        
        lFunFactTitle.autoSetDimension(.height, toSize: 40)
        bGetQuizzes.autoSetDimension(.height, toSize: 50)
        
        stackView.addArrangedSubview(bGetQuizzes)
        stackView.addArrangedSubview(vFunFact)
        stackView.addArrangedSubview(tableView)
        
        view.addSubview(stackView)
        
        stackView.autoPinEdgesToSuperviewSafeArea(with: .init(top: 0, left: 20, bottom: 0, right: 20))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layGradiant.frame = view.bounds
    }
    
    @objc func getQuizzes(_ sender: UIButton!) {
        networkService.fetchQuizes(completionHandler: { (result: Result<Quizzes, RequestError>) in
            switch result {
            case .failure(let error):
                switch error {
                case .clientError: break
                case .serverError: break
                case .noDataError: break
                case .decodingError: break
                case .noConnectionError: break
                }
            case .success(let q):
                let quizzes = q.quizzes
                self.data = Array(Set(quizzes.map({ $0.category }))).map({ (category) -> [Quiz] in
                    return quizzes.filter({ $0.category == category })
                })
                
                DispatchQueue.main.async { [self] in
                    tableView.reloadData()
                    
                    lFunFact.text = "There are \(quizzes.flatMap({ $0.questions }).map({ $0.question }).filter({ $0.contains("NBA") }).count) questions that contain the word \"NBA\""
                }
            }
        })
        /*let quizzes = dataService.fetchQuizes()
        data = Array(Set(quizzes.map({ $0.category }))).map({ (category) -> [Quiz] in
            return quizzes.filter({ $0.category == category })
        })
        tableView.reloadData()
        
        lFunFact.text = "There are \(quizzes.flatMap({ $0.questions }).map({ $0.question }).filter({ $0.contains("NBA") }).count) questions that contain the word \"NBA\""*/
    }
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
