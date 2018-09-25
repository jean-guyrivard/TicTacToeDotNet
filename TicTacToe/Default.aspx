<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="TicTacToe.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <style type="text/css">
        .board {
            width: 640px;
            height: 640px;
            display: flex;
            flex-wrap: wrap;
        }
        .block {
            flex: 0 0 200px;
            border-width: 20px;
            border-color: blue;
            display: inline-block;
            position: relative;
            width: 300px;
            height: 300px;
        }

        .left {
            border-left-style: solid;
        }

        .right {
            border-right-style: solid;
        }

        .top {
            border-top-style: solid;
        }

        .bottom {
            border-bottom-style: solid;
        }

        .hidden { 
            display: none;
        }

        .menu {
            position: absolute;
            margin: auto;
            text-align: center;
            width: 500px;
            min-height: 50px;
            background-color: lightgray;
        }

        .menu_options {
            display: flex;
            justify-content: center;
            width: 100%;
        }

        .button {
            margin: 5px;
            padding: 5px;
            border: 1px solid #000000;
            border-radius: 3px;
            cursor: pointer;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/fingerprintjs2/1.8.1/fingerprint2.min.js"></script>
    <script>
        var gameId = "";
        var playerId = "";
        function playTurn(target) {
            console.log("Hit me " + target);
            $.post("api/game/play/" + gameId + "/" + playerId + "/" + target, function (data) {
                boards = document.getElementById("board").children;
                for (i = 0; i < data.GameBoard.length; i++) {
                    if (data.GameBoard[i].Player != 0) {
                        boards[i].innerHTML = data.GameBoard[i].Player == 1 ? "<img src=\"Assets/X.svg\" style=\"width: 100%\" />" : "<img src=\"Assets/O.svg\" style=\"width: 100%\" />";
                    } else {
                        boards[i].innerHTML = "";
                    }
                }
           });
        }

        function joinExisting() {
            document.getElementById('mainMenu').className='menu hidden';
            gameId = document.getElementById("gameid").value;

            document.getElementById("gameId").innerHTML = "Game ID: " + gameId;

            $.post("api/game/join/" + gameId + "/" + playerId, function (data) {
                boards = document.getElementById("board").children;
                for (i = 0; i < data.GameBoard.length; i++) {
                    if (data.GameBoard[i].Player != 0) {
                        boards[i].innerHTML = data.GameBoard[i].Player == 1 ? "<img src=\"Assets/X.svg\" style=\"width: 100%\" />" : "<img src=\"Assets/O.svg\" style=\"width: 100%\" />";
                    } else {
                        boards[i].innerHTML = "";
                    }
                }

                document.getElementById('joinExisting').className='menu hidden';
           });
        }

        function createNewGame() {
            $.post("api/game/create/" + playerId, function (data) {
                gameId = data.GameId;

                document.getElementById("gameId").innerHTML = "Game ID: " + gameId;

                document.getElementById('mainMenu').className='menu hidden';
           });
        }

        function refreshBoard() {
            if (gameId) {
                $.get("api/game/get/" + gameId, function (data) {
                    boards = document.getElementById("board").children;

                    if (data.GameStatus != 0) {
                        statusDiv = document.getElementById("gameStatus");

                        statusDiv.innerHTML = "Game won by " + (data.GameStatus == 1 ? "X" : "O");
                        statusDiv.className = "menu";
                    }

                    for (i = 0; i < data.GameBoard.length; i++) {
                        if (data.GameBoard[i].Player != 0) {
                            boards[i].innerHTML = data.GameBoard[i].Player == 1 ? "<img src=\"Assets/X.svg\" style=\"width: 100%\" />" : "<img src=\"Assets/O.svg\" style=\"width: 100%\" />";
                        } else {
                            boards[i].innerHTML = "";
                        }
                    }
                });
            }
        }

        function fixMenus() {
            $('.menu').css('left', $(document).width() / 2 - 250);
            $('.menu').each(function () {
                $(this).css('top', $(document).height() / 2 - $(this).height() / 2)
            });
        }

        if (window.requestIdleCallback) {
            requestIdleCallback(function () {
                new Fingerprint2().get(function(result, components) {
                    playerId = result;
                    console.log(playerId);
                })  
            })
        } else {
            setTimeout(function () {
                new Fingerprint2().get(function(result, components) {
                    playerId = result;
                    console.log(playerId);
                })  
            }, 500)
        }

        setInterval(function () {
            fixMenus();
            refreshBoard();            
        }, 1000);
    </script>
</head>
<body>
    <div id="gameId">Game ID: None</div>
    <div id="board" class="board">
        <div class="block bottom" onclick="playTurn(0)"></div>
        <div class="block left right bottom" onclick="playTurn(1)"></div>
        <div class="block bottom" onclick="playTurn(2)"></div>

        <div class="block bottom" onclick="playTurn(3)"></div>
        <div class="block left right bottom" onclick="playTurn(4)"></div>
        <div class="block bottom" onclick="playTurn(5)"></div>

        <div class="block" onclick="playTurn(6)"></div>
        <div class="block left right" onclick="playTurn(7)"></div>
        <div class="block" onclick="playTurn(8)"></div>
    </div>
    <div id="mainMenu" class="menu">
        <div class="menu_header">Create new game or join existing</div>
        <div class="menu_options">
            <div class="button" onclick="createNewGame()">Create New Game</div>
            <div class="button" onclick="document.getElementById('joinExisting').className='menu';">Join Existing</div>
        </div>
    </div>
    <div id="joinExisting" class="menu hidden">
        <div class="menu_header">Please type in the Game ID</div>
        <div class="menu_options">
            <input id="gameid" type="text" />
            <div class="button" onclick="joinExisting()">Join</div>
        </div>
    </div>
    <div id="gameStatus" class="menu hidden"></div>
    <script>
        fixMenus();
        refreshBoard();
    </script>
</body>
</html>
