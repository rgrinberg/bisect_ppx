(* This Source Code Form is subject to the terms of the Mozilla Public License,
   v. 2.0. If a copy of the MPL was not distributed with this file, You can
   obtain one at http://mozilla.org/MPL/2.0/. *)



type output_kind =
  | Html_output of string
  | Csv_output of string
  | Text_output of string
  | Dump_output of string

let outputs = ref []

let add_output o =
  outputs := o :: !outputs

let verbose = ref false

let tab_size = ref 8

let title = ref "Coverage report"

let separator = ref ";"

let search_path = ref [""]

let add_search_path sp =
  search_path := sp :: !search_path

let files = ref []

let summary_only = ref false

let ignore_missing_files = ref false

let add_file f =
  files := f :: !files

let options = Arg.align [
  ("-html",
   Arg.String (fun s -> add_output (Html_output s)),
   "<dir>  Output HTML report to <dir> (HTML only)");

  ("-I",
   Arg.String add_search_path,
   "<dir>  Look for .ml files in <dir> (HTML only)");

   ("-ignore-missing-files",
   Arg.Set ignore_missing_files,
   " Do not fail if an .ml file can't be found (HTML only)");

  ("-title",
   Arg.Set_string title,
   "<string>  Set title for report pages (HTML only)");

  ("-tab-size",
   Arg.Int
     (fun x ->
       if x < 0 then
         (print_endline " *** error: tab size should be positive"; exit 1)
       else
         tab_size := x),
   "<int>  Set tab width in report (HTML only)");

  ("-text",
   Arg.String (fun s -> add_output (Text_output s)),
   "<file>  Output plain text report to <file>");

  ("-summary-only",
   Arg.Set summary_only,
   " Output only a whole-project summary (text only)");

  ("-csv",
   Arg.String (fun s -> add_output (Csv_output s)),
   "<file>  Output CSV report to <file>");

  ("-separator",
   Arg.Set_string separator,
   "<string>  Set column separator (CSV only)");

  ("-dump",
   Arg.String (fun s -> add_output (Dump_output s)),
   "<file>  Output bare dump to <file>");

  ("-verbose",
   Arg.Set verbose,
   " Set verbose mode");

  ("-version",
   Arg.Unit (fun () -> print_endline Bisect.Version.value; exit 0),
   " Print version and exit");
]

let usage =
{|Usage:

  bisect-ppx-report <options> <.out files>

Where a file is required, '-' may be used to specify STDOUT.

Examples:

  bisect-ppx-report -html coverage/ -I _build bisect*.out
  bisect-ppx-report -text - -summary-only bisect*.out

Jbuilder:

  bisect-ppx-report -html coverage/ -I _build/default _build/default/bisect*.out

Options are:
|}

let parse () = Arg.parse options add_file usage

let print_usage () = Arg.usage options usage