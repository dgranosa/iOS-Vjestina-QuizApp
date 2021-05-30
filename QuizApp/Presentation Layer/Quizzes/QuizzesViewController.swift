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
    private var presenter: QuizzesPresenter!
    
    private var gradiantLayer: CAGradientLayer!
    private var stackView: UIStackView!
    private var tableView: UITableView!
    private var funFactStackView: UIStackView!
    private var funFactTitleLabel: UILabel!
    private var funFactLabel: UILabel!
    
    convenience init(presenter: QuizzesPresenter) {
        self.init()
        self.presenter = presenter
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
        presenter.fetchData(completionHandler: {
            DispatchQueue.main.async {
                self.funFactLabel.text = "There are \(self.presenter.funFact()) questions that contain the word \"NBA\""
                self.tableView.reloadData()
            }
        })
    }
}

extension QuizzesViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRows(for: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.showQuiz(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! QuizzesViewCell
        
        let quiz = presenter.quizForIndexPath(indexPath)
        cell.setQuiz(quiz: quiz)
        
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
        label.text = presenter.titleForSection(section)
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textColor = .white
        
        view.addSubview(label)
        label.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
        label.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        label.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        
        return view
    }
}
