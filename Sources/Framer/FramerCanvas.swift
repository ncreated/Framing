import UIKit
import Foundation

public protocol FramerCanvasDrawer {
    /// Draws given `blueprint`:
    /// - if `blueprint.id` is already drawn, it will be updated.
    /// - otherwise, it a new blueprint will be created.
    func draw(blueprint: Blueprint)

    /// Erases blueprint with given `Blueprint.ID`.
    func erase(blueprintID: Blueprint.ID)

    /// Erases all blueprints.
    func eraseAllBlueprints()
}

public protocol FramerCanvasRenderer {
    var image: UIImage { get }

    var bounds: CGRect { get }
}

public struct FramerCanvas {
    public static func create(size: CGSize) -> FramerCanvasDrawer & FramerCanvasRenderer {
        return Canvas(size: size)
    }
}
