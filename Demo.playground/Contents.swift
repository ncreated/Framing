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

let bottomLine1 = Frame(width: 300, height: 20)
    .putInside(background, alignTo: .bottomCenter)

let bottomLine2 = Frame(width: 300, height: 30)
    .putAbove(bottomLine1)

let F1 = Frame(width: 50, height: 180)
    .putInside(background, alignTo: .middleLeft)
    .offsetBy(x: 90, y: -10)

let F2 = Frame(width: 70, height: 50)
    .putOnRight(of: F1, alignTo: .top)

let F3 = F2.offsetBy(y: 70)

// MARK: Drawing

let view = UIView(frame: background.rect)
view.backgroundColor = #colorLiteral(red: 0.9966825843, green: 0.9966985583, blue: 0.8922771811, alpha: 1)

view.createSubview(withFrame: bottomLine1, color: #colorLiteral(red: 0.1718324125, green: 0.6832917333, blue: 0.4237753749, alpha: 1))
view.createSubview(withFrame: bottomLine2, color: #colorLiteral(red: 0.6420532465, green: 0.8733261228, blue: 0.5131177902, alpha: 1))

view.createSubview(withFrame: F1, color: #colorLiteral(red: 0.1771433353, green: 0.2114563584, blue: 0.3061545789, alpha: 1))
view.createSubview(withFrame: F2, color: #colorLiteral(red: 0.1771433353, green: 0.2114563584, blue: 0.3061545789, alpha: 1))
view.createSubview(withFrame: F3, color: #colorLiteral(red: 0.1771433353, green: 0.2114563584, blue: 0.3061545789, alpha: 1))

PlaygroundPage.current.liveView = view



