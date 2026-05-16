import Foundation

final class RetryManager {

    static func retry<T>(
        maxAttempts: Int = 3,
        delay: UInt64 = 1_000_000_000,
        operation: @escaping () async throws -> T
    ) async throws -> T {

        var currentAttempt = 0

        while currentAttempt < maxAttempts {

            do {

                return try await operation()

            } catch {

                currentAttempt += 1

                if currentAttempt ==
                    maxAttempts {

                    throw error
                }

                try await Task.sleep(
                    nanoseconds: delay
                )
            }
        }

        throw NetworkError.retryFailed
    }
}