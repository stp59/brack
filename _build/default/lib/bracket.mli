open Types

(* simulate a single round of the bracket using the game simulation defined by [cmp] *)
val fill_round : bracket -> cmp : (team -> team -> int) -> bracket

(* simulate the entire bracket using the game simulation defined by [cmp] *)
val fill_bracket : int list -> bracket -> cmp : (team -> team -> int) -> bracket

(* given a list of teams, build a bracket using standard seed-based pairing. *)
val seed_bracket : int -> team list -> bracket

(* given a partially filled bracket, restructure so that the next round's
   pairings respect the seed-based pairing rules. *)
val reseed_bracket : bracket -> bracket

