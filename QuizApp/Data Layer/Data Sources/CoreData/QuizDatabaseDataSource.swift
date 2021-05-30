import CoreData

class QuizDatabaseDataSource {
    
    private let coreDataContext: NSManagedObjectContext
    
    init(coreDataContext: NSManagedObjectContext) {
        self.coreDataContext = coreDataContext
    }
    
    func fetchQuizzes(filter: String? = nil) -> [Quiz] {
        let request: NSFetchRequest<CDQuiz> = CDQuiz.fetchRequest()
        var titlePredicate = NSPredicate(value: true)
        
        if let filter = filter {
            titlePredicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(CDQuiz.title), filter)
            request.predicate = titlePredicate
        }
        
        do {
            return try coreDataContext.fetch(request).map { Quiz(with: $0) }
        } catch {
            print("Error when fetching quizzes from core data: \(error)")
            return []
        }
    }
    
    func saveQuizzes(_ quizzes: [Quiz]) {
        quizzes.forEach { quiz in
            saveQuiz(quiz)
        }
    }
    
    func saveQuiz(_ quiz: Quiz) {
        do {
            let cdQuiz = try fetchQuiz(id: quiz.id) ?? CDQuiz(context: coreDataContext)
            quiz.populate(cdQuiz, in: coreDataContext)
        } catch {
            print("Error when fetching/creating quiz: \(error)")
        }
        
        do {
            try coreDataContext.save()
        } catch {
            print("Error when saving updated quiz: \(error)")
        }
    }
    
    func fetchQuiz(id: Int) throws -> CDQuiz? {
        let request: NSFetchRequest<CDQuiz> = CDQuiz.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %u", #keyPath(CDQuiz.identifier), id)
        
        let cdQuiz = try coreDataContext.fetch(request)
        return cdQuiz.first
    }
    
    private func deleteAllQuizzesExcept(withId ids: [Int]) throws {
        let request: NSFetchRequest<CDQuiz> = CDQuiz.fetchRequest()
        request.predicate = NSPredicate(format: "NOT %K IN %@", #keyPath(CDQuiz.identifier), ids)

        let quizzesToDelete = try coreDataContext.fetch(request)
        quizzesToDelete.forEach { coreDataContext.delete($0) }
        try coreDataContext.save()
    }
    
}
