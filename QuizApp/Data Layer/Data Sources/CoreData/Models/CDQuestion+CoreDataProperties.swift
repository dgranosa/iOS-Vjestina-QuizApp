//
//  CDQuestion+CoreDataProperties.swift
//  QuizApp
//
//  Created by five on 27.05.2021..
//
//

import Foundation
import CoreData


extension CDQuestion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDQuestion> {
        return NSFetchRequest<CDQuestion>(entityName: "CDQuestion")
    }

    @NSManaged public var answers: [String]
    @NSManaged public var correctAnswer: Int16
    @NSManaged public var identifier: Int64
    @NSManaged public var question: String
    @NSManaged public var quiz: CDQuiz?

}

extension CDQuestion : Identifiable {

}
