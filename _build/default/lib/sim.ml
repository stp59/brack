open Types
open Core

let sim_dummy _ _ = 0

(* Team with the higher number of [advances] wins. Used to build/encode
   the "real" bracket. *)
let sim_actual t1 t2 =
  Int.compare t1.advances t2.advances

(* Basic simulation; higher seed advances. *)
let sim_seed t1 t2 =
  Int.compare t2.seed t1.seed

let sim_ppg t1 t2 =
  let t1_score = (t1.ppg +. t2.oppg) /. 2. in
  let t2_score = (t2.ppg +. t1.oppg) /. 2. in
  Float.compare t1_score t2_score

let sim_elo t1 t2 =
  Float.compare t1.elo t2.elo

let sim_pct t1 t2 =
  Float.compare t1.pct t2.pct

let compose_sims sim1 sim2 t1 t2 =
  let x = (sim1 t1 t2) + (sim2 t1 t2) in
  if x > 0 then 1 else if x < 0 then -1 else 0

let sim_composite =
  List.fold ~init:sim_dummy ~f:compose_sims [ sim_seed; sim_ppg; sim_elo; sim_pct; ]
