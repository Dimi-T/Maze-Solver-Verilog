/*
Toate explicatiile detaliate sunt prezente in README.
Aici vor avea doar comentarii punctuale, explicit pe cod.

*/

module maze(
  input clk,
  input [maze_width - 1 : 0] starting_col, starting_row,
  input maze_in,
  output reg [maze_width - 1 : 0] row, col,
  output reg maze_oe,
  output reg maze_we,
  output reg done);


  parameter maze_width = 6;

  `define NORTH 0                                                                               //   Fiecare directie de deplasare este
  `define EAST  1                                                                               // reprezentata de orientarea din punct de vedere
  `define SOUTH 2                                                                               // cardinal.
  `define WEST  3

  `define START 0
  `define READ  1
  `define MOVE  2
  `define EXIT  3


  reg [1 : 0] state;
  reg [1 : 0] next_state;
  reg [1 : 0] direction;

  always @(posedge clk)                                                                         //   Voi trece in alta stare doar daca nu am
      if (done == 0)                                                                            // gasit deja iesirea.
        state <= next_state;


  always @(*) begin

    maze_oe = 0;
    maze_we = 0;
    done = 0;
    next_state = `START;

    case(state)
      `START: begin
                row = starting_row;                                                             //   Initial pozitia curenta este cea data
                col = starting_col;                                                             // de intrare. Orientarea initiala se alege
                direction = 0;                                                                  // arbitrar ca fiind NORTH.
                maze_we = 1;                                                                    //  Stiu ca punctul de start este culoar (liber),
                next_state = `MOVE;                                                             // asa ca nu mai verific, doar ma deplasez.
                end

      `EXIT: begin
                done = 1;
                end

      `MOVE: begin
                case(direction)
                  `NORTH: col = col + 1;
                  `EAST: row = row + 1;
                  `SOUTH: col = col - 1;
                  `WEST: row = row - 1;
                  default: ;
                endcase
                maze_oe = 1;                                                                    //  Dupa ce m-am deplasat, verific daca ma aflu
                next_state = `READ;                                                             // pe un culoar liber sau intr-un perete.
                end
        `READ: begin
                  if((row == 63 || col == 63 || row == 0 || col == 0) && maze_in == 0) begin    //  Daca sunt pe un culoar in marginea
                    maze_we = 1;                                                                // labirintului, inseamna ca am gasit iesirea.
                    next_state = `EXIT;
                  end
                  else if(maze_in == 0) begin                                                   //   Daca ma aflu pe un culoar, atunci il marchez
                    maze_we = 1;                                                                // si continui sa merg intr-o noua directie.
                    direction = direction + 1;
                    next_state = `MOVE;
                  end
                  else begin                                                                    //   Daca ma aflu intr-un perete, inseamna ca
                    case(direction)                                                             // ca trebuie sa ma intorc pe celula anterioara.
                      `NORTH: col = col - 1;
                      `EAST: row = row - 1;
                      `SOUTH: col = col + 1;
                      `WEST: row = row + 1;
                      default: ;
                    endcase
                    if(direction == 0)                                                          //   Pentru deplasarea in directia buna, ciclez
                      direction = 3;                                                            // prin orientarile anterioare
                    else
                      direction = direction - 1;
                    next_state = `MOVE;
                  end
                  end
          default: ;
      endcase
    end
endmodule
