open Types

let usa = {
    name = "USA";
    seed = 1;
    advances = 1;
    ppg = 15. /. 3.;
    oppg = 4. /. 3.;
    elo = 0.;
    wins = 3;
    losses = 0;
    pct = 100.;
  }

let can = {
    name = "Canada";
    seed = 5;
    advances = 1;
    ppg = 12. /. 3.;
    oppg = 5. /. 3.;
    elo = 0.;
    wins = 2;
    losses = 1;
    pct = 66.67;
  }

let ger = {
    name = "Germany";
    seed = 9;
    advances = 0;
    ppg = 6. /. 3.;
    oppg = 10. /. 3.;
    elo = 0.;
    wins = 1;
    losses = 2;
    pct = 33.33;
  }

let chn = {
    name = "China";
    seed = 12;
    advances = 0;
    ppg = 2. /. 3.;
    oppg = 16. /. 3.;
    elo = 0.;
    wins = 0;
    losses = 3;
    pct = 0.
  }

let roc = {
    name = "ROC";
    seed = 3;
    advances = 3;
    ppg = 8. /. 3.;
    oppg = 6. /. 3.;
    elo = 0.;
    wins = 2;
    losses = 1;
    pct = 66.67;
  }

let den = {
    name = "Denmark";
    seed = 6;
    advances = 1;
    ppg = 7. /. 3.;
    oppg = 6. /. 3.;
    elo = 0.;
    wins = 2;
    losses = 1;
    pct = 66.67;
  }

let cze = {
    name = "Czech Republic";
    seed = 7;
    advances = 0;
    ppg = 9. /. 3.;
    oppg = 8. /. 3.;
    elo = 0.;
    wins = 2;
    losses = 1;
    pct = 66.67;
  }

let sui = {
    name = "Switzerland";
    seed = 10;
    advances = 1;
    ppg = 4. /. 3.;
    oppg = 8. /. 3.;
    elo = 0.;
    wins = 0;
    losses = 3;
    pct = 0.;
  }

let fin = {
    name = "Finland";
    seed = 2;
    advances = 4;
    ppg = 13. /. 3.;
    oppg = 6. /. 3.;
    elo = 0.;
    wins = 3;
    losses = 0;
    pct = 100.;
  }

let swe = {
    name = "Sweden";
    seed = 4;
    advances = 2;
    ppg = 10. /. 3.;
    oppg = 7. /. 3.;
    elo = 0.;
    wins = 2;
    losses = 1;
    pct = 66.67;
  }

let svk = {
    name = "Slovakia";
    seed = 8;
    advances = 2;
    ppg = 8. /. 3.;
    oppg = 12. /. 3.;
    elo = 0.;
    wins = 1;
    losses = 2;
    pct = 33.33;
  }

let lat = {
    name = "Latvia";
    seed = 11;
    advances = 0;
    ppg = 5. /. 3.;
    oppg = 11. /. 3.;
    elo = 0.;
    wins = 0;
    losses = 3;
    pct = 0.;
  }

let olympics = [
    usa;
    fin;
    roc;
    swe;
    can;
    den;
    cze;
    svk;
    ger;
    sui;
    lat;
    chn;
  ]
