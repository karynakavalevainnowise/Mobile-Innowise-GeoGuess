protocol Finishable: AnyObject {
    var onFinish: (() -> Void)? { get set }
}
