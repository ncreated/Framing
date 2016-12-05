//: Playground - noun: a place where people can play

import UIKit
import Framing
import PlaygroundSupport


// MARK: Convenience

extension UIView {
    func createSubview(withFrame frame: Frame, color: UIColor) {
        let subview = UIView(frame: frame.rect)
        subview.backgroundColor = color
        addSubview(subview)
    }
}

// MARK: Calculating layout

let black = Frame(ofSize: CGSize(width: 400, height: 400))
let white = black.inset(top: 10, left: 10, bottom: 10, right: 10)


// MARK: Drawing

let view = UIView(frame: black.rect)
view.backgroundColor = .black

view.createSubview(withFrame: white, color: .white)

PlaygroundPage.current.liveView = view



