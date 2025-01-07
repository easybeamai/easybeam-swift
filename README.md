# Easybeam Swift SDK

[![Build and Test](https://github.com/easybeamai/easybeam-swift/actions/workflows/ci.yml/badge.svg)](https://github.com/easybeamai/easybeam-swift/actions)

Easybeam Swift SDK is a powerful and flexible library for integrating Easybeam AI functionality into your iOS applications. This SDK provides seamless access to Easybeam's AI-powered chat capabilities, supporting both streaming and non-streaming interactions with prompts and agents.

## Features

- **Prompt and Agent Integration**: Easily interact with Easybeam prompts and agents.
- **Streaming Support**: Real-time streaming of AI responses for interactive experiences.
- **Non-Streaming Requests**: Traditional request-response pattern for simpler interactions.
- **Flexible Configuration**: Customize the SDK behavior to fit your application needs.
- **Error Handling**: Robust error handling for reliable integration.
- **Review Submission**: Built-in functionality to submit user reviews.

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

### Streaming Interaction

To start a streaming interaction with a prompt:

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

### Non-Streaming Interaction

For a simple request-response interaction:

```swift
do {
    let response = try await easybeam.getPrompt(
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
    print("AI response: \(response.newMessage.content)")
} catch {
    print("Error: \(error)")
}
```

### Submitting a Review

To submit a review for a chat interaction:

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
let customSession = URLSession(configuration: .default)
easybeam.injectUrlSession(customSession)
```

## Error Handling

The SDK provides detailed error messages through the `EasyBeamError` enum. Always use proper error handling with do-catch blocks or handle errors in your async sequences.

## Notes

- Ensure you have a valid Easybeam API token before using the SDK.
- The SDK uses `AsyncSequence` for streaming, which requires iOS 15.0 or later.
- For production applications, consider implementing proper token management and security practices.

## Contributing

Contributions to the Easybeam Swift SDK are welcome! Please refer to the contributing guidelines for more information.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support, please contact hello@easybeam.ai or visit our [documentation](https://docs.easybeam.ai).
