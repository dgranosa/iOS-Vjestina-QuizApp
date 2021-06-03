import UIKit

class QuizNetworkDataSource {
    
    private let networkService = NetworkService()
    
    func fetchQuizzes(completionHandler: @escaping ([Quiz]) -> Void) {
        networkService.fetchQuizes(completionHandler: { (result: Result<Quizzes, RequestError>) in
            switch (result) {
            case .failure(let error):
                print("Error downloding quizzes: \(error)")
            case .success(let q):
                let quizzes = q.quizzes.map { cQuiz -> Quiz in
                    let quiz = Quiz(id: cQuiz.id, title: cQuiz.title, description: cQuiz.description, category: cQuiz.category, level: cQuiz.level, imageUrl: cQuiz.imageUrl, imageData: nil, questions: cQuiz.questions)
                    return quiz
                }
                completionHandler(quizzes)
            }
        })
    }
    
    func fetcgQuizzesImages(quizzes: [Quiz]) -> [Quiz] {
        quizzes.map { quiz in
            if let url = URL.init(string: quiz.imageUrl) {
                let imageData = try? Data(contentsOf: url)
                return Quiz(id: quiz.id, title: quiz.title, description: quiz.description, category: quiz.category, level: quiz.level, imageUrl: quiz.imageUrl, imageData: imageData, questions: quiz.questions)
            } else {
                return quiz
            }
        }
    }
}
