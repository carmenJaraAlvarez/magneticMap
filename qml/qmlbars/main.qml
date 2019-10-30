/****************************************************************************
**
** This file is based on the Qt Data Visualization module of the Qt Toolkit.
**
**
****************************************************************************/

import "componentCreation.js" as MyScript
import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtDataVisualization 1.1
import QtQuick.Window 2.0
import "."
import QtSensors 5.2

import QtQuick 2.6

import QtQuick.Window 2.1

import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1

Rectangle {
    id: mainview
    width: 1280
    height: 1024
    property int myIndex: 0

    property int buttonLayoutHeight: 180;
    state: Screen.width < Screen.height ? "portrait" : "landscape"
    Data {
        id: graphData
        Component.onCompleted: {

            console.log("addData Completed");

        }
        }

    Magnet {
        id: localMag
        returnGeoValues : false
        //The primary difference between raw and geomagnetic values is
        //that extra processing is done to eliminate local magnetic interference
        //from the geomagnetic values so they represent only the effect of the Earth's magnetic field.

        onReadingChanged: {

            //The accuracy of each reading is measured as a number from 0 to 1.
            //A value of 1 is the highest level that the device can support and 0 is the worst
 //           console.log("Local:",localMag.reading.x, ",", localMag.reading.y, ",", localMag.reading.z);

        }
    }
        Magnet {
            id: geoMag
            returnGeoValues : true
            //The primary difference between raw and geomagnetic values is
            //that extra processing is done to eliminate local magnetic interference
            //from the geomagnetic values so they represent only the effect of the Earth's magnetic field.

            onReadingChanged: {

                //The accuracy of each reading is measured as a number from 0 to 1.
                //A value of 1 is the highest level that the device can support and 0 is the worst
               // console.log("Geo:",geoMag.reading.x, ",", geoMag.reading.y, ",", geoMag.reading.z);
               //TIMER TODO
//                var geoVector = Qt.vector3d(geoMag.reading.x, geoMag.reading.y, geoMag.reading.z);
//                var localVector = Qt.vector3d(localMag.reading.x, localMag.reading.y, localMag.reading.z);
//                var anomalyVector = geoVector.minus(localVector);


//                graphData.addData(myIndex, anomalyVector);
//                myIndex+=1;
 //               console.log("***********Index:Anomaly->", myIndex,":",anomalyVector.toString());
            }
    }
//        Acceler{
//             id: myAccel

//             onReadingChanged: {

//                     console.log("Acel:",myAccel.reading.x, ",", myAccel.reading.y, ",", myAccel.reading.z);

//                 }
//         }



    Axes {
        id: graphAxes
    }

    property Bar3DSeries selectedSeries
    selectedSeries: barSeries

    function handleSelectionChange(series, position) {
        if (position != series.invalidSelectionPosition) {
            selectedSeries = series
        }

        // Set tableView current row to selected bar
        var rowRole = series.dataProxy.rowLabels[position.x];
        var colRole
        if (barGraph.columnAxis === graphAxes.total)
            colRole = "01";
        else
            colRole = series.dataProxy.columnLabels[position.y];
        var checkTimestamp = rowRole + "-" + colRole
        var currentRow = tableView.currentRow
        if (currentRow === -1 || checkTimestamp !== graphData.model.get(currentRow).timestamp) {
            var totalRows = tableView.rowCount;
            for (var i = 0; i < totalRows; i++) {
                var modelTimestamp = graphData.model.get(i).timestamp
                if (modelTimestamp === checkTimestamp) {
                    tableView.currentRow = i
                    // Workaround to 5.2 row selection issue
                    if (typeof tableView.selection != "undefined") {
                        tableView.selection.clear()
                        tableView.selection.select(i)
                    }
                    break
                }
            }
        }
    }

    Item {
        id: dataView
        anchors.right: mainview.right;
        anchors.bottom: mainview.bottom
        Flickable {
            id: flick
            anchors.fill: parent
            contentWidth: width * 0.9
            contentHeight: height * 0.9

        Rectangle {
            id: photoFrame
            visible:false
            anchors.centerIn: parent
            width: image.width * (1 + 0.10 * image.height / image.width)
            height: image.height * 1.10
            scale: 600 / Math.max(image.sourceSize.width, image.sourceSize.height)
            Behavior on scale { NumberAnimation { duration: 200 } }
            Behavior on x { NumberAnimation { duration: 200 } }
            Behavior on y { NumberAnimation { duration: 200 } }
            border.color: "black"
            border.width: 2
//            antialiasing: true


            Image {
                id: image
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit


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
                            PinchArea {
                                anchors.fill: parent
                                pinch.target: photoFrame
                                pinch.minimumRotation: -360
                                pinch.maximumRotation: 360
                                pinch.minimumScale: 0.1
                                pinch.maximumScale: 10
                                pinch.dragAxis: Pinch.XAndYAxis

                                property real zRestore: 0
                                onSmartZoom: {
                                    if (pinch.scale > 0) {
                                        photoFrame.rotation = 0;
                                        photoFrame.scale = Math.min(root.width, root.height) / Math.max(image.sourceSize.width, image.sourceSize.height) * 0.85
                                        photoFrame.x = flick.contentX + (flick.width - photoFrame.width) / 2
                                        photoFrame.y = flick.contentY + (flick.height - photoFrame.height) / 2


                                    } else {
                                        photoFrame.rotation = pinch.previousAngle
                                        photoFrame.scale = pinch.previousScale
                                        photoFrame.x = pinch.previousCenter.x - photoFrame.width / 2
                                        photoFrame.y = pinch.previousCenter.y - photoFrame.height / 2


                                    }
                                }
                                onPinchUpdated: {
                                    if(pinch.angle>10 ){
                                        root.userRotated=true;
                                    }
                                }
                            }
        }
   }
        Bars3D {
            id: barGraph
            width: dataView.width
            height: dataView.height
            shadowQuality: AbstractGraph3D.ShadowQualityMedium
            selectionMode: AbstractGraph3D.SelectionItem
            theme: Theme3D {
                //type: Theme3D.ThemeRetro
                type:Theme3D.ThemeIsabelle
                labelBorderEnabled: true
                font.pointSize: 35
                labelBackgroundEnabled: true
                colorStyle: Theme3D.ColorStyleRangeGradient
                singleHighlightGradient: customGradient

                ColorGradient {
                    id: customGradient
                    ColorGradientStop { position: 1.0; color: "#FFFF00" }
                    ColorGradientStop { position: 0.0; color: "#808000" }
                }
            }
            barThickness: 0.7
            barSpacing: Qt.size(0.5, 0.5)
            barSpacingRelative: false
            scene.activeCamera.cameraPreset: Camera3D.CameraPresetIsometricLeftHigh
            columnAxis: graphAxes.column
            rowAxis: graphAxes.row
            valueAxis: graphAxes.value

            //! [4]
            Bar3DSeries {
                id: secondarySeries
                visible: false
                itemLabelFormat: "Expenses, @colLabel, @rowLabel: -@valueLabel"
                baseGradient: secondaryGradient

                ItemModelBarDataProxy {
                    id: secondaryProxy
                    itemModel: graphData.model
                    rowRole: "coordenates"
                    columnRole: "coordenates"
                    valueRole: "direction"
                    rowRolePattern: /^(\d).*$/
                    columnRolePattern: /^.*-(\d)$/
                    valueRolePattern: /-/
                    rowRoleReplace: "\\1"
                    columnRoleReplace: "\\1"
                    multiMatchBehavior: ItemModelBarDataProxy.MMBCumulative
                }
                //! [4]

                ColorGradient {
                    id: secondaryGradient
                    ColorGradientStop { position: 1.0; color: "#FF0000" }
                    ColorGradientStop { position: 0.0; color: "#600000" }
                }

                onSelectedBarChanged: handleSelectionChange(secondarySeries, position)
            }

            //! [3]
            Bar3DSeries {
                id: barSeries
                itemLabelFormat: "Mags, @colLabel, @rowLabel: @valueLabel"
                baseGradient: barGradient

                ItemModelBarDataProxy {
                    id: modelProxy
                    itemModel: graphData.model
                    rowRole: "coordenates"
                    columnRole: "coordenates"
                    valueRole: "mags"
                    rowRolePattern: /^(\d).*$/
                    columnRolePattern: /^.*-(\d)$/
                    rowRoleReplace: "\\1"
                    columnRoleReplace: "\\1"
                    multiMatchBehavior: ItemModelBarDataProxy.MMBCumulative
                }
                //! [3]

                ColorGradient {
                    id: barGradient
                    ColorGradientStop { position: 1.0; color: "#00FF00" }
                    ColorGradientStop { position: 0.0; color: "#006000" }
                }

                onSelectedBarChanged: handleSelectionChange(barSeries, position)
            }
        }
    }

    TableView {
        id: tableView
        anchors.top: parent.top
        anchors.left: parent.left
        TableViewColumn{ role: "coordenates" ; title: "Latitude" ; width: tableView.width / 2 }
        TableViewColumn{ role: "direction" ; title: "Direction" ; width: tableView.width / 4 }
        TableViewColumn{ role: "mags" ; title: "Magnet" ; width: tableView.width / 4 }
        itemDelegate: Item {
            Text {
                id: delegateText
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                anchors.leftMargin: 4
                anchors.left: parent.left
                anchors.right: parent.right
                color: styleData.textColor
                elide: styleData.elideMode
                text: customText
                horizontalAlignment: styleData.textAlignment
                property string originalText

 //                   originalText: styleData.value

                property string customText

                onOriginalTextChanged: {
                    if (styleData.column === 0) {
                        if (delegateText.originalText !== "") {
                            var pattern = /(\d)-(\d)/
                            var matches = pattern.exec(delegateText.originalText)
                            var colIndex = parseInt(matches[2], 10) - 1
                            delegateText.customText = matches[1] + " - " + graphAxes.column.labels[colIndex]
                        }
                    } else {
                        delegateText.customText = originalText
                    }
                }
            }
        }

        model: graphData.model

        //! [2]
        onCurrentRowChanged: {
            var timestamp = graphData.model.get(currentRow).timestamp
            var pattern = /(\d)-(\d)/
            var matches = pattern.exec(coordenates)
            var rowIndex = modelProxy.rowCategoryIndex(matches[1])
            var colIndex
            if (barGraph.columnAxis === graphAxes.total)
                colIndex = 0 // Just one column when showing yearly totals
            else
                colIndex = modelProxy.columnCategoryIndex(matches[2])
            if (selectedSeries.visible)
                mainview.selectedSeries.selectedBar = Qt.point(rowIndex, colIndex)
            else if (barSeries.visible)
                barSeries.selectedBar = Qt.point(rowIndex, colIndex)
            else
                secondarySeries.selectedBar = Qt.point(rowIndex, colIndex)
        }
        //! [2]
    }

    ColumnLayout {
        id: controlLayout
        spacing: 0

        Button {
            id: changeDataButton
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "Read"
//            text: "Show 2010 - 2012"
//            clip: true
//            //! [1]
            onClicked: {

//                geoMag.start();
//                localMag.start();

                var geoVector = Qt.vector3d(geoMag.reading.x, geoMag.reading.y, geoMag.reading.z);
                var localVector = Qt.vector3d(localMag.reading.x, localMag.reading.y, localMag.reading.z);

                console.log("Local:",localMag.reading.x, ",", localMag.reading.y, ",", localMag.reading.z);
                console.log("Geo:",geoMag.reading.x, ",", geoMag.reading.y, ",", geoMag.reading.z);

                var anomalyVector = geoVector.minus(localVector);
                console.log("Anomaly:",anomalyVector);

                graphData.addData(myIndex, localVector);
                myIndex+=1;

//                geoMag.stop();
//                localMag.stop();
//                if (text === "Show yearly totals") {
//                    modelProxy.autoRowCategories = true
//                    secondaryProxy.autoRowCategories = true
//                    modelProxy.columnRolePattern = /^.*$/
//                    secondaryProxy.columnRolePattern = /^.*$/
//                    graphAxes.value.autoAdjustRange = true
//                    barGraph.columnAxis = graphAxes.total
//                    text = "Show all years"
//                } else if (text === "Show all years") {
//                    modelProxy.autoRowCategories = true
//                    secondaryProxy.autoRowCategories = true
//                    modelProxy.columnRolePattern = /^.*-(\d\d)$/
//                    secondaryProxy.columnRolePattern = /^.*-(\d\d)$/
//                    graphAxes.value.min = 0
//                    graphAxes.value.max = 35
//                    barGraph.columnAxis = graphAxes.column
//                    text = "Show 2010 - 2012"
//                } else { // text === "Show 2010 - 2012"
//                    // Explicitly defining row categories, since we do not want to show data for
//                    // all years in the model, just for the selected ones.
//                    modelProxy.autoRowCategories = false
//                    secondaryProxy.autoRowCategories = false
//                    modelProxy.rowCategories = ["2010", "2011", "2012"]
//                    secondaryProxy.rowCategories = ["2010", "2011", "2012"]
//                    text = "Show yearly totals"
//                }
            }
            //! [1]
        }

//        Button {
//            id: shadowToggle
//            Layout.fillWidth: true
//            Layout.fillHeight: true
//            text: barGraph.shadowsSupported ? "Hide Shadows" : "Shadows not supported"
//            clip: true
//            enabled: barGraph.shadowsSupported
//            onClicked: {
//                if (barGraph.shadowQuality == AbstractGraph3D.ShadowQualityNone) {
//                    barGraph.shadowQuality = AbstractGraph3D.ShadowQualityMedium;
//                    text = "Hide Shadows"
//                } else {
//                    barGraph.shadowQuality = AbstractGraph3D.ShadowQualityNone;
//                    text = "Show Shadows"
//                }
//            }
//        }

        Button {
            id: seriesToggle
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "Show Direction"
            clip: true
            //! [0]
            onClicked: {
                if (text === "Show Direction") {
                    barSeries.visible = false
                    barGraph.visible = false

                    //*****************************************
//                    secondarySeries.visible = true
//                    barGraph.valueAxis.labelFormat = "-%.2f M\u20AC"

//                    secondarySeries.itemLabelFormat = "Direction, @colLabel, @rowLabel: @valueLabel"

                    photoFrame.visible=true;

//                    text = "Show Both"
//                } else if (text === "Show Both") {
//                    barSeries.visible = true
//                    barGraph.valueAxis.labelFormat = "%.2f M\u20AC"
//                    secondarySeries.itemLabelFormat = "Direction, @colLabel, @rowLabel: -@valueLabel"
                    text = "Show Magnet"
                } else { // text === "Show Magnet"
                    barSeries.visible = true
                    barGraph.visible = true
                    photoFrame.visible = false
                    text = "Show Direction"
                }
            }
            //! [0]
        }
    }

    states: [
        State  {
            name: "landscape"
            PropertyChanges {
                target: dataView
                width: mainview.width / 4 * 3
                height: mainview.height
            }
            PropertyChanges  {
                target: tableView
                height: mainview.height - buttonLayoutHeight
                anchors.right: dataView.left
                anchors.left: mainview.left
                anchors.bottom: undefined
            }
            PropertyChanges  {
                target: controlLayout
                width: mainview.width / 4
                height: buttonLayoutHeight
                anchors.top: tableView.bottom
                anchors.bottom: mainview.bottom
                anchors.left: mainview.left
                anchors.right: dataView.left
            }
        },
        State  {
            name: "portrait"
            PropertyChanges {
                target: dataView
                width: mainview.height / 4 * 3
                height: mainview.width
            }
            PropertyChanges  {
                target: tableView
                height: mainview.width
                anchors.right: controlLayout.left
                anchors.left: mainview.left
                anchors.bottom: dataView.top
            }
            PropertyChanges  {
                target: controlLayout
                width: mainview.height / 4
                height: mainview.width / 4
                anchors.top: mainview.top
                anchors.bottom: dataView.top
                anchors.left: undefined
                anchors.right: mainview.right
            }
        }
    ]
}
