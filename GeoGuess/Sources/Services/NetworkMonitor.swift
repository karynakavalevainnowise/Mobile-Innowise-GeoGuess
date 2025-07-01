import Network
import Combine

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitor")

    let isConnected = CurrentValueSubject<Bool, Never>(false)

    private init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            debugPrint("🔌 Network path updated: \(path.status)")
            
            let isConnected = path.status == .satisfied
            if self?.isConnected.value != isConnected {
                debugPrint("🌐 isConnected changed to \(isConnected)")
                self?.isConnected.send(isConnected)
            }
        }
    }

    func start() {
        monitor.start(queue: queue)
    }

    func stop() {
        monitor.cancel()
    }
}
