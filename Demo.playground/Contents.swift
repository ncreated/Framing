//: Playground - noun: a place where people can play

import UIKit
import Framing
import PlaygroundSupport


// MARK: Convenience

extension UIView {
    convenience init(frame: Frame, color: UIColor) {
        self.init(frame: frame.rect)
        self.backgroundColor = color
    }
}

// MARK: Calculating layout

let black = Frame(ofSize: CGSize(width: 400, height: 400))
let white = black.inset(top: 10, left: 10, bottom: 10, right: 10)


// MARK: Drawing

let view = UIView(frame: black, color: .black)
view.addSubview(UIView(frame: white, color: .white))

PlaygroundPage.current.liveView = view



