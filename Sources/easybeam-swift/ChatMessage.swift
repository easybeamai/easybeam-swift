import Foundation

public enum ChatRole: String, Codable {
    case ai = "AI"
    case user = "USER"
}

public struct ChatMessage: Codable {
    public let content: String
    public let role: ChatRole
    public let createdAt: String
    public let providerId: String?
    public let id: String
    public let inputTokens: Double?
    public let outputTokens: Double?
    public let cost: Double?
    
    public init(content: String, role: ChatRole, createdAt: String, providerId: String? = nil, id: String, inputTokens: Double? = nil, outputTokens: Double? = nil, cost: Double? = nil) {
        self.content = content
        self.role = role
        self.createdAt = createdAt
        self.providerId = providerId
        self.id = id
        self.inputTokens = inputTokens
        self.outputTokens = outputTokens
        self.cost = cost
    }
    
    public static func getCurrentTimestamp() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: Date())
    }
}
