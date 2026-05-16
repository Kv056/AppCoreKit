
import Foundation

final class SecureCacheManager {

    static let shared = SecureCacheManager()

    private let cache = NSCache<NSString, NSData>()

    func save(
        data: Data,
        key: String
    ) {

        cache.setObject(
            data as NSData,
            forKey: key as NSString
        )
    }

    func get(key: String) -> Data? {

        cache.object(
            forKey: key as NSString
        ) as Data?
    }
}