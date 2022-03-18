open Types
open Core   

let bye = {
    name = "";
    seed = 0;
    advances = 0;
    ppg = 0.0;
    oppg = 0.0;
    elo = 0.;
    wins = 0;
    losses = 0;
    pct = 0.;
    (* add dummy values for the dummy [bye] placeholder team *)
  }

let sim_game (t1 : team) (t2 : team) ~(cmp : team -> team -> int) : team =
  if Int.((cmp t1 t2) > 0) then
    t1
  else if Int.((cmp t1 t2) < 0) then
    t2
  else if t1.seed > t2.seed then
    t2
  else
    t1

let winner (b : bracket) : team option =
  match b with
  | Team t -> Some t
  | Game (Some t, _, _) -> Some t
  | Game (None, _, _) -> None

let rec highest_remaining (b : bracket) : team =
  match b with
  | Team t -> t
  | Game (Some t, _, _) -> t
  | Game (None, b1, b2) ->
     let t1 = highest_remaining b1 in
     let t2 = highest_remaining b2 in
     if t1.seed > t2.seed then t2 else t1

let rec is_elongated (b :bracket) : bool =
  match b with
  | Team _ -> true
  | Game (_, Team _, Team _) -> true
  | Game (_, Team _, b) | Game (_, b, Team _) ->
     is_elongated b
  | _ -> false

let rec elongate (b : bracket) : bracket =
  match b with
  | Game (_, Game (_, b1, b2), Game (_, b3, b4))
       when (is_elongated (Game (None, b1, b2))) &&
              (is_elongated (Game (None, b3, b4))) &&
                not (is_elongated b) ->
     let ts =
       [b1; b2; b3; b4]
       |> List.map ~f:(fun b -> highest_remaining b, b)
       |> List.sort ~compare:(fun (a,_) (b,_) -> Int.compare a.seed b.seed) in
     let b1 = List.nth_exn ts 0 |> snd in
     let b2 = List.nth_exn ts 1 |> snd in
     let b3 = List.nth_exn ts 2 |> snd in
     let b4 = List.nth_exn ts 3 |> snd in
     Game (None, b1, Game (None, b2, Game (None, b3, b4)))
  | Game (_, b1, b2) -> Game (None, elongate b1, elongate b2)
  | _ -> b

let rec resolve_bye (b : bracket) : bracket =
  match b with
  | Team t -> Team t
  | Game (w, Team t1, Team t2) ->
     if String.equal t1.name "" then
       Team t2
     else if String.equal t2.name "" then
       Team t1
     else
       Game (w, Team t1, Team t2)
  | Game (w, b1, b2) ->
     Game (w, resolve_bye b1, resolve_bye b2)

let rec resolve_byes (b : bracket) : bracket =
  let b' = resolve_bye b in
  if Stdlib.(b' = b) then b' else resolve_byes b'

let rec seed_brackets (rounds : int) (ts : bracket list) : bracket =
  if Int.equal (List.length ts) 1 then
    if Int.(rounds = 0) then List.hd_exn ts |> resolve_byes
    else List.hd_exn ts |> resolve_byes |> Fn.apply_n_times ~n:rounds elongate
  else
    let ts =
      List.map ts ~f:(fun b -> highest_remaining b, b)
      |> List.sort ~compare:(fun a b -> Int.compare (fst a).seed (fst b).seed) in
    let max_seed = List.fold ts ~init:0 ~f:(fun m t -> Int.max m (fst t).seed) in
    let tlen = List.length ts in
    let size = Int.ceil_pow2 tlen in
    let ts =
      List.init size ~f:(fun i ->
          if i < tlen
          then List.nth_exn ts i
          else
            let bye ={ bye with seed = max_seed + 1 + 1; } in
            bye, Team bye) in
    let rec do_pairings acc ts =
      match ts with
      | [] -> acc
      | _ :: _ :: _ ->
         let top_seed = List.hd_exn ts in
         let bottom_seed = List.last_exn ts in
         do_pairings
           (Game (None, snd top_seed, snd bottom_seed) :: acc)
           (ts |> List.tl_exn |> List.rev |> List.tl_exn |> List.rev)
      | _ :: _ -> failwith "odd number of teams question mark" in
    let ts = do_pairings [] ts in
    (* let () = Format.sprintf "length of ts is: %d" (List.length ts) |> print_endline in *)
    seed_brackets (rounds - 1) ts

let seed_bracket (rounds : int) (ts : team list) : bracket =
  List.map ts ~f:(fun t -> Team t)
  |> seed_brackets rounds

let reseed_bracket (b : bracket) : bracket =
  let rec get_teams = function
    | Team t -> [ Team t ]
    | Game (Some t, b1, b2) -> [ Game (Some t, b1, b2) ]
    | Game (None, b1, b2) -> List.rev_append (get_teams b1) (get_teams b2) in
  let rec rounds_left b =
    match b with
    | Team _ -> 0
    | Game (Some _, _, _) -> 0
    | Game (None, b1, b2) -> 1 + (max (rounds_left b1) (rounds_left b2)) in
  seed_brackets (rounds_left b) (get_teams b)

let rec fill_round (brack : bracket) ~(cmp : team -> team -> int) : bracket =
  match brack with
  | Team t -> Team t
  | Game (Some t, b1, b2) -> Game (Some t, b1, b2)
  | Game (None, b1, b2) ->
     match winner b1, winner b2 with
     | Some t1, Some t2 -> Game (Some (sim_game t1 t2 ~cmp), b1, b2)
     | Some _, None -> Game (None, b1, fill_round ~cmp b2)
     | None, Some _ -> Game (None, fill_round ~cmp b1, b2)
     | None, None -> Game (None, fill_round ~cmp b1, fill_round ~cmp b2)

let rec fill_bracket (reseeds : int list) (brack : bracket)
          ~(cmp : team -> team -> int) : bracket =
  match reseeds with
  | [] -> begin
      match brack with
      | Team t -> Team t
      | Game (Some _, _, _) -> brack
      | _ -> brack |> fill_round ~cmp |> fill_bracket [] ~cmp
    end
  | 0 :: reseeds -> fill_bracket reseeds (reseed_bracket brack) ~cmp
  | h :: t -> fill_round ~cmp brack |> fill_bracket (h-1 :: t) ~cmp
