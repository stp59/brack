open Core
open Command.Spec
open Tournament
open Types
open Sim
open Score
open Bracket

let write_bracket ?(score = None) ?(seed = None) ?(max = None)
      (name : string) (brack : bracket) : unit =
  let fd = Out_channel.create (Format.sprintf "%s.dot" name) in
  let counter = ref 0 in
  let label () =
    counter := !counter + 1;
    Format.sprintf "t%d" (!counter) in
  Out_channel.output_string fd "digraph {\ngraph [rankdir=LR];";
  let rec h b =
    match b with
    | Team t ->
       let label = label () in
       Out_channel.output_string fd
         (Format.sprintf "\"%s\" [label=\"%d %s\"];\n" label t.seed t.name);
       label
    | Game (Some t, b1, b2) ->
       let label = label () in
       Out_channel.output_string fd
         (Format.sprintf "\"%s\" [label=\"%d %s\"];\n" label t.seed t.name);
       let l1 = h b1 in
       let l2 = h b2 in
       Out_channel.output_string fd
         (Format.sprintf "\"%s\" -> \"%s\";\n" l1 label);
       Out_channel.output_string fd
         (Format.sprintf "\"%s\" -> \"%s\";\n" l2 label);
       label
    | Game (None, b1, b2) ->
       let label = label () in
       Out_channel.output_string fd
         (Format.sprintf "\"%s\" [label=\"\"];\n" label);
       let l1 = h b1 in
       let l2 = h b2 in
       Out_channel.output_string fd
         (Format.sprintf "\"%s\" -> \"%s\";\n" l1 label);
       Out_channel.output_string fd (Format.sprintf "\"%s\" -> \"%s\";\n" l2 label);
       label in
  h brack |> ignore ;
  let () = match score with
    | None -> ()
    | Some n ->
       Out_channel.output_string fd
         (Format.sprintf "score [label=\"score: %d\"];\n" n) in
  let () = match seed with
    | None -> ()
    | Some n ->
       Out_channel.output_string fd
         (Format.sprintf "seed [label=\"seed score: %d\"];\n" n) in
  let () = match max with
    | None -> ()
    | Some n ->
       Out_channel.output_string fd
         (Format.sprintf "max [label=\"avg score: %d\"];\n" n) in
  Out_channel.output_string fd "}\n"

let nfl cmp =
  let afcc =
    seed_bracket 3 Nfl.afc
    |> fill_bracket [1] ~cmp in
  let nfcc =
    seed_bracket 3 Nfl.nfc
    |> fill_bracket [1] ~cmp in
  Game (None, afcc, nfcc)
  |> fill_bracket [] ~cmp

let olympic_hockey_bracket cmp =
  seed_bracket 4 Olympic_hockey.olympics
  |> fill_bracket [2] ~cmp

let parse_csv (csvfile : string) : bracket * int list =
  let fd = In_channel.create csvfile in
  let csv_fd = Csv.of_channel fd in
  let vals = Csv.input_all csv_fd in
  let () = Csv.close_in csv_fd in
  let () = In_channel.close fd in
  let rounds =
    List.hd_exn vals
    |> List.tl_exn
    |> List.hd_exn
    |> Int.of_string in
  let vals = List.tl_exn vals in
  let reseeds =
    List.hd_exn vals
    |> List.tl_exn
    |> List.map
         ~f:(fun s ->
           if String.equal s "" then
             None
           else
             Some (Int.of_string s))
    |> List.filter_map ~f:Fn.id
    |> List.folding_map ~init:0 ~f:(fun prev cur -> cur, cur-prev) in
  let vals = List.tl_exn vals in
  let keys = List.hd_exn vals in
  let teams =
    List.tl_exn vals
    |> List.map ~f:(fun t -> List.zip_exn keys t)
    |> List.map
         ~f:(fun t -> {
                 name = List.Assoc.find_exn t "name" ~equal:String.equal;
                 seed = List.Assoc.find_exn t "seed" ~equal:String.equal
                        |> Int.of_string;
                 advances = List.Assoc.find_exn t "advances" ~equal:String.equal
                            |> Int.of_string;
                 ppg = List.Assoc.find_exn t "ppg" ~equal:String.equal
                       |> Float.of_string;
                 oppg = List.Assoc.find_exn t "oppg" ~equal:String.equal
                        |> Float.of_string;
                 elo = List.Assoc.find_exn t "elo" ~equal:String.equal
                       |> Float.of_string;
                 wins = List.Assoc.find_exn t "wins" ~equal:String.equal
                        |> Int.of_string;
                 losses = List.Assoc.find_exn t "losses" ~equal:String.equal
                          |> Int.of_string;
                 pct = List.Assoc.find_exn t "pct" ~equal:String.equal
                       |> Float.of_string;
         }) in
  let empty_bracket = seed_bracket rounds teams in
  empty_bracket, reseeds

let do_csv csvfile =
  let dot_fn =
    csvfile
    |> String.split ~on:'.'
    |> List.hd_exn
    |> String.split ~on:'/'
    |> List.tl_exn
    |> String.concat ~sep:"/"
    |> (^) "brackets/" in
  let empty_bracket, reseeds = parse_csv csvfile in
  let actual_bracket = fill_bracket reseeds empty_bracket ~cmp:sim_actual in
  let seed_bracket = fill_bracket reseeds empty_bracket ~cmp:sim_seed in
  let bracket = fill_bracket reseeds empty_bracket ~cmp:sim_composite in
  let score = score_bracket bracket actual_bracket in
  let seed_score = score_bracket seed_bracket actual_bracket in
  let max = score_bracket actual_bracket actual_bracket in
  write_bracket
    ~score:(Some score)
    ~seed:(Some seed_score)
    ~max:(Some max)
    dot_fn
    bracket

let do_ncaa () =
  let dot_fn = "brackets/ncaab/main" in
  let west, _ = parse_csv "stats/ncaab/west_regional.csv" in
  let east, _ = parse_csv "stats/ncaab/east_regional.csv" in
  let south, _ = parse_csv "stats/ncaab/south_regional.csv" in
  let midwest, _ = parse_csv "stats/ncaab/midwest_regional.csv" in
  let main =
    Game (None,
          Game (None, west, east),
          Game (None, south, midwest)) in
  write_bracket dot_fn (fill_bracket [] main ~cmp:sim_pct)

let csv_command =
  Command.basic_spec
    ~summary:"Generate a bracket png from a CSV file"
    (empty
     +> anon ("csvfile" %: string))
    (fun csvfile () -> do_csv csvfile)

let ncaa_command =
  Command.basic_spec
    ~summary:"Generate the main NCAA bracket prediction from CSV files"
    (empty)
    (fun () -> do_ncaa () )

let command =
  Command.group
    ~summary:"Brack: A tool for generating tournament bracket predictions"
    [ ("csv", csv_command);
      ("ncaa", ncaa_command); ]


let () = Command.run command
           
