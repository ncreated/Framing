<p align="center">
<img width="180" alt="framing-logo" src="https://cloud.githubusercontent.com/assets/2358722/20908023/2604621e-bb52-11e6-8616-456d85f4be77.png">
</p>

# Framing
Swifty approach to declarative frame layouts.

## What is `Framing`?

`Framing` is a tiny framework for defining view frames in more declarative way. Think of it as a simple wrapper over `CGRect` that can save you time spend on math calculations when positioning view frames. Look:

```swift
let background = Frame(width: 300, height: 300)

let bottomLine1 = Frame(width: 300, height: 20)
    .putInside(background).align(to: .bottomCenter)

let bottomLine2 = Frame(width: 300, height: 30)
    .putAbove(bottomLine1)
    .align(to: .center)

let F1 = Frame(width: 50, height: 180)
    .putInside(background)
    .align(to: .middleLeft)
    .offsetBy(x: 90, y: -10)

let F2 = Frame(width: 70, height: 50)
    .putOnRight(of: F1)
    .align(to: .top)

let F3 = F2.offsetBy(y: 70)
```

Every `Frame` provides `.rect` property that returns `CGRect` for `UIView`.
e.g. `greenView.frame = bottomLine2.rect`

<p align="center">
<img width="300" alt="framing-logo-framed" src="https://cloud.githubusercontent.com/assets/2358722/20908037/377e563a-bb52-11e6-8822-20788d21b311.png">
</p>

## What `Framing` is not?
It's not an animal :pig: or UI / Layout framework. It doesn't import `UIKit` anywhere.

## What you can do with `Framing`?
Have a quick look at `Framing` APIs.

This will return frame moved by `10pt` in both directions:
```swift
frame.offsetBy(x: 10, y: 10)
```

This will return frame that is `5pt` smaller in each direction:
```swift
frame.inset(top: 5, left: 5, bottom: 5, right: 5)
```

This will return frame that is put **above/below** `base` frame:
```swift
frame.putAbove(base).align(to: .left)
frame.putAbove(base).align(to: .right)
frame.putAbove(base).align(to: .center)
frame.putBelow(...) // ...
```

Note, that you must provide `.align(to: ...)` information, so `Framing` knows how to position frame horizontaly. The same applies to **left/right** positioning:
```swift
frame.putOnLeft(of: base).align(to: .top)
frame.putOnLeft(of: base).align(to: .bottom)
frame.putOnLeft(of: base).align(to: .middle)
frame.putOnRight(of: ...) // ...
```

This will return frame that is put **inside** `base` frame:
```swift
frame.putInside(base).align(to: .topLeft)
frame.putInside(base).align(to: .topCenter)
...
frame.putInside(base).align(to: .middleCenter) // centers `frame` inside `base`
...
```

Similary, `.align(to: ..)` information is needed to align edges of both frames.

This will divide frame into 5 columns and return 2nd column frame:
```swift
frame.divideIntoEqual(columns: 5).take(index: 1)
```

The same for rows:
```swift
frame.divideIntoEqual(rows: 5).take(index: 1)
```

---
Missing some API? Open a Pull Request or fill in the Issue.

## License

`Framing` is released under the MIT license. See the LICENSE file for more details.
