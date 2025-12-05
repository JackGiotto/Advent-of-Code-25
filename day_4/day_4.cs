using System;
using System.IO;
using System.Collections.Generic;

public class Position {
	public static List<Position> rolls = new List<Position>();
    public bool toilet_paper = false;
    private int x;
    private int y;

    public Position (char c, int x, int y) {
        this.x = x;
        this.y = y;
		if (c == '@') {
			toilet_paper = true;
			rolls.Add(this);
        }
    }

    public bool accessible(Position[,] matrix) {
        int count = 0;

        for (int dx = -1; dx <= 1; dx++) {
            for (int dy = -1; dy <= 1; dy++) {
                if (dx == 0 && dy == 0) continue;
                try {
                    if (matrix[this.x + dx, this.y + dy].toilet_paper) {
                        count++;
                        if (count >= 4) {
                            return false;
                        }
                    }
                }
                catch (IndexOutOfRangeException) {
                }
            }
        }
        return true;
    }
}

// public class MatrixPrinter {
// 	public static void PrintMatrix(Position[,] matrix) {
// 		for (int i = 0; i < matrix.GetLength(0); i++) {
// 			for (int j = 0; j < matrix.GetLength(1); j++) {
// 				Console.Write(matrix[i, j].toilet_paper ? '@' : '.');
// 			}
// 			Console.WriteLine();
// 		}
// 	}
// }

class Day_4 {
    static void Main() {
		bool PART_2 = true;

        string[] lines = File.ReadAllLines("input.txt");

        int rows = lines.Length;
        int cols = lines[0].Length;

        Position[,] matrix = new Position[rows, cols];

        for (int r = 0; r < rows; r++)
        {
            for (int c = 0; c < cols; c++)
            {
                char ch = lines[r][c];
                matrix[r, c] = new Position(ch, r, c);
            }
        }

        int count = 0;

		bool flag;
		do {
			flag = false;
			for (int i = Position.rolls.Count - 1; i >= 0; i--) {
				Position p = Position.rolls[i];
				if (p.accessible(matrix)) {
					count++;
					if (PART_2) {
						p.toilet_paper = false;
						Position.rolls.RemoveAt(i);
						flag = true;
					}
				}
			}
		} while (flag);

        Console.WriteLine(count);
		// MatrixPrinter.PrintMatrix(matrix);
    }
}