import CoreData

extension Question {
    init(with entity: CDQuestion) {
        id = Int(entity.identifier)
        question = entity.question
        answers = entity.answers
        correctAnswer = Int(entity.correctAnswer)
    }
    
    func populate(_ entity: CDQuestion, in context: NSManagedObjectContext) {
        entity.identifier = Int64(id)
        entity.question = question
        entity.answers = answers
        entity.correctAnswer = Int16(correctAnswer)
    }
}
