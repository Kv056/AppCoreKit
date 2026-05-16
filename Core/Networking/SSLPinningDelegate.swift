import Foundation

final class SSLPinningDelegate:
    NSObject,
    URLSessionDelegate {

    func urlSession(
        _ session: URLSession,
        didReceive challenge:
            URLAuthenticationChallenge
    ) async
    -> (
        URLSession
            .AuthChallengeDisposition,
        URLCredential?
    ) {

        guard let serverTrust =
            challenge
                .protectionSpace
                .serverTrust else {

            return (
                .cancelAuthenticationChallenge,
                nil
            )
        }

        return (
            .useCredential,
            URLCredential(
                trust: serverTrust
            )
        )
    }
}