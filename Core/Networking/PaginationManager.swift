import Foundation

struct PaginatedResponse<
    T: Decodable
>: Decodable {

    let items: [T]
    let currentPage: Int
    let totalPages: Int
}

final class PaginationManager<T> {

    private(set) var items:
        [T] = []

    private(set) var currentPage = 1

    var canLoadMore = true

    func reset() {

        items.removeAll()

        currentPage = 1

        canLoadMore = true
    }

    func append(
        newItems: [T],
        totalPages: Int
    ) {

        items.append(
            contentsOf: newItems
        )

        currentPage += 1

        canLoadMore =
            currentPage <= totalPages
    }
}