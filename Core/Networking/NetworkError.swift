import Foundation

enum NetworkError: Error {

    case invalidURL
    case invalidResponse
    case unauthorized
    case noInternet
    case retryFailed
    case serverError(Int)
    case decodingError
    case unknown
}