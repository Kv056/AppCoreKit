import Foundation

protocol APIClientProtocol {

    func request<T: Decodable>(
        _ endpoint: Endpoint,
        responseType: T.Type
    ) async throws -> T
}

final class APIClient:
    APIClientProtocol {

    private let session:
        URLSession

    private let interceptor:
        APIInterceptorProtocol

    init(
        session: URLSession = .shared,
        interceptor:
            APIInterceptorProtocol =
                APIInterceptor()
    ) {

        self.session = session
        self.interceptor = interceptor
    }

    func request<T: Decodable>(
        _ endpoint: Endpoint,
        responseType: T.Type
    ) async throws -> T {

         guard NetworkMonitor.shared
            .isConnected else {

         throw NetworkError
            .noInternet
        }

        return try await RetryManager
            .retry {

                try await self
                    .performRequest(
                        endpoint,
                        responseType:
                            responseType
                    )
            }
    }

    private func performRequest<
        T: Decodable
    >(
        _ endpoint: Endpoint,
        responseType: T.Type
    ) async throws -> T {

        guard let url = URL(
            string:
                Environment.baseURL +
                endpoint.path
        ) else {

            throw NetworkError.invalidURL
        }

        var request =
            URLRequest(url: url)

        request.httpMethod =
            endpoint.method.rawValue

        request.httpBody =
            endpoint.body

        endpoint.headers?.forEach {

            request.setValue(
                $0.value,
                forHTTPHeaderField:
                    $0.key
            )
        }

        request =
            try await interceptor
                .adapt(request)

        APILogger.logRequest(request)

        let (data, response) =
            try await session
                .data(for: request)

        APILogger.logResponse(
            response,
            data: data
        )

        guard let httpResponse =
            response as?
                HTTPURLResponse else {

            throw NetworkError
                .invalidResponse
        }

        switch httpResponse
            .statusCode {

        case 200...299:
            break

        case 401:

            _ = try await TokenManager
                .shared
                .refreshToken()

            return try await
                performRequest(
                    endpoint,
                    responseType:
                        responseType
                )

        default:

            throw NetworkError
                .serverError(
                    httpResponse
                        .statusCode
                )
        }

        return try JSONDecoder()
            .decode(
                T.self,
                from: data
            )
    }
}