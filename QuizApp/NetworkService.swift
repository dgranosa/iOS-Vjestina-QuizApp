import UIKit
import Reachability

class NetworkService: NetworkServiceProtocol {
    let baseUrl = "https://iosquiz.herokuapp.com/api"
    let reach = Reachability.forInternetConnection()
    
    func login(email: String, password: String, completionHandler: @escaping (Result<LoginStatus, RequestError>) -> Void) {
        guard let url = URL(string: baseUrl + "/session") else { return }
        
        let parameters = [ "username": email, "password": password ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        executeUrlRequest(request, completionHandler: completionHandler)
    }
    
    func fetchQuizes(completionHandler: @escaping (Result<Quizzes, RequestError>) -> Void) {
        guard let url = URL(string: baseUrl + "/quizzes") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        executeUrlRequest(request, completionHandler: completionHandler)
    }
    
    func submitResult(quizResult: QuizResult, completionHandler: @escaping (Result<String, RequestError>) -> Void) {
        guard let url = URL(string: baseUrl + "/result") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(UserDefaults.init().string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(quizResult)
        
        executeUrlRequest(request, completionHandler: completionHandler)
    }
    
    func fetchLeaderboard(quiz: Quiz, completionHandler: @escaping (Result<[LeaderboardResult], RequestError>) -> Void) {
        guard let url = URL(string: baseUrl + "/score?quiz_id=\(quiz.id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(UserDefaults.init().string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        executeUrlRequest(request, completionHandler: completionHandler)
    }
    
    func executeUrlRequest<T: Decodable>(_ request: URLRequest, completionHandler: @escaping (Result<T, RequestError>) -> Void) {
        if !reach!.isReachable() {
            completionHandler(.failure(.noConnectionError))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, err in
            guard err == nil else {
                completionHandler(.failure(.clientError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completionHandler(.failure(.serverError))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.noDataError))
                return
            }
            
            guard let value = try? JSONDecoder().decode(T.self, from: data) else {
                completionHandler(.failure(.decodingError))
                return
            }
            
            completionHandler(.success(value))
        }
        dataTask.resume()
    }
}
