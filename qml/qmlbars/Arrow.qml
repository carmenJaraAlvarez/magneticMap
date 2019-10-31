import QtQuick 2.0
Image {
    //id: image
    width:parent.width
    anchors.centerIn: parent
    fillMode: Image.PreserveAspectFit


    source: "redArrow.png"
//               antialiasing: true
    property alias rotationAngle: rotation.angle
    transform: Rotation {
               id: rotation
//               origin { x: this.sourceSize.width/2;
//                        y: this.sourceSize.height/2;
//                        z: 0}
               angle: 0
           }
}
