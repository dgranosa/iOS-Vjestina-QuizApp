//
//  SearchQuizViewController.swift
//  QuizApp
//
//  Created by five on 27.05.2021..
//

import UIKit
import PureLayout

class SearchQuizViewController: UIViewController {

    let cellId = "searchCellId"
    private var router: AppRouter!
    private var quizRepository: QuizRepository!
    private var data: [[Quiz]]!
    
    private var gradiantLayer: CAGradientLayer!
    private var searchTextField: UITextField!
    private var searchButton: UIButton!
    private var tableView: UITableView!
    
    convenience init(router: AppRouter, quizRepository: QuizRepository) {
        self.init()
        self.router = router
        self.quizRepository = quizRepository
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        gradiantLayer = CAGradientLayer()
        gradiantLayer.frame = view.bounds
        gradiantLayer.colors = [CGColor(red: 0.21, green: 0.21, blue: 0.49, alpha: 1),
                                CGColor(red: 0.4, green: 0.29, blue: 0.61, alpha: 1)]
        gradiantLayer.startPoint = CGPoint(x: 0, y: 1)
        gradiantLayer.endPoint = CGPoint(x: 1, y: 0)
        
        view.layer.addSublayer(gradiantLayer)
        
        searchButton = UIButton()
        searchButton.setTitle("Search", for: .normal)
        searchButton.backgroundColor = .none
        searchButton.addTarget(self, action: #selector(self.fetchQuizzes), for: .touchUpInside)
        view.addSubview(searchButton)
        searchButton.autoSetDimensions(to: .init(width: 60, height: 50))
        searchButton.autoPinEdge(toSuperviewMargin: .top, withInset: 10)
        searchButton.autoPinEdge(toSuperviewMargin: .trailing, withInset: 20)
        
        searchTextField = UITextField()
        searchTextField.textColor = .white
        searchTextField.backgroundColor = .init(white: 1, alpha: 0.3)
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Type here", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1, alpha: 0.3)])
        searchTextField.returnKeyType = .search
        searchTextField.layer.cornerRadius = 25
        searchTextField.layer.borderWidth = 0
        searchTextField.layer.borderColor = .init(gray: 1, alpha: 1)
        searchTextField.leftView = .init(frame: .init(x: 0, y: 0, width: 25, height: 50))
        searchTextField.leftViewMode = .always
        searchTextField.delegate = self
        view.addSubview(searchTextField)
        searchTextField.autoPinEdge(.top, to: .top, of: searchButton)
        searchTextField.autoPinEdge(.bottom, to: .bottom, of: searchButton)
        searchTextField.autoPinEdge(.trailing, to: .leading, of: searchButton, withOffset: -20)
        searchTextField.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .none
        tableView.register(QuizzesViewCell.self, forCellReuseIdentifier: cellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewSafeArea(with: .init(top: -1, left: 20, bottom: 0, right: 20), excludingEdge: .top)
        tableView.autoPinEdge(.top, to: .bottom, of: searchTextField)
    }
    
    @objc func fetchQuizzes(_ sender: UIButton!) {
        let quizzes = quizRepository.fetchLocalData(titleFilter: searchTextField.text)
        
        data = QuizCategory.allCases.map { category -> [Quiz] in
            return quizzes.filter { $0.category == category }
        }.filter { !$0.isEmpty }
        tableView.reloadData()
    }

}

extension SearchQuizViewController : UITableViewDataSource {
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

extension SearchQuizViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        
        let label = UILabel()
        label.text = data[section].first!.category.rawValue.capitalized
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textColor = .white
        
        view.addSubview(label)
        label.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
        label.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        label.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        
        return view
    }
}

extension SearchQuizViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        fetchQuizzes(searchButton)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchTextField.layer.borderWidth = 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchTextField.layer.borderWidth = 0
    }
}
