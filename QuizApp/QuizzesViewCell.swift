//
//  QuizzesViewCell.swift
//  QuizApp
//
//  Created by five on 12.04.2021..
//

import UIKit
import PureLayout

class QuizzesViewCell: UITableViewCell {
    
    private var v: UIView!
    private var lTitle: UILabel!
    private var lDescr: UILabel!
    private var iImage: UIImageView!
    private var iStar1: UIImageView!
    private var iStar2: UIImageView!
    private var iStar3: UIImageView!
    
    private let iStarY = UIImage(systemName: "star.fill")?.withTintColor(.yellow, renderingMode: .alwaysOriginal)
    private let iStarG = UIImage(systemName: "star.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        v = UIView()
        
        v.backgroundColor = .init(white: 1, alpha: 0.3)
        v.layer.cornerRadius = 10
        
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.alignment = .center
        hStackView.spacing = 30
        
        iImage = UIImageView(image: UIImage(systemName: "questionmark"))
        iImage.contentMode = .scaleAspectFill
        iImage.clipsToBounds = true
        iImage.layer.cornerRadius = 10
        
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.spacing = 5
        
        lTitle = UILabel()
        lTitle.text = "Title"
        lTitle.textColor = .white
        lTitle.font = UIFont.boldSystemFont(ofSize: 24)
        
        lDescr = UILabel()
        lDescr.text = "Quiz desc"
        lDescr.numberOfLines = 3
        lDescr.textColor = .white
        lDescr.font = UIFont.systemFont(ofSize: 14)
        
        let hStarView = UIStackView()
        hStarView.axis = .horizontal
        hStackView.spacing = 5
        
        iStar1 = UIImageView()
        iStar2 = UIImageView()
        iStar3 = UIImageView()
        
        hStarView.addArrangedSubview(UIView())
        hStarView.addArrangedSubview(iStar1)
        hStarView.addArrangedSubview(iStar2)
        hStarView.addArrangedSubview(iStar3)
        
        vStackView.addArrangedSubview(hStarView)
        vStackView.addArrangedSubview(lTitle)
        vStackView.addArrangedSubview(lDescr)
        
        hStackView.addArrangedSubview(iImage)
        hStackView.addArrangedSubview(vStackView)
        
        iImage.autoSetDimension(.height, toSize: 100)
        iImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        v.addSubview(hStackView)
        
        hStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        addSubview(v)
        
        v.autoPinEdgesToSuperviewEdges(with: .init(top: 5, left: 0, bottom: 5, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setQuiz(quiz: Quiz) {
        lTitle.text = quiz.title
        lDescr.text = quiz.description
        
        iImage.image = UIImage(systemName: "questionmark")
        DispatchQueue.global().async { [weak self] in
            let data = NSData(contentsOf: URL.init(string: quiz.imageUrl)!)
            DispatchQueue.main.async {
                self?.iImage.image = UIImage(data: data! as Data)
            }
        }
        
        iStar1.image = quiz.level >= 1 ? iStarY : iStarG
        iStar2.image = quiz.level >= 2 ? iStarY : iStarG
        iStar3.image = quiz.level >= 3 ? iStarY : iStarG
    }
}
