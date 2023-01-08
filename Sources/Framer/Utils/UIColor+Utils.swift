import UIKit

extension UIColor {
    func lighter(by percentage: CGFloat) -> UIColor {
        return adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat) -> UIColor {
        return adjust(by: -abs(percentage) )
    }

    func contrast(by percentage: CGFloat) -> UIColor {
        if brightness > 0.5 {
            return darker(by: percentage)
        } else {
            return lighter(by: percentage)
        }
    }

    private var brightness: CGFloat {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return red * 0.3 + green * 0.59 + blue * 0.11;
        } else {
            return 0
        }
    }

    private func adjust(by percentage: CGFloat) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(
                red: max(0, min(red + percentage/100, 1.0)),
                green: max(0, min(green + percentage/100, 1.0)),
                blue: max(0, min(blue + percentage/100, 1.0)),
                alpha: alpha
            )
        } else {
            return self
        }
    }

    var alpha: CGFloat {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return alpha
        } else {
            return 0
        }
    }
}
