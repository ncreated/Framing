import Foundation

internal protocol WindowRenderer: AnyObject {
    func render(state: WindowState)

    var onAction: ((WindowAction) -> Void)? { set get }

    var bounds: CGRect { get }
}

internal protocol WindowRendererProvider {
    func getRenderer(_ callback: @escaping (WindowRenderer) -> Void)
}
