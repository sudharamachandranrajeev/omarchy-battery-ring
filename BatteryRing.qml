import QtQuick
import qs.Commons

// Circular battery gauge for the bar: a faint full-circle track with an arc
// for the charge fraction, starting at twelve o'clock, and a small battery
// glyph in the middle so the ring reads as "battery" at a glance.
Item {
  id: root

  property real fraction: 0
  property bool charging: false
  property real lineWidth: 2
  property color trackColor: "#33ffffff"
  property color color: "white"
  property color glyphColor: color
  property string fontFamily: ""
  property real animatedFraction: fraction

  implicitWidth: Style.bar.iconCanvas
  implicitHeight: Style.bar.iconCanvas

  Behavior on animatedFraction {
    NumberAnimation { duration: Style.duration(240); easing.type: Easing.OutCubic }
  }

  Canvas {
    id: ring
    anchors.fill: parent
    antialiasing: true

    onPaint: {
      var ctx = getContext("2d")
      ctx.reset()

      var size = Math.min(width, height)
      var radius = (size - root.lineWidth) / 2
      var cx = width / 2
      var cy = height / 2
      var start = -Math.PI / 2
      var value = Math.max(0, Math.min(1, root.animatedFraction))

      ctx.lineWidth = root.lineWidth
      ctx.lineCap = "round"

      ctx.strokeStyle = root.trackColor
      ctx.beginPath()
      ctx.arc(cx, cy, radius, 0, Math.PI * 2, false)
      ctx.stroke()

      if (value <= 0) return
      ctx.strokeStyle = root.color
      ctx.beginPath()
      ctx.arc(cx, cy, radius, start, start + Math.PI * 2 * value, false)
      ctx.stroke()
    }
  }

  onAnimatedFractionChanged: ring.requestPaint()
  onColorChanged: ring.requestPaint()
  onTrackColorChanged: ring.requestPaint()
  onLineWidthChanged: ring.requestPaint()
  onWidthChanged: ring.requestPaint()
  onHeightChanged: ring.requestPaint()

  // Battery body (with a bolt while charging) inside the ring.
  Text {
    anchors.centerIn: parent
    textFormat: Text.PlainText
    text: root.charging ? "󰂄" : "󰁹"
    font.family: root.fontFamily
    font.pixelSize: Math.max(7, Math.round(Math.min(root.width, root.height) * 0.56))
    color: root.glyphColor
    renderType: Text.NativeRendering
  }
}
