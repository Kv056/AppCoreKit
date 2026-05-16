/*import Foundation

actor TokenManager {

    static let shared = TokenManager()

    private init() {}

    func getToken() -> String? {

        UserDefaults.standard.string(
            forKey: "access_token"
        )
    }

    func saveToken(_ token: String) {

        UserDefaults.standard.set(
            token,
            forKey: "access_token"
        )
    }

    func refreshToken() async throws {

        let newToken = "new_access_token"

        saveToken(newToken)
    }
}*/

import Foundation

actor TokenManager {

    static let shared =
        TokenManager()

    private init() {}

    // MARK: - Keys

    private let accessTokenKey =
        "access_token"

    private let refreshTokenKey =
        "refresh_token"

    private let tokenExpiryKey =
        "token_expiry"

    // MARK: - Refresh Protection

    private var refreshTask:
        Task<String, Error>?

    // MARK: - Request Tracking

    private var activeTasks:
        [UUID: Task<Void, Never>] = [:]

    // MARK: - Access Token

    func getAccessToken() -> String? {

        KeychainManager.shared.read(
            key: accessTokenKey
        )
    }

    func saveAccessToken(
        _ token: String
    ) {

        KeychainManager.shared.save(
            key: accessTokenKey,
            value: token
        )
    }

    // MARK: - Refresh Token

    func getRefreshToken() -> String? {

        KeychainManager.shared.read(
            key: refreshTokenKey
        )
    }

    func saveRefreshToken(
        _ token: String
    ) {

        KeychainManager.shared.save(
            key: refreshTokenKey,
            value: token
        )
    }

    // MARK: - Expiry

    func saveTokenExpiry(
        _ expiryDate: Date
    ) {

        UserDefaults.standard.set(
            expiryDate,
            forKey: tokenExpiryKey
        )
    }

    func getTokenExpiry()
    -> Date? {

        UserDefaults.standard.object(
            forKey: tokenExpiryKey
        ) as? Date
    }

    func isTokenExpired()
    -> Bool {

        guard let expiry =
            getTokenExpiry() else {

            return true
        }

        return Date() >= expiry
    }

    // MARK: - Session Validation

    func validateSession()
    async throws {

        if isTokenExpired() {

            do {

                _ = try await
                    refreshToken()

            } catch {

                await logout()

                NotificationCenter
                    .default
                    .post(
                        name:
                            .sessionExpired,
                        object: nil
                    )

                throw error
            }
        }
    }

    // MARK: - Refresh Token

    func refreshToken()
    async throws
    -> String {

        if let refreshTask {

            return try await
                refreshTask.value
        }

        let task =
            Task<String, Error> {

                defer {

                    refreshTask = nil
                }

                guard let refreshToken =
                    getRefreshToken() else {

                    throw NetworkError
                        .unauthorized
                }

                let response =
                    try await
                    performRefreshAPI(
                        refreshToken:
                            refreshToken
                    )

                saveAccessToken(
                    response.accessToken
                )

                saveRefreshToken(
                    response.refreshToken
                )

                saveTokenExpiry(
                    Date()
                        .addingTimeInterval(
                            3600
                        )
                )

                return response
                    .accessToken
            }

        self.refreshTask = task

        return try await
            task.value
    }

    // MARK: - Background Refresh

    func scheduleBackgroundRefresh()
    async {

        guard let expiry =
            getTokenExpiry() else {

            return
        }

        let refreshBefore:
            TimeInterval = 300

        let refreshDate =
            expiry.addingTimeInterval(
                -refreshBefore
            )

        let delay =
            refreshDate.timeIntervalSinceNow

        guard delay > 0 else {

            return
        }

        try? await Task.sleep(
            nanoseconds:
                UInt64(delay * 1_000_000_000)
        )

        try? await refreshToken()
    }

    // MARK: - Request Tracking

    func registerTask(
        id: UUID,
        task: Task<Void, Never>
    ) {

        activeTasks[id] = task
    }

    func cancelTask(
        id: UUID
    ) {

        activeTasks[id]?.cancel()

        activeTasks.removeValue(
            forKey: id
        )
    }

    func cancelAllRequests() {

        activeTasks.values.forEach {

            $0.cancel()
        }

        activeTasks.removeAll()
    }

    // MARK: - Session Timeout

    func startSessionTimeoutTimer(
        timeout:
            TimeInterval = 1800
    ) {

        Task {

            try? await Task.sleep(
                nanoseconds:
                    UInt64(
                        timeout *
                        1_000_000_000
                    )
            )

            await logout()
        }
    }

    // MARK: - Logout

    func logout() async {

        cancelAllRequests()

        KeychainManager.shared.delete(
            key: accessTokenKey
        )

        KeychainManager.shared.delete(
            key: refreshTokenKey
        )

        UserDefaults.standard.removeObject(
            forKey: tokenExpiryKey
        )

        NotificationCenter.default.post(
            name: .userDidLogout,
            object: nil
        )
    }
}

import Foundation

extension TokenManager {

    func performRefreshAPI(
        refreshToken: String
    ) async throws
    -> RefreshTokenResponse {

        /*
         Actual API call implementation
         will come here
         */

        try await Task.sleep(
            nanoseconds:
                1_000_000_000
        )

        return RefreshTokenResponse(

            accessToken:
                "new_access_token",

            refreshToken:
                "new_refresh_token"
        )
    }
}