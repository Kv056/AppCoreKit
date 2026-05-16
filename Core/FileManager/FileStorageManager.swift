mport Foundation

final class FileStorageManager {

    static let shared = FileStorageManager()

    private init() {}

    func save(data: Data,
              fileName: String) throws {

        let url = try documentsDirectory()
            .appendingPathComponent(fileName)

         try data.write(to: url)
    }

    func read(fileName: String) throws -> Data {

        let url = try documentsDirectory()
            .appendingPathComponent(fileName)

        return try Data(contentsOf: url)
    }

    private func documentsDirectory() throws -> URL {
        guard let url = FileManager.default
            .urls(for: .documentDirectory,
                  in: .userDomainMask)
            .first else {
            throw NSError(domain: "Directory Error",
                          code: 0)
        }

        return url
    }
}