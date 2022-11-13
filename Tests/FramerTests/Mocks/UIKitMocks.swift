import UIKit

extension UIColor: AnyMockable, RandomMockable {
    static func mockAny() -> Self {
        return UIColor.blue as! Self
    }

    static func mockRandom() -> Self {
        return UIColor(
            red: .random(in: 0..<1),
            green: .random(in: 0..<1),
            blue: .random(in: 0..<1),
            alpha: .random(in: 0..<1)
        ) as! Self
    }
}

extension UIFont: AnyMockable, RandomMockable {
    static func mockAny() -> Self {
        return UIFont.systemFont(ofSize: 10) as! Self
    }

    static func mockRandom() -> Self {
        return UIFont.systemFont(ofSize: .random(in: 5..<20)) as! Self
    }
}
