import Foundation

internal protocol AnyMockable {
    static func mockAny() -> Self
}

internal protocol RandomMockable {
    static func mockRandom() -> Self
}

extension Array: AnyMockable where Element: AnyMockable {
    static func mockAny() -> [Element] {
        return mockAny(count: 10)
    }

    static func mockAny(count: Int) -> [Element] {
        return (0..<count).map { _ in .mockAny() }
    }
}

extension Array: RandomMockable where Element: RandomMockable {
    static func mockRandom() -> [Element] {
        return mockRandom(count: .random(in: 0..<100))
    }

    static func mockRandom(count: Int) -> [Element] {
        return (0..<count).map { _ in .mockRandom() }
    }
}
