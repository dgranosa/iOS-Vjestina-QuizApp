//
//  LeaderboardViewCell.swift
//  QuizApp
//
//  Created by five on 14.05.2021..
//

import UIKit
import PureLayout

class LeaderboardViewCell: UITableViewCell {
    
    private var positionLabel: UILabel!
    private var usernameLabel: UILabel!
    private var scoreLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        positionLabel = UILabel()
        positionLabel.text = "NaN."
        positionLabel.textColor = .white
        positionLabel.textAlignment = .right
        positionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        addSubview(positionLabel)
        
        usernameLabel = UILabel()
        usernameLabel.text = "Username"
        usernameLabel.textColor = .white
        usernameLabel.textAlignment = .left
        usernameLabel.font = UIFont.systemFont(ofSize: 20)
        addSubview(usernameLabel)
        
        scoreLabel = UILabel()
        scoreLabel.text = "NaN"
        scoreLabel.textColor = .white
        scoreLabel.textAlignment = .right
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 26)
        addSubview(scoreLabel)
        
        positionLabel.autoPinEdge(.trailing, to: .leading, of: self, withOffset: 50)
        positionLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        positionLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
        
        usernameLabel.autoPinEdge(.leading, to: .trailing, of: positionLabel, withOffset: 10)
        usernameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        usernameLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
        
        scoreLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 30)
        scoreLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
        scoreLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setLeaderboardResult(_ leaderboardResult: LeaderboardResult, position index: Int) {
        positionLabel.text = "\(index)."
        usernameLabel.text = leaderboardResult.username
        scoreLabel.text = leaderboardResult.score?.components(separatedBy: ".").first
    }
    
}
