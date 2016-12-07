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

let background = Frame(width: 300, height: 300)

let green = Frame(width: 200, height: 40)
    .putInside(background)
    .align(to: .topCenter)
    .offsetBy(y: 45)

let yellowSize = CGSize(width: 200, height: 40)
let yellow = Frame(ofSize: yellowSize)
    .putBelow(green)
    .align(to: .center)
        .if(yellowSize.height > 0)
        .offsetBy(y: 15)

let blue = Frame(width: 200, height: 40)
    .putBelow(yellow)
    .align(to: .center)
    .offsetBy(y: 15)

// MARK: Drawing

let view = UIView(frame: background.rect)
view.backgroundColor = #colorLiteral(red: 0.9966825843, green: 0.9966985583, blue: 0.8922771811, alpha: 1)

view.createSubview(withFrame: green, color: #colorLiteral(red: 0.1718324125, green: 0.6832917333, blue: 0.4237753749, alpha: 1))
view.createSubview(withFrame: yellow, color: #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))
view.createSubview(withFrame: blue, color: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))

PlaygroundPage.current.liveView = view
