struct LoginStatus: Codable {
    let token: String
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
        case token
        case userId = "user_id"
    }
}
