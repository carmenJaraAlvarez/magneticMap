import QtQuick 2.0
Image {
    id: image
    anchors.centerIn: parent
    fillMode: Image.PreserveAspectFit
    width: parent.width/10

    source: "redArrow.png"
//               antialiasing: true
    property alias rotationAngle: rotation.angle
    transform: Rotation {
               id: rotation
               origin { x: image.sourceSize.width/2;
                        y: image.sourceSize.height/2;
                        z: 0}
               angle: 0
           }
}
