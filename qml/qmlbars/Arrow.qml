import QtQuick 2.0
Image {
    //id: image
    visible:false
    width:parent.width*0.8
    anchors.centerIn: parent
    fillMode: Image.PreserveAspectFit


    source: "redArrow.png"
//               antialiasing: true
    property alias rotationAngle: rotation.angle

    transform: Rotation {
               id: rotation
               origin { x: parent.width/2;
                        y: parent.height/2;
                        z: 0}
               angle: 0
           }
}
