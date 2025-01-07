# Easybeam Swift SDK

[![Build and Test](https://github.com/easybeamai/easybeam-swift/actions/workflows/ci.yml/badge.svg)](https://github.com/easybeamai/easybeam-swift/actions)

Easybeam Swift SDK is a powerful and flexible library for integrating Easybeam AI functionality into your iOS applications. This SDK provides seamless access to Easybeam's AI-powered chat capabilities, supporting both streaming and non-streaming interactions with prompts and agents, along with secure credential handling for advanced agent integrations.

## Features

- **Advanced Agent Integration**: Securely interact with Easybeam agents using protected credentials and external service integration
- **Prompt Management**: Efficiently work with Easybeam prompts for streamlined AI interactions
- **Streaming Support**: Real-time streaming of AI responses using modern Swift concurrency
- **Non-Streaming Requests**: Traditional request-response pattern for simpler interactions
- **Flexible Configuration**: Customize the SDK behavior to fit your application needs
- **Error Handling**: Robust error handling for reliable integration
- **Review Submission**: Built-in functionality to submit user reviews

## Installation

### Swift Package Manager

You can add Easybeam Swift SDK to an Xcode project by adding it as a package dependency.

1. From the **File** menu, select **Add Packages...**
2. Enter "https://github.com/easybeamai/easybeam-swift" into the package repository URL text field
3. Click **Add Package**

## Usage

### Initialization

First, import the package and create an instance of EasyBeam:

```swift
import easybeam_swift

let config = EasyBeamConfig(token: "your_api_token_here")
let easybeam = EasyBeam(config: config)
```

### Working with Agents

Agents provide advanced AI capabilities with external service integration. Here's how to use them:

#### Streaming Agent Interaction

```swift
let userSecrets = ["apiKey": "your-sensitive-api-key"] // Optional secure credentials

let stream = easybeam.streamAgent(
    agentId: "your_agent_id",
    userId: "user123",
    filledVariables: ["language": "english"],
    messages: [
        ChatMessage(
            content: "Analyze the market data for Q2",
            role: .user,
            createdAt: ChatMessage.getCurrentTimestamp(),
            id: "1"
        )
    ],
    userSecrets: userSecrets // Optional parameter for secure credentials
)

for try await response in stream {
    print("Agent response: \(response.newMessage.content)")
}
```

#### Non-Streaming Agent Interaction

```swift
do {
    let response = try await easybeam.getAgent(
        agentId: "your_agent_id",
        userId: "user123",
        filledVariables: ["language": "english"],
        messages: [
            ChatMessage(
                content: "Generate a sales report",
                role: .user,
                createdAt: ChatMessage.getCurrentTimestamp(),
                id: "1"
            )
        ],
        userSecrets: ["apiKey": "your-sensitive-api-key"] // Optional secure credentials
    )
    print("Agent response: \(response.newMessage.content)")
} catch {
    print("Error: \(error)")
}
```

### Working with Prompts

For simpler AI interactions without external service integration:

```swift
let stream = easybeam.streamPrompt(
    promptId: "your_prompt_id",
    filledVariables: ["key": "value"],
    messages: [
        ChatMessage(
            content: "Hello, AI!",
            role: .user,
            createdAt: ChatMessage.getCurrentTimestamp(),
            id: "1"
        )
    ]
)

for try await response in stream {
    print("New message: \(response.newMessage.content)")
}
```

### Submitting Reviews

To submit a review for any chat interaction:

```swift
do {
    try await easybeam.review(
        chatId: "your_chat_id",
        userId: "user123",
        reviewScore: 5,
        reviewText: "Great experience!"
    )
    print("Review submitted successfully")
} catch {
    print("Error submitting review: \(error)")
}
```

## Advanced Usage

### Custom URLSession

You can inject a custom URLSession for more control over network requests:

```swift
let customConfiguration = URLSessionConfiguration.default
customConfiguration.timeoutIntervalForRequest = 30
let customSession = URLSession(configuration: customConfiguration)
easybeam.injectUrlSession(customSession)
```

## Security Considerations

When working with agents that require external service credentials, it's important to implement proper security measures:

- Store sensitive credentials securely using Keychain or other secure storage solutions
- Only pass credentials through the userSecrets parameter when making agent requests
- Implement proper token management for the Easybeam API token
- Consider implementing additional encryption for sensitive data in transit
- Follow Apple's security best practices for handling sensitive information

## Error Handling

The SDK provides comprehensive error handling through the `EasyBeamError` enum:

- `invalidResponse`: Server returned an unexpected response
- `encodingError`: Failed to encode request data
- `decodingError`: Failed to decode response data

Always implement proper error handling using do-catch blocks or handle errors in async sequences.

## System Requirements

- iOS 15.0 or later
- macOS 12.0 or later
- Xcode 13.0 or later
- Swift 5.5 or later

## Contributing

Contributions to the Easybeam Swift SDK are welcome! Please refer to the contributing guidelines for more information.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support, please contact hello@easybeam.ai or visit our [documentation](https://docs.easybeam.ai).
