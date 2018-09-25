using System.Collections.Generic;

namespace TicTacToe.Models
{
    public class GameStatusModel
    {
        public IEnumerable<Models.BoardModel> GameBoard { get; set; }
        public int GameStatus { get; set; }
    }
}
