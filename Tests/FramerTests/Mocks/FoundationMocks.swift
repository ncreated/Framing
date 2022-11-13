import Foundation

extension Bool: AnyMockable, RandomMockable {
    static func mockAny() -> Bool {
        return true
    }

    static func mockRandom() -> Bool {
        return .random()
    }
}

extension CGFloat: AnyMockable, RandomMockable {
    static func mockAny() -> CGFloat {
        return 10
    }

    static func mockRandom() -> CGFloat {
        return .random(in: 0..<1_000)
    }
}

extension NSString: AnyMockable, RandomMockable {
    static func mockAny() -> Self {
        return String.mockAny() as! Self
    }

    static func mockRandom() -> Self {
        return String.mockRandom() as! Self
    }
}

extension String: AnyMockable, RandomMockable {
    private static let alphanumerics = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    private static let decimals = "0123456789"
    private static let whitespace = " "

    static func mockAny() -> Self {
        return "any string"
    }

    static func mockRandom() -> Self {
        let range = alphanumerics + decimals + whitespace
        let length: Int = .random(in: 0..<100)

        if length == 0 {
            return ""
        }

        return String((0..<length).map { _ in range.randomElement()! } )
    }
}
