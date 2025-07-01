protocol Coordinator: AnyObject {
    func start()
}

protocol ChildCoordinator: Coordinator {
    var onFinish: (() -> Void)? { get set }
}

protocol ParentCoordinator: Coordinator {
    var childCoordinators: [ChildCoordinator] { get set }
}

extension ParentCoordinator {
    func addChild(_ coordinator: ChildCoordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(_ coordinator: ChildCoordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
