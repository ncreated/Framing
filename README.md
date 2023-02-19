<p align="center">
<img width="180" alt="framing-logo" src="https://cloud.githubusercontent.com/assets/2358722/20908023/2604621e-bb52-11e6-8616-456d85f4be77.png">
</p>

# Framer

<p align="center">
<img width="300" alt="framer screenshot" src="https://user-images.githubusercontent.com/2358722/219977900-629bad4a-ecaa-4665-ac7f-b19361ed71cb.png">
</p>

```swift
import SwiftUI
import Framer

struct HelloFramerView: View {
    init() {
        FramerWindow.install(startHidden: false)
    }

    var body: some View {
        ZStack {
            Color("FCFFE7")
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                Text("Framer")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(Color("EB455F"))
                    .frameIt("Title")
                Text("What is Framer?")
                    .font(.headline)
                    .frameIt("Headline")
                Text("Framer is a basic canvas for drawing \"blueprints\" on. It can be rendered to standalone image or displayed in overlay window.")
                    .font(.body)
                    .frameIt("Body")
                HStack {
                    Spacer()
                    .frameIt("Spacer")
                    Image(systemName: "photo.artframe")
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 40, maxHeight: 40)
                        .foregroundColor(Color("2B3467"))
                }
            }
            .frameIt(
                "VStack",
                 frameStyle: .init(lineColor: .blue),
                 annotationStyle: .init(position: .bottom, alignment: .center)
            )
            .padding(40)
            .fontDesign(.monospaced)
        }
    }
}
```

# Framing
Swifty approach to defining frame layouts.

## What is `Framing`?

`Framing` is a tiny framework for defining view frames in more Swifty way. Think of it as a simple wrapper over `CGRect` that can save you time spend on math calculations when positioning view frames. Look:

```swift
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
```

Every `Frame` provides `.rect` property that returns `CGRect` for `UIView`.
e.g. `greenView.frame = bottomLine2.rect`

<p align="center">
<img width="300" alt="framing-logo-framed" src="https://cloud.githubusercontent.com/assets/2358722/20908037/377e563a-bb52-11e6-8822-20788d21b311.png">
</p>

## What `Framing` is not?
It's not an animal :pig: or UI / Layout framework. It doesn't import `UIKit` anywhere.

## What you can do with `Framing`?
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
frame.putAbove(base, alignTo: .left)
frame.putAbove(base, alignTo: .right)
frame.putAbove(base, alignTo: .center)
frame.putBelow(..., alignTo: ...) // ...
```

The same for **left/right** positioning:
```swift
frame.putOnLeft(of: base, alignTo: .top)
frame.putOnLeft(of: base, alignTo: .bottom)
frame.putOnLeft(of: base, alignTo: .middle)
frame.putOnRight(of: ..., alignTo: ...) // ...
```

This will return frame that is put **inside** `base` frame:
```swift
frame.putInside(base, alignTo: .topLeft)
frame.putInside(base, alignTo: .topCenter)
...
frame.putInside(base, alignTo: .middleCenter) // centers `frame` inside `base`
...
```

This will divide frame into 5 columns and return 2nd column frame:
```swift
frame.divideIntoEqual(columns: 5, take: 1)
```

The same for rows:
```swift
frame.divideIntoEqual(rows: 5, take: 1)
```

It's possible to apply transforms conditionally using only `Framing` api:
```swift
let shouldBeOffsetted: Bool = ...
frame.if(condition: shouldBeOffsetted,
         then: { $0.offsetBy(x: 10).inset(top: 5) },
         else: { $0.inset(top: 5) })
         
// Or simpler:
frame.inset(top: 5)
     .if(shouldBeOffsetted) { $0.offsetBy(x: 10) }
```

---
Missing some API? Open a Pull Request or fill in the Issue.

## `Framing` is still in development
This library is still in development, so incompatible API changes are possible until it reaches `1.0.0`.

## License

`Framing` is released under the MIT license. See the LICENSE file for more details.
