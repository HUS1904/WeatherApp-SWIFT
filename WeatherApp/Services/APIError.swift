import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case requestFailed
    case decodingError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .requestFailed:
            return "Network request failed."
        case .decodingError:
            return "Failed to decode response."
        }
    }
}
