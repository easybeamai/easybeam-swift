import Foundation

@available(iOS 15.0, macOS 12.0, *)
public class EasyBeam {
    
    public enum EasyBeamError: Error {
        case invalidResponse
        case encodingError
        case decodingError
    }
    
    private let config: EasyBeamConfig
    private let baseUrl = "https://api.easybeam.ai/v1"
    private var session: URLSession
    
    public init(config: EasyBeamConfig) {
        self.config = config
        self.session = URLSession.shared
    }
    
    public func injectUrlSession(_ session: URLSession) {
        self.session = session
    }
    
    public func streamEndpoint(endpoint: String, id: String, userId: String? = nil, filledVariables: [String: String], messages: [ChatMessage]) -> AsyncThrowingStream<ChatResponse, Error> {
        AsyncThrowingStream { continuation in
            let url = URL(string: "\(baseUrl)/\(endpoint)/\(id)")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("text/event-stream", forHTTPHeaderField: "Accept")
            request.setValue("Bearer \(config.token)", forHTTPHeaderField: "Authorization")

            let body: [String: Any] = [
                "variables": filledVariables,
                "messages": messages.map { $0.asDictionary() },
                "stream": true,
                "userId": userId ?? NSNull()
            ]

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                continuation.finish(throwing: EasyBeamError.encodingError)
                return
            }

            let taskRequest = request

            Task {
                do {
                    let (bytes, response) = try await self.session.bytes(for: taskRequest)

                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        throw EasyBeamError.invalidResponse
                    }

                    for try await line in bytes.lines {
                        if Task.isCancelled { break }

                        guard line.hasPrefix("data: "),
                              let data = line.dropFirst(6).data(using: .utf8) else {
                            continue
                        }

                        do {
                            let chatResponse = try JSONDecoder().decode(ChatResponse.self, from: data)
                            continuation.yield(chatResponse)
                        } catch {
                            throw EasyBeamError.decodingError
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    public func getEndpoint(endpoint: String, id: String, userId: String? = nil, filledVariables: [String: String], messages: [ChatMessage]) async throws -> ChatResponse {
        let url = URL(string: "\(baseUrl)/\(endpoint)/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(config.token)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = [
            "variables": filledVariables,
            "messages": messages.map { $0.asDictionary() },
            "stream": false,
            "userId": userId ?? NSNull()
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw EasyBeamError.invalidResponse
        }
        
        return try JSONDecoder().decode(ChatResponse.self, from: data)
    }
    
    public func streamPrompt(promptId: String, userId: String? = nil, filledVariables: [String: String], messages: [ChatMessage]) -> AsyncThrowingStream<ChatResponse, Error> {
        streamEndpoint(endpoint: "prompt", id: promptId, userId: userId, filledVariables: filledVariables, messages: messages)
    }
    
    public func getPrompt(promptId: String, userId: String? = nil, filledVariables: [String: String], messages: [ChatMessage]) async throws -> ChatResponse {
        try await getEndpoint(endpoint: "prompt", id: promptId, userId: userId, filledVariables: filledVariables, messages: messages)
    }
    
    public func streamAgent(agentId: String, userId: String? = nil, filledVariables: [String: String], messages: [ChatMessage]) -> AsyncThrowingStream<ChatResponse, Error> {
        streamEndpoint(endpoint: "agent", id: agentId, userId: userId, filledVariables: filledVariables, messages: messages)
    }
    
    public func getAgent(agentId: String, userId: String? = nil, filledVariables: [String: String], messages: [ChatMessage]) async throws -> ChatResponse {
        try await getEndpoint(endpoint: "agent", id: agentId, userId: userId, filledVariables: filledVariables, messages: messages)
    }
    
    public func review(chatId: String, userId: String? = nil, reviewScore: Int? = nil, reviewText: String? = nil) async throws {
        let url = URL(string: "\(baseUrl)/review")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(config.token)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = [
            "chatId": chatId,
            "userId": userId ?? NSNull(),
            "reviewScore": reviewScore ?? NSNull(),
            "reviewText": reviewText ?? NSNull()
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw EasyBeamError.invalidResponse
        }
    }
}
