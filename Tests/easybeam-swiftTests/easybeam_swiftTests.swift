import XCTest
@testable import easybeam_swift

class EasyBeamTests: XCTestCase {
    
    var easyBeam: EasyBeam!
    var mockURLSession: URLSession!
    
    override func setUp() {
        super.setUp()
        let config = EasyBeamConfig(token: "test_token")
        easyBeam = EasyBeam(config: config)
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        mockURLSession = URLSession(configuration: configuration)
        
        easyBeam.injectUrlSession(mockURLSession)
    }
    
    override func tearDown() {
        easyBeam = nil
        mockURLSession = nil
        MockURLProtocol.mockResponses = []
        MockURLProtocol.mockError = nil
        super.tearDown()
    }
    
    func testStreamPortal() async throws {
        let expectedMessage1 = ChatMessage(
            content: "Test content 1",
            role: .ai,
            createdAt: ChatMessage.getCurrentTimestamp(),
            providerId: "test_provider",
            id: "test_message_id_1",
            inputTokens: 10,
            outputTokens: 20,
            cost: 0.001
        )
        let expectedResponse1 = PortalResponse(
            newMessage: expectedMessage1,
            chatId: "test_chat_id",
            streamFinished: false
        )
        
        let expectedMessage2 = ChatMessage(
            content: "Test content 2",
            role: .ai,
            createdAt: ChatMessage.getCurrentTimestamp(),
            providerId: "test_provider",
            id: "test_message_id_2",
            inputTokens: 15,
            outputTokens: 25,
            cost: 0.002
        )
        let expectedResponse2 = PortalResponse(
            newMessage: expectedMessage2,
            chatId: "test_chat_id",
            streamFinished: true
        )
        
        MockURLProtocol.mockResponses = [
            (try JSONEncoder().encode(expectedResponse1), true),
            (try JSONEncoder().encode(expectedResponse2), true)
        ]
        
        let stream = easyBeam.streamPortal(portalId: "test_portal", filledVariables: [:], messages: [])
        
        var receivedResponses: [PortalResponse] = []
        for try await response in stream {
            receivedResponses.append(response)
        }
        
        XCTAssertEqual(receivedResponses.count, 2)
        XCTAssertEqual(receivedResponses[0].newMessage.content, expectedMessage1.content)
        XCTAssertEqual(receivedResponses[0].newMessage.role, expectedMessage1.role)
        XCTAssertEqual(receivedResponses[0].chatId, expectedResponse1.chatId)
        XCTAssertEqual(receivedResponses[0].streamFinished, expectedResponse1.streamFinished)
        
        XCTAssertEqual(receivedResponses[1].newMessage.content, expectedMessage2.content)
        XCTAssertEqual(receivedResponses[1].newMessage.role, expectedMessage2.role)
        XCTAssertEqual(receivedResponses[1].chatId, expectedResponse2.chatId)
        XCTAssertEqual(receivedResponses[1].streamFinished, expectedResponse2.streamFinished)
    }
    
    func testGetPortal() async throws {
        let expectedMessage = ChatMessage(
            content: "Test content",
            role: .ai,
            createdAt: ChatMessage.getCurrentTimestamp(),
            providerId: "test_provider",
            id: "test_message_id",
            inputTokens: 10,
            outputTokens: 20,
            cost: 0.001
        )
        let expectedResponse = PortalResponse(
            newMessage: expectedMessage,
            chatId: "test_chat_id",
            streamFinished: true
        )
        MockURLProtocol.mockResponses = [(try JSONEncoder().encode(expectedResponse), false)]
        
        let response = try await easyBeam.getPortal(portalId: "test_portal", filledVariables: [:], messages: [])
        
        XCTAssertEqual(response.newMessage.content, expectedMessage.content)
        XCTAssertEqual(response.newMessage.role, expectedMessage.role)
        XCTAssertEqual(response.chatId, expectedResponse.chatId)
        XCTAssertEqual(response.streamFinished, expectedResponse.streamFinished)
    }
    
    func testStreamWorkflow() async throws {
        let expectedMessage1 = ChatMessage(
            content: "Test content 1",
            role: .ai,
            createdAt: ChatMessage.getCurrentTimestamp(),
            providerId: "test_provider",
            id: "test_message_id_1",
            inputTokens: 10,
            outputTokens: 20,
            cost: 0.001
        )
        let expectedResponse1 = PortalResponse(
            newMessage: expectedMessage1,
            chatId: "test_chat_id",
            streamFinished: false
        )
        
        let expectedMessage2 = ChatMessage(
            content: "Test content 2",
            role: .ai,
            createdAt: ChatMessage.getCurrentTimestamp(),
            providerId: "test_provider",
            id: "test_message_id_2",
            inputTokens: 15,
            outputTokens: 25,
            cost: 0.002
        )
        let expectedResponse2 = PortalResponse(
            newMessage: expectedMessage2,
            chatId: "test_chat_id",
            streamFinished: true
        )
        
        MockURLProtocol.mockResponses = [
            (try JSONEncoder().encode(expectedResponse1), true),
            (try JSONEncoder().encode(expectedResponse2), true)
        ]
        
        let stream = easyBeam.streamWorkflow(workflowId: "test_workflow", filledVariables: [:], messages: [])
        
        var receivedResponses: [PortalResponse] = []
        for try await response in stream {
            receivedResponses.append(response)
        }
        
        XCTAssertEqual(receivedResponses.count, 2)
        XCTAssertEqual(receivedResponses[0].newMessage.content, expectedMessage1.content)
        XCTAssertEqual(receivedResponses[0].newMessage.role, expectedMessage1.role)
        XCTAssertEqual(receivedResponses[0].chatId, expectedResponse1.chatId)
        XCTAssertEqual(receivedResponses[0].streamFinished, expectedResponse1.streamFinished)
        
        XCTAssertEqual(receivedResponses[1].newMessage.content, expectedMessage2.content)
        XCTAssertEqual(receivedResponses[1].newMessage.role, expectedMessage2.role)
        XCTAssertEqual(receivedResponses[1].chatId, expectedResponse2.chatId)
        XCTAssertEqual(receivedResponses[1].streamFinished, expectedResponse2.streamFinished)
    }
    
    func testGetWorkflow() async throws {
        let expectedMessage = ChatMessage(
            content: "Test content",
            role: .ai,
            createdAt: ChatMessage.getCurrentTimestamp(),
            providerId: "test_provider",
            id: "test_message_id",
            inputTokens: 10,
            outputTokens: 20,
            cost: 0.001
        )
        let expectedResponse = PortalResponse(
            newMessage: expectedMessage,
            chatId: "test_chat_id",
            streamFinished: true
        )
        MockURLProtocol.mockResponses = [(try JSONEncoder().encode(expectedResponse), false)]
        
        let response = try await easyBeam.getWorkflow(workflowId: "test_workflow", filledVariables: [:], messages: [])
        
        XCTAssertEqual(response.newMessage.content, expectedMessage.content)
        XCTAssertEqual(response.newMessage.role, expectedMessage.role)
        XCTAssertEqual(response.chatId, expectedResponse.chatId)
        XCTAssertEqual(response.streamFinished, expectedResponse.streamFinished)
    }
    
    func testReview() async {
        MockURLProtocol.mockResponses = [(Data(), false)]
        
        do {
            try await easyBeam.review(chatId: "test_chat", reviewScore: 5, reviewText: "Great!")
            // If we reach here, no error was thrown
            XCTAssert(true)
        } catch {
            XCTFail("review() threw an unexpected error: \(error)")
        }
    }
}

class MockURLProtocol: URLProtocol {
    static var mockResponses: [(Data, Bool)] = []
    static var mockError: Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockURLProtocol.mockError {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        guard !MockURLProtocol.mockResponses.isEmpty else {
            client?.urlProtocol(self, didFailWithError: NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil))
            return
        }
        
        let isStreaming = MockURLProtocol.mockResponses[0].1
        let contentType = isStreaming ? "text/event-stream" : "application/json"
        let httpResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type": contentType])!
        client?.urlProtocol(self, didReceive: httpResponse, cacheStoragePolicy: .notAllowed)
        
        for (data, isStreamingChunk) in MockURLProtocol.mockResponses {
            if isStreamingChunk {
                let event = "data: \(String(data: data, encoding: .utf8)!)\n\n"
                client?.urlProtocol(self, didLoad: event.data(using: .utf8)!)
            } else {
                client?.urlProtocol(self, didLoad: data)
            }
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
