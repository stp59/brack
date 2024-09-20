type team = {
    name : string;
    seed : int;
    advances : int;
    ppg : float;
    oppg : float;
    elo : float;
    wins : int;
    losses : int;
    pct : float;
  }

type bracket =
  | Team of team
  | Game of team option * bracket * bracket
