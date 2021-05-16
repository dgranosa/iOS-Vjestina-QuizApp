//
//  LeaderboardViewController.swift
//  QuizApp
//
//  Created by five on 14.05.2021..
//

import UIKit

class LeaderboardViewController: UIViewController {
    
    
    let cellId = "leaderboardCellId"
    private var router: AppRouter!
    private var quiz: Quiz!
    private var leaderboardData: [LeaderboardResult]!
    
    convenience init(router: AppRouter, quiz: Quiz) {
        self.init()
        self.router = router
        self.quiz = quiz
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        NetworkService().fetchLeaderboard(quiz: quiz, completionHandler: { [self] (result: Result<[LeaderboardResult], RequestError>) -> Void in
            switch result {
            case .success(let leaderboardResults):
                leaderboardData = leaderboardResults
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            case .failure(let error):
                handleError(error)
            }
        })
    }
    
    private var gradiantLayer: CAGradientLayer!
    private var backButton: UIButton!
    private var titleLabel: UILabel!
    private var tableView: UITableView!
    private var playerLabel: UILabel!
    private var pointsLabel: UILabel!
    
    func setupView() {
        gradiantLayer = CAGradientLayer()
        gradiantLayer.frame = view.bounds
        gradiantLayer.colors = [CGColor(red: 0.21, green: 0.21, blue: 0.49, alpha: 1),
                                CGColor(red: 0.4, green: 0.29, blue: 0.61, alpha: 1)]
        gradiantLayer.startPoint = CGPoint(x: 0, y: 1)
        gradiantLayer.endPoint = CGPoint(x: 1, y: 0)
        view.layer.addSublayer(gradiantLayer)
        
        titleLabel = UILabel()
        titleLabel.text = "Leaderboard"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        titleLabel.autoPinEdgesToSuperviewEdges(with: .init(top: 45, left: 0, bottom: -1, right: 0), excludingEdge: .bottom)
        
        backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "CloseButton"), for: .normal)
        backButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        backButton.autoPinEdge(.top, to: .top, of: titleLabel)
        backButton.autoPinEdge(.bottom, to: .bottom, of: titleLabel)
        
        tableView = UITableView()
        tableView.backgroundColor = .none
        tableView.separatorColor = .white
        tableView.separatorInset = .zero
        tableView.register(LeaderboardViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges(with: .init(top: 180, left: 0, bottom: 0, right: 0))
        
        playerLabel = UILabel()
        playerLabel.text = "Player"
        playerLabel.textColor = .white
        playerLabel.textAlignment = .left
        playerLabel.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(playerLabel)
        playerLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 60)
        playerLabel.autoPinEdge(.bottom, to: .top, of: tableView, withOffset: -10)
        
        pointsLabel = UILabel()
        pointsLabel.text = "Score"
        pointsLabel.textColor = .white
        pointsLabel.textAlignment = .left
        pointsLabel.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(pointsLabel)
        pointsLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 30)
        pointsLabel.autoPinEdge(.bottom, to: .top, of: tableView, withOffset: -10)
    }
    
    @objc func goBack(_ sender: UIButton!) {
        router.goBack()
    }
    
}


extension LeaderboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboardData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! LeaderboardViewCell
        
        cell.setLeaderboardResult(leaderboardData[indexPath.row], position: indexPath.row+1)
        
        return cell
    }
}

extension LeaderboardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
