import Foundation

public struct ChatResponse: Codable {
    public let newMessage: ChatMessage
    public let chatId: String
    public let streamFinished: Bool?
    
    public init(newMessage: ChatMessage, chatId: String, streamFinished: Bool? = nil) {
        self.newMessage = newMessage
        self.chatId = chatId
        self.streamFinished = streamFinished
    }
}
