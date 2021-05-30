class QuizUseCase {
    
    private let quizRepository: QuizRepository!
    
    init(quizRepository: QuizRepository) {
        self.quizRepository = quizRepository
    }
    
    func fetchData(completionHandler: @escaping ([Quiz]) -> Void) {
        completionHandler(quizRepository.fetchLocalData())
        quizRepository.fetchRemoteData(completionHandler: completionHandler)
    }
    
    func fetchData(filter: String) -> [Quiz] {
        quizRepository.fetchLocalData(titleFilter: filter)
    }
}
