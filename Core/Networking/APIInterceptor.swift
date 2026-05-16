import Foundation

protocol APIInterceptorProtocol {

    func adapt(
        _ request: URLRequest
    ) async throws -> URLRequest
}

final class APIInterceptor:
    APIInterceptorProtocol {

    func adapt(
        _ request: URLRequest
    ) async throws -> URLRequest {

        var request = request

        let token =
            await TokenManager.shared
                .getToken()

        if let token {

            request.setValue(
                "Bearer \(token)",
                forHTTPHeaderField:
                    "Authorization"
            )
        }

        request.setValue(
            "application/json",
            forHTTPHeaderField:
                "Content-Type"
        )

        return request
    }
}