using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.IO;

namespace TicTacToe.Controllers
{
    [RoutePrefix("api/game")]
    public class GameController : ApiController
    {
        String[] gameTiles;
        int gameStatus = 0;

        [Route("create/{userid}")]
        [HttpPost]
        public Models.GameModel CreateGame(String userid)
        {
            String gameId = Guid.NewGuid().ToString();

            LoadFile(gameId);
            gameTiles[0] = userid;
            SaveFile(gameId);

            return new Models.GameModel{ GameId = gameId };
        }

        [Route("join/{gameid}/{userid}")]
        [HttpPost]
        public Models.GameStatusModel JoinGame(String gameid, String userid)
        {
            LoadFile(gameid);

            if (gameTiles[0] == "")
            {
                gameTiles[0] = userid;
                SaveFile(gameid);
            }
            else if (gameTiles[1] == "")
            {
                gameTiles[1] = userid;
                SaveFile(gameid);
            }

            return BuildGameStatus();
        }

        [Route("get/{gameid}")]
        public Models.GameStatusModel GetBoard(String gameid)
        {
            LoadFile(gameid);

            BuildBoard();

            return BuildGameStatus();
        }

        [Route("play/{gameid}/{player}/{target:int}")]
        [HttpPost]
        public Models.GameStatusModel PlayTurn(String gameid, String player, int target)
        {
            LoadFile(gameid);

            SetPlay(target, player);

            SaveFile(gameid);

            return BuildGameStatus();
        }

        private void ValidateGame()
        {
            if (gameTiles[2] != "0" && new[] { gameTiles[2], gameTiles[3], gameTiles[4] }.Distinct().Count() == 1)
            {
                gameStatus = Int16.Parse(gameTiles[2]);
            }
            else if (gameTiles[5] != "0" && new[] { gameTiles[5], gameTiles[6], gameTiles[7] }.Distinct().Count() == 1)
            {
                gameStatus = Int16.Parse(gameTiles[5]);
            }
            else if (gameTiles[8] != "0" && new[] { gameTiles[8], gameTiles[9], gameTiles[10] }.Distinct().Count() == 1)
            {
                gameStatus = Int16.Parse(gameTiles[8]);
            }
            else if (gameTiles[2] != "0" && new[] { gameTiles[2], gameTiles[5], gameTiles[8] }.Distinct().Count() == 1)
            {
                gameStatus = Int16.Parse(gameTiles[2]);
            }
            else if (gameTiles[3] != "0" && new[] { gameTiles[3], gameTiles[6], gameTiles[9] }.Distinct().Count() == 1)
            {
                gameStatus = Int16.Parse(gameTiles[3]);
            }
            else if (gameTiles[4] != "0" && new[] { gameTiles[4], gameTiles[7], gameTiles[10] }.Distinct().Count() == 1)
            {
                gameStatus = Int16.Parse(gameTiles[4]);
            }
            else if (gameTiles[2] != "0" && new[] { gameTiles[2], gameTiles[6], gameTiles[10] }.Distinct().Count() == 1)
            {
                gameStatus = Int16.Parse(gameTiles[2]);
            }
            else if (gameTiles[4] != "0" && new[] { gameTiles[4], gameTiles[6], gameTiles[8] }.Distinct().Count() == 1)
            {
                gameStatus = Int16.Parse(gameTiles[4]);
            }
        }

        private Models.GameStatusModel BuildGameStatus()
        {
            ValidateGame();
            return new Models.GameStatusModel{ GameBoard = BuildBoard(), GameStatus = gameStatus };
        }

        private IEnumerable<Models.BoardModel> BuildBoard()
        {
            return new Models.BoardModel[]
            {
                new Models.BoardModel{Player=int.Parse(gameTiles[2])},
                new Models.BoardModel{Player=int.Parse(gameTiles[3])},
                new Models.BoardModel{Player=int.Parse(gameTiles[4])},

                new Models.BoardModel{Player=int.Parse(gameTiles[5])},
                new Models.BoardModel{Player=int.Parse(gameTiles[6])},
                new Models.BoardModel{Player=int.Parse(gameTiles[7])},

                new Models.BoardModel{Player=int.Parse(gameTiles[8])},
                new Models.BoardModel{Player=int.Parse(gameTiles[9])},
                new Models.BoardModel{Player=int.Parse(gameTiles[10])}
            };
        }

        private void SetPlay(int target, String player)
        {
            ValidateGame();

            if (gameStatus != 0) //Game is won
            {
                return;
            }

            int playedTiles = 0;
            for (int i = 2; i < gameTiles.Length; i++)
            {
                if (gameTiles[i] != "0")
                {
                    playedTiles++;
                }
            }

            if ((player == gameTiles[0]) && (playedTiles % 2 == 0))
            {
                if (gameTiles[target + 2] == "0")
                {
                    gameTiles[target + 2] = "1";
                }
            }
            else if ((player == gameTiles[1]) && (playedTiles % 2 == 1))
            {
                if (gameTiles[target + 2] == "0")
                {
                    gameTiles[target + 2] = "2";
                }
            }
        }

        private void LoadFile(String gameid)
        {
            String GamePath = Path.Combine(Path.GetTempPath(), "game_" + gameid + ".txt");

            if (File.Exists(GamePath))
            {
                String gameFile = File.ReadAllText(GamePath);
                gameTiles = gameFile.Split(',');
            }
            else
            {
                gameTiles = new String[] { "", "", "0", "0", "0", "0", "0", "0", "0", "0", "0" };
            }
        }

        private void SaveFile(String gameid)
        {
            String GamePath = Path.Combine(Path.GetTempPath(), "game_" + gameid + ".txt");

            File.WriteAllText(GamePath, String.Join(",", gameTiles));
        }
    }
}
