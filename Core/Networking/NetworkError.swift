import Foundation

enum NetworkError: Error {

    case invalidURL
    case invalidResponse
    case unauthorized
    case retryFailed
    case serverError(Int)
    case noInternet
}