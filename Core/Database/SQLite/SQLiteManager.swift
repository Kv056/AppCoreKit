import Foundation
import SQLite3

final class SQLiteManager {

    static let shared = SQLiteManager()

    private var db: OpaquePointer?

    func openDatabase(named name: String) {

        let url = try! FileManager.default
            .urls(for: .documentDirectory,
                  in: .userDomainMask)
            .first!
            .appendingPathComponent(name)

        sqlite3_open(url.path, &db)
    }

    func execute(query: String) {
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Execution failed")
            }
        }

        sqlite3_finalize(statement)
    }
}