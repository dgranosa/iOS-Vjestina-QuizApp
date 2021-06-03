class QuizRepository {
    
    private var databaseDataSource: QuizDatabaseDataSource
    private var networkDataSource: QuizNetworkDataSource
    
    init(databaseDataSource: QuizDatabaseDataSource, networkDataSource: QuizNetworkDataSource) {
        self.databaseDataSource = databaseDataSource
        self.networkDataSource = networkDataSource
    }
    
    func fetchLocalData(titleFilter: String? = nil) -> [Quiz] {
        return databaseDataSource.fetchQuizzes(filter: titleFilter)
    }
    
    func fetchRemoteData(completionHandler: @escaping ([Quiz]) -> Void) {
        networkDataSource.fetchQuizzes(completionHandler: { [self] q in
            let quizzes = networkDataSource.fetcgQuizzesImages(quizzes: q)
            databaseDataSource.saveQuizzes(quizzes)
            completionHandler(quizzes)
        })
    }
    
}
