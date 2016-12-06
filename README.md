<p align="center">
<img width="180" alt="framing-logo" src="https://cloud.githubusercontent.com/assets/2358722/20908023/2604621e-bb52-11e6-8616-456d85f4be77.png">
</p>

# Framing
Swifty approach to declarative view layouts.

## What is `Framing`?

`Framing` is a tiny, one-`struct` framework for defining `CGRect` frames in more declarative way. Look:

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

<p align="center">
<img width="300" alt="framing-logo-framed" src="https://cloud.githubusercontent.com/assets/2358722/20908037/377e563a-bb52-11e6-8822-20788d21b311.png">
</p>

## What `Framing` is not?
It's not an animal :pig: or UI framework. It doesn't import `UIKit` anywhere.

## License

`Framing` is released under the MIT license.
