import Framer

let redFrameStyle = BlueprintFrameStyle(
    lineWidth: 2, lineColor: .red, fillColor: .white, cornerRadius: 10, opacity: 1
)
let greenFrameStyle = BlueprintFrameStyle(
    lineWidth: 2, lineColor: .green, fillColor: .white, cornerRadius: 5, opacity: 0.75
)
let blueFrameStyle = BlueprintFrameStyle(
    lineWidth: 2, lineColor: .blue, fillColor: .white, cornerRadius: 2, opacity: 0.5
)

let redFrameContent = BlueprintFrameContent(
    text: "Frame (red)", textColor: .red, font: .systemFont(ofSize: 20)
)
let greenFrameContent = BlueprintFrameContent(
    text: "Frame (green)", textColor: .green, font: .systemFont(ofSize: 15)
)
let blueFrameContent = BlueprintFrameContent(
    text: "Frame (blue)", textColor: .blue, font: .systemFont(ofSize: 10)
)
