import QtQuick 2.4
import Qt.labs.settings 1.0

Rectangle {
    id: screen
    width: 400; height: 500; color: "black"
    property bool animIsRunning: false
    property int noRowCol: 4
    property int border: 20
    property int currentGameTime: 0

    Settings {
        id: settings
        category: "GameMode"
        property alias gameMode: screen.noRowCol
    }

    TitleBar {
        id: titleBar
        height: 52
        anchors.top: parent.top
        anchors.topMargin: -1
        anchors.left: parent.left
        anchors.leftMargin: -1
        anchors.right: parent.right
        anchors.rightMargin: -1

        borderWidth: screen.border

        onNewButtonClicked: {
            rankingList.visible = false;
            finalItem.visible = false;
            shuffleTiles();
            gameTimer.restart()
            screen.currentGameTime = 0
            timeLabel.text = qsTr("Time") + ": 00" + qsTr("h") + " 00" + qsTr("min") + " 00" + qsTr("s")
        }

        onPauseButtonClicked: {
            if(gameTimer.running) {
                gameTimer.stop()
                titleBar.pauseButtonText = qsTr("Play")
            }
            else {
                gameTimer.start()
                titleBar.pauseButtonText = qsTr("Pause")
            }
        }

        onGameModeChanged: {
            finalItem.visible=false;
            gameTimer.stop();
            timeLabel.text = qsTr("Time") + ": 00" + qsTr("h") + " 00" + qsTr("min") + " 00" + qsTr("s")
            screen.noRowCol = Math.floor(mode);
            rep.model = (screen.noRowCol*screen.noRowCol)-1;
        }
    }

    RankingList {
        id: rankingList
        anchors{ left: parent.left; right: parent.right; top: titleBar.bottom; bottom: parent.bottom }

        onVisibleChanged: timeLabel.visible = !rankingList.visible
    }

    Text {
        id: timeLabel
        text: qsTr("Time") + ": 00" + qsTr("h") + " 00" + qsTr("min") + " 00" + qsTr("s")
        color: "white"
        anchors.top: titleBar.bottom
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 5
        visible: false
        z:0

        Timer {
            id: gameTimer
            interval: 100
            repeat: true
            onTriggered: {
                currentGameTime += 100;
                timeLabel.text = qsTr("Time") + ": " + formatTime(currentGameTime);
                qsTr("Time") + ": 00" + qsTr("h") + " 00" + qsTr("min") + " 00" + qsTr("s")
            }

            function formatTime(time) {
                var ret;
                var tmp;
                time = Math.floor(time / 1000);

                tmp = (time % 60);
                if(tmp < 10)
                    tmp = "0" + tmp
                ret = tmp + qsTr("s") + " ";

                time = Math.floor(time / 60);
                tmp = time % 60;
                if(tmp < 10)
                    tmp = "0" + tmp
                ret = tmp + qsTr("min") + " " + ret;

                time = Math.floor(time / 60);
                tmp = time % 60;
                if(tmp < 10)
                    tmp = "0" + tmp
                ret = tmp + qsTr("h") + " " + ret;

                return ret;
            } // function
        } // gameTimer
    } // Text timeLabel


    Rectangle {
        id: gridBackground
        color: "gray"
        anchors.fill: boardGrid
    }

    Grid {
        id: boardGrid
            anchors.bottom : screen.bottom
            anchors.bottomMargin: screen.border
            anchors.horizontalCenter: screen.horizontalCenter
        rows: screen.noRowCol
        columns: screen.noRowCol
        spacing: 4

        Repeater {
            id: rep
            model: (screen.noRowCol*screen.noRowCol)-1

            Tile {
                id: tile
                tileId: index+1
                width: (screen.width-2*screen.border-(screen.noRowCol-1)*boardGrid.spacing) / screen.noRowCol
                height: width

                onTileClicked: {
                    if(!animIsRunning && gameTimer.running) {
                       canWeMoveTheRect(tile)
                    }
                }

                Behavior on x {
                    NumberAnimation {
                        //This specifies how long the animation takes
                        duration: 300
                        //This selects an easing curve to interpolate with, the default is Easing.Linear
                        easing.type: Easing.OutExpo
                        alwaysRunToEnd: true

                        onRunningChanged: {
                            animIsRunning = running

                            if(!running) {
                                if(verifyIfSolved()) {
                                    gameTimer.stop();
                                    titleBar.pauseButtonEnabled = false;
                                    finalItem.visible = true;
                                    var showNewEntryDialog = myModel.checkIfEntryWillBeSaved( currentGameTime,  screen.noRowCol )
                                 }
                            }
                        }
                    }
                }

                Behavior on y {
                    NumberAnimation {
                        //This specifies how long the animation takes
                        duration: 300
                        //This selects an easing curve to interpolate with, the default is Easing.Linear
                        easing.type: Easing.OutExpo
                        alwaysRunToEnd: true

                        onRunningChanged: {
                            animIsRunning = running

                            if(!running) {
                                if(verifyIfSolved()) {
                                    gameTimer.stop();
                                    titleBar.pauseButtonEnabled = false;
                                    finalItem.visible = true;
                                    var showNewEntryDialog = myModel.checkIfEntryWillBeSaved( currentGameTime,  screen.noRowCol )
                                 }
                            }
                        }
                    }
                } // Behavior on y
            } // Tile
        } // Repeater
    } // Grid

    FinalItem {
        id: finalItem
        anchors.top: titleBar.bottom
        anchors.topMargin: 20
        anchors.bottom: screen.bottom
        anchors.right: screen.right
        anchors.left: screen.left
    }

//////////////////////////////////////////
// Javascript function for the game logic
//////////////////////////////////////////

    function canWeMoveTheRect(object) {
        // Can we drag it left
        var moveIsPossible = 0
        var checkPosX = object.x - object.width/2
        var checkPosY = object.y + object.height/2

        if(boardGrid.childAt(checkPosX, checkPosY) === null) {
            if(checkPosX > 0) {
                  object.x -= (object.width + boardGrid.spacing)
                  moveIsPossible = 1
            }
        }


        // Can we drag it right
        checkPosX = object.x + (3*object.width)/2
        if(boardGrid.childAt(checkPosX, checkPosY) === null) {
            if(checkPosX < boardGrid.width) {
                object.x += (object.width + boardGrid.spacing)
                moveIsPossible = 1
            }
        }


        // Can we drag it up
        checkPosX = object.x + object.width/2
        checkPosY = object.y - object.height/2
        if(boardGrid.childAt(checkPosX, checkPosY) === null) {
            if(checkPosY > 0) {
                object.y -= (object.height+boardGrid.spacing)
                moveIsPossible = 1
            }
        }


        // Can we drag it down
        checkPosY = object.y + (3*object.height)/2
        if(boardGrid.childAt(checkPosX, checkPosY) === null) {
            if(checkPosY < boardGrid.height) {
                object.y += (object.height + boardGrid.spacing)
                moveIsPossible = 1
            }
        }

        return moveIsPossible
    }


    function verifyIfSolved() {
        var solved    = 1;
        var tileWidth = (screen.width-2*screen.border)/screen.noRowCol;
        var tile, x = 0, y = 0;

        for(var i=0; i<boardGrid.rows; ++i) {
            for(var j=0; j<boardGrid.columns; ++j) {
                x = j*tileWidth+boardGrid.spacing;
                y = i*tileWidth+boardGrid.spacing;
                tile = boardGrid.childAt(x, y);

                if(tile) {
                    if(tile.tileId-1 !== (j+i*boardGrid.columns)) {
                        solved = 0;
                        break;
                    }
                }
            }
        }

        return solved;
    }


    function shuffle() {
        var myArray = [];
        for(var i = 0; i < screen.noRowCol*screen.noRowCol; ++i)
            myArray[i] = i;

        var counter = myArray.length, temp, index;

        // While there are elements in the array
        while (counter > 0) {
            // Pick a random index
            index = Math.floor(Math.random() * counter);

            // Decrease counter by 1
            counter--;

            // And swap the last element with it
            temp = myArray[counter];
            myArray[counter] = myArray[index];
            myArray[index] = temp;
        }

        return myArray;
    }


    function getInvCount(arr) {
        var inv_count = 0;
        var i, j, n = arr.length;

        for(i = 0; i < n - 1; ++i)
            for(j = i+1; j < n; ++j)
                if(arr[i] > arr[j] && arr[i] !== 0 && arr[j] !== 0)
                    ++inv_count;

        return inv_count;
    }


    function getBlankPosFromBack(arr) {
        var blankPos = 0;
        for(var i = 0; i < arr.length; ++i) {
            if(arr[i] === 0) {
                blankPos = i;
                break;
            }
        }
        return (arr.length - blankPos - 1);
    }


    function swapLastTwoTiles(arr) {
        var lastTilePos = 0;
        var prevLastTilePos = 0;
        var tmp = 0;

        for(var i=0; i< arr.length; ++i) {
            if(arr[i]===arr.length-1)
                lastTilePos = i;
            if(arr[i]===arr.length-2)
                prevLastTilePos = i;
        }
        tmp = arr[prevLastTilePos];
        arr[prevLastTilePos] = arr[lastTilePos];
        arr[lastTilePos] = tmp;

        return arr;
    }


    function shuffleTiles() {
        var tileArray = [];

        if(screen.noRowCol%2) { // If the grid width is odd, then the number of inversion must be evan for a solvable game
            do {
                tileArray = shuffle();
            }while(getInvCount(tileArray) % 2 !== 0);
        }
        else { // If the grid width is even the solvability depends on the position of the blank
               // Odd inversion when the blank is on an even numbered row counting from the bottom
               // Even inversion when the blank is on an odd numbered row counting from the bottom
            tileArray = shuffle();
            var inversion = getInvCount(tileArray);
            var blankPos  = getBlankPosFromBack(tileArray);
            var blankRow  = Math.floor((blankPos+screen.noRowCol)/screen.noRowCol) // In which row is the blank

            if(inversion%2 === blankRow%2) // If the combo is odd/odd or evan/evan than the game is not solvabel
                tileArray = swapLastTwoTiles(tileArray);
        }

        var rowCount = 0;
        var childId  = 0;
        for(var i=0; i<tileArray.length; ++i) {
            if(i!==0 && i%screen.noRowCol === 0)
                ++rowCount;

            childId = tileArray[i]-1;
            if(childId >= 0) {
                var tile = boardGrid.children[childId];
                tile.x = (i-rowCount*screen.noRowCol)*(tile.width+boardGrid.spacing);
                tile.y = rowCount*(tile.height+boardGrid.spacing);
            }
        }
    }

//    MouseArea {
//        anchors.fill: parent
//        onClicked:  {
//            var bla = myModel.checkIfEntryWillBeSaved( 2147483648, 5 )
//            console.log("Bla: " + bla);
//        }
//    }

    onVisibleChanged: {
        finalItem.visible = false
        rep.model = (settings.gameMode>=3&&settings.gameMode<=6) ? settings.gameMode : 3
    }
} // Rectangle screen
