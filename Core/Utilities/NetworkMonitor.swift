import Foundation
import Network

final class NetworkMonitor {

    static let shared =
        NetworkMonitor()

    private let monitor =
        NWPathMonitor()

    private let queue =
        DispatchQueue(
            label: "NetworkMonitor"
        )

    private(set) var isConnected =
        false

    private(set) var connectionType:
        NWInterface.InterfaceType?

    private init() {}

    func startMonitoring() {

        monitor.pathUpdateHandler = {
            [weak self] path in

            self?.isConnected =
                path.status == .satisfied

            if path.usesInterfaceType(
                .wifi
            ) {

                self?.connectionType =
                    .wifi

            } else if path
                .usesInterfaceType(
                    .cellular
                ) {

                self?.connectionType =
                    .cellular
            }
        }

        monitor.start(
            queue: queue
        )
    }
}