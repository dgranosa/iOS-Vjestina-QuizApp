import Foundation

class QuizzesPresenter {
    
    private weak var router: AppRouter!
    private var quizUseCase: QuizUseCase!
    private var categories: [QuizCategory] = []
    private var quizzes: [Quiz] = []
    
    init(router: AppRouter, quizUseCase: QuizUseCase) {
        self.router = router
        self.quizUseCase = quizUseCase
    }
    
    func fetchData(completionHandler: @escaping () -> Void) {
        quizUseCase.fetchData(completionHandler: { [self] quizzes in
            self.quizzes = quizzes
            categories = QuizCategory.allCases.filter { category in
                quizzes.contains(where: { $0.category == category })
            }
            
            completionHandler()
        })
    }
    
    func fetchData(filter: String) {
        self.quizzes = quizUseCase.fetchData(filter: filter)
        categories = QuizCategory.allCases.filter { category in
            quizzes.contains(where: { $0.category == category })
        }
    }
    
    var funFact: Int {
        quizzes
            .flatMap { $0.questions }
            .map { $0.question }
            .filter({ $0.contains("NBA") })
            .count
    }
    
    var numberOfSections: Int {
        categories.count
    }
    
    func numberOfRows(for section: Int) -> Int {
        getQuizzesOfCategory(categories[section]).count
    }
    
    func quizForIndexPath(_ indexPath: IndexPath) -> Quiz {
        getQuizzesOfCategory(categories[indexPath.section])[indexPath.row]
    }
    
    func titleForSection(_ section: Int) -> String {
        categories[section].rawValue.capitalized
    }
    
    func showQuiz(at indexPath: IndexPath) {
        router.showQuiz(quiz: getQuizzesOfCategory(categories[indexPath.section])[indexPath.row])
    }
    
    private func getQuizzesOfCategory(_ category: QuizCategory) -> [Quiz] {
        quizzes.filter { $0.category == category }
    }
}
