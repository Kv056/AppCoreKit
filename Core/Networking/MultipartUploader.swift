import Foundation

final class MultipartUploader {

    func upload(
        url: URL,
        imageData: Data,
        parameterName:
            String = "file",
        fileName:
            String = "image.jpg",
        mimeType:
            String = "image/jpeg"
    ) async throws {

        let boundary =
            UUID().uuidString

        var request =
            URLRequest(url: url)

        request.httpMethod =
            "POST"

        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField:
                "Content-Type"
        )

        var body = Data()

        body.append(
            "--\(boundary)\r\n"
                .data(using: .utf8)!
        )

        body.append(
            "Content-Disposition: form-data; name=\"\(parameterName)\"; filename=\"\(fileName)\"\r\n"
                .data(using: .utf8)!
        )

        body.append(
            "Content-Type: \(mimeType)\r\n\r\n"
                .data(using: .utf8)!
        )

        body.append(imageData)

        body.append(
            "\r\n--\(boundary)--\r\n"
                .data(using: .utf8)!
        )

        request.httpBody = body

        _ = try await URLSession
            .shared
            .data(for: request)
    }
}