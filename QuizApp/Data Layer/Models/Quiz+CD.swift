import CoreData

extension Quiz {
    init(with entity: CDQuiz) {
        id = Int(entity.identifier)
        title = entity.title
        description = entity.desc
        category = QuizCategory(rawValue: entity.category) ?? .sport
        level = Int(entity.level)
        imageUrl = entity.imageUrl ?? ""
        imageData = entity.image
        questions = (entity.questions as? Set<CDQuestion> ?? []).map() { Question(with: $0) }
    }
    
    func populate(_ entity: CDQuiz, in context: NSManagedObjectContext) {
        entity.identifier = Int64(id)
        entity.title = title
        entity.desc = description
        entity.category = category.rawValue
        entity.level = Int16(level)
        entity.imageUrl = imageUrl
        entity.image = imageData
        
        entity.removeFromQuestions(entity.questions)
        questions.forEach { question in
            let cdQuestion = CDQuestion(context: context)
            question.populate(cdQuestion, in: context)
            entity.addToQuestions(cdQuestion)
        }
    }
}
