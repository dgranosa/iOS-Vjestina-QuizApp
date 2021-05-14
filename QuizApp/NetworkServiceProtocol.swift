import UIKit

enum RequestError: Error {
    case clientError
    case serverError
    case noDataError
    case decodingError
    case noConnectionError
}

protocol NetworkServiceProtocol {
    func executeUrlRequest<T: Decodable>(_ request: URLRequest, completionHandler: @escaping (Result<T, RequestError>) -> Void)
    func login(email: String, password: String, completionHandler: @escaping (Result<LoginStatus, RequestError>) -> Void)
    func fetchQuizes(completionHandler: @escaping (Result<Quizzes, RequestError>) -> Void)
    func submitResult(quizResult: QuizResult, completionHandler: @escaping (Result<String, RequestError>) -> Void)
    func fetchLeaderboard(quiz: Quiz, completionHandler: @escaping (Result<[LeaderboardResult], RequestError>) -> Void)
}
