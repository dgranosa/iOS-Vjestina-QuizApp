import UIKit

class QuizNetworkDataSource {
    
    private let networkService = NetworkService()
    
    func fetchQuizzes(completionHandler: @escaping ([Quiz]) -> Void) {
        networkService.fetchQuizes(completionHandler: { (result: Result<Quizzes, RequestError>) in
            switch (result) {
            case .failure(let error):
                print("Error downloding quizzes: \(error)")
            case .success(var q):
                q.quizzes[0].getImage()
                let quizzes = q.quizzes.map { cQuiz -> Quiz in
                    var quiz = Quiz(id: cQuiz.id, title: cQuiz.title, description: cQuiz.description, category: cQuiz.category, level: cQuiz.level, imageUrl: cQuiz.imageUrl, imageData: nil, questions: cQuiz.questions)
                    quiz.getImage()
                    return quiz
                }
                completionHandler(quizzes)
            }
        })
    }
}
