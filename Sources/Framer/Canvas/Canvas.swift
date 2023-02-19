import UIKit
import Foundation

internal class Canvas: FramerCanvasDrawer, FramerCanvasRenderer {
    private let size: CGSize
    private let renderer: CanvasRenderer
    private var state: CanvasState

    private let lock = RWLock()

    init(size: CGSize) {
        self.size = size
        self.renderer = CanvasRenderer(size: size)
        self.state = CanvasState()
    }

    func draw(blueprint: Blueprint) {
        lock.write {
            if let index = state.blueprints.firstIndex(where: { $0.id == blueprint.id }) {
                state.blueprints[index] = blueprint
            } else {
                state.blueprints.append(blueprint)
            }
        }
    }

    func erase(blueprintID: Blueprint.ID) {
        lock.write {
            state.blueprints.removeAll { $0.id == blueprintID }
        }
    }

    func eraseAllBlueprints() {
        lock.write {
            state.blueprints = []
        }
    }

    var image: UIImage {
        lock.read {
            renderer.render(state: state)
        }
    }

    var bounds: CGRect { .init(origin: .zero, size: size) }
}
