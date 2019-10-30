.import QtQuick 2.0 as QtQuickModuleImportedInJS
.import QtPositioning 5.13 as QtPositioningModuleImportedInJS
var componentArrow

//*************Arrow*********************************
function createArrowObjects(ang) {
    componentCircle = Qt.createComponent("Arrow.qml");
    if (componentCircle.status == QtQuickModuleImportedInJS.Component.Ready)
        finishCreation(ang);
    else
        componentCircle.statusChanged.connect(finishCreation);

}

function finishCreation(ang) {
    if (componentCircle.status == QtQuickModuleImportedInJS.Component.Ready) {
        //sprite = component.createObject(map, {"marker.coordinate": map.toCoordinate(Qt.point(posX,posY))});
       var arrowAng=ang;

        newArrow = componentArrow.createObject();
        //mapcircle.center= QtPositioningModuleImportedInJS.QtPositioning.coordinate(coordX, coordY);
        //mapOverlay.addMapItem(mapcircle);
        console.log("Object arrow Created ");

        if (newArrow == null) {
            console.log("Error creating arrow Object");
        }
    }
    else if (componentArrow.status == QtQuickModuleImportedInJS.Component.Error) {
        console.log("Error loading component arrow:", componentArrow.errorString());
    }
}
//****************room*********************************
function createRoomObjects(listX,listY) {
    console.log("in second js receiving: "+listX[0]);
    componentRoom = Qt.createComponent("mapRoom.qml");
    if (componentRoom.status == QtQuickModuleImportedInJS.Component.Ready)
        finishCreationRoom(listX,listY);
    else
        componentRoom.statusChanged.connect(finishCreationRoom);


}

function finishCreationRoom(listX,listY) {
        console.log("in second js second method receiving: "+listX[0]);
//    if (componentRoom.status == QtQuickModuleImportedInJS.Component.Ready) {
//        mapRoom = componentRoom.createObject(mapOverlay);
//       //mapRoom.name=room1;
//       var numPoints=listX.length;
//       var path=[];
//        for(var i=0;i<numPoints;i++){
//           path[i]=QtPositioningModuleImportedInJS.QtPositioning.coordinate(listX[i], listY[i]);
//         }
//         mapRoom.path=path;
////       mapRoom.path= [
////                    { latitude: 37.362, longitude: -5.98 },
////                    { latitude: 37.363, longitude: -5.981 },
////                    { latitude: 37.362, longitude: -5.981 }
////                ];
//        mapOverlay.addMapItem(mapRoom);
//        console.log("Object mapRoom Created ");

//        if (mapRoom == null) {
//            console.log("Error creating mapRoom Object");
//        }
//    }
//    else if (componentRoom.status == QtQuickModuleImportedInJS.Component.Error) {
//        console.log("Error loading component:", componentRoom.errorString());
//    }
}
