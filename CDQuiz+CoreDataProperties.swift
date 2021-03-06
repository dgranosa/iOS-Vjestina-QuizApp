//
//  CDQuiz+CoreDataProperties.swift
//  QuizApp
//
//  Created by five on 28.05.2021..
//
//

import Foundation
import CoreData


extension CDQuiz {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDQuiz> {
        return NSFetchRequest<CDQuiz>(entityName: "CDQuiz")
    }

    @NSManaged public var category: String
    @NSManaged public var desc: String
    @NSManaged public var identifier: Int64
    @NSManaged public var image: Data?
    @NSManaged public var imageUrl: String?
    @NSManaged public var level: Int16
    @NSManaged public var title: String
    @NSManaged public var questions: NSSet

}

// MARK: Generated accessors for questions
extension CDQuiz {

    @objc(addQuestionsObject:)
    @NSManaged public func addToQuestions(_ value: CDQuestion)

    @objc(removeQuestionsObject:)
    @NSManaged public func removeFromQuestions(_ value: CDQuestion)

    @objc(addQuestions:)
    @NSManaged public func addToQuestions(_ values: NSSet)

    @objc(removeQuestions:)
    @NSManaged public func removeFromQuestions(_ values: NSSet)

}

extension CDQuiz : Identifiable {

}
