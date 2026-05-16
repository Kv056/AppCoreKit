import Foundation

final class APILogger {

    static func logRequest(
        _ request: URLRequest
    ) {

        print("""
        🌍 REQUEST:
        \(request.url?.absoluteString ?? "")
        """)
    }

    static func logResponse(
        _ response: URLResponse?,
        data: Data?
    ) {

        print("""
        ✅ RESPONSE:
        \(String(
            data: data ?? Data(),
            encoding: .utf8
        ) ?? "")
        """)
    }
}