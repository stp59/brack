open Types

let buf = {
    name = "Buffalo";
    seed = 3;
    advances = 1;
    ppg = 483. /. 17.;
    oppg = 289. /. 17.;
    elo = 0.;
    wins = 11;
    losses = 6;
    pct = 64.7;
  }

let ne = {
    name = "New England";
    seed = 6;
    advances = 0;
    ppg = 462. /. 17.;
    oppg = 303. /. 17.;
    elo = 0.;
    wins = 10;
    losses = 7;
    pct = 58.8;
  }

let cin = {
    name = "Cincinnati";
    seed = 4;
    advances = 3;
    ppg = 460. /. 17.;
    oppg = 376. /. 17.;
    elo = 0.;
    wins = 10;
    losses = 7;
    pct = 58.8;
  }

let pit = {
    name = "Pittsburg";
    seed = 7;
    advances = 0;
    ppg = 343. /. 17.;
    oppg = 398. /. 17.;
    elo = 0.;
    wins = 9;
    losses = 7;
    pct = 55.9;
  }

let ten = {
    name = "Tennessee";
    seed = 1;
    advances = 1;
    ppg = 419. /. 17.;
    oppg = 354. /. 17.;
    elo = 0.;
    wins = 12;
    losses = 5;
    pct = 70.6;
  }

let kc = {
    name = "Kansas City";
    seed = 2;
    advances = 2;
    ppg = 480. /. 17.;
    oppg = 364. /. 17.;
    elo = 0.;
    wins = 12;
    losses = 5;
    pct = 70.6;
  }

let lv = {
    name = "Las Vegas";
    seed = 5;
    advances = 0;
    ppg = 374. /. 17.;
    oppg = 439. /. 17.;
    elo = 0.;
    wins = 10;
    losses = 7;
    pct = 58.8;
  }

let dal = {
    name = "Dallas";
    seed = 3;
    advances = 0;
    ppg = 530. /. 17.;
    oppg = 358. /. 17.;
    elo = 0.;
    wins = 12;
    losses = 5;
    pct = 70.6;
  }

let phi = {
    name = "Philadelphia";
    seed = 7;
    advances = 0;
    ppg = 444. /. 17.;
    oppg = 385. /. 17.;
    elo = 0.;
    wins = 9;
    losses = 8;
    pct = 52.9;
  }

let gb = {
    name = "Green Bay";
    seed = 1;
    advances = 1;
    ppg = 450. /. 17.;
    oppg = 371. /. 17.;
    elo = 0.;
    wins = 13;
    losses = 4;
    pct = 76.5;
  }

let tb = {
    name = "Tampa Bay";
    seed = 2;
    advances = 1;
    ppg = 511. /. 17.;
    oppg = 353. /. 17.;
    elo = 0.;
    wins = 13;
    losses = 4;
    pct = 76.5;
  }

let lar = {
    name = "LA Rams";
    seed = 4;
    advances = 4;
    ppg = 460. /. 17.;
    oppg = 372. /. 17.;
    elo = 0.;
    wins = 12;
    losses = 5;
    pct = 70.6;
  }

let ari = {
    name = "Arizona";
    seed = 5;
    advances = 0;
    ppg = 449. /. 17.;
    oppg = 366. /. 17.;
    elo = 0.;
    wins = 11;
    losses = 6;
    pct = 64.7;
  }

let sf = {
    name = "San Francisco";
    seed = 6;
    advances = 2;
    ppg = 427. /. 17.;
    oppg = 365. /. 17.;
    elo = 0.;
    wins = 10;
    losses = 7;
    pct = 58.8;
  }

let afc = [
    buf;
    ne;
    cin;
    pit;
    ten;
    kc;
    lv;
  ]

let nfc = [
    dal;
    phi;
    gb;
    tb;
    lar;
    ari;
    sf;
  ]
