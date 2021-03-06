chapter {* Generated by Lem from hex_printing.lem. *}

theory "Hex_printing" 

imports 
 	 Main
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_num" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_list" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_basic_classes" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_string" 
	 "Missing_pervasives" 
	 "Elf_types_native_uint" 

begin 

(** [hex_printing] is a utility module for converting natural numbers and integers
  * into hex strings of various widths.  Split into a new module as both the
  * validation code and the main program need this functionality.
  *)

(*open import Basic_classes*)
(*open import List*)
(*open import Num*)
(*open import String*)

(*open import Missing_pervasives*)
(*open import Elf_types_native_uint*)

(*val hex_string_of_big_int_no_padding : natural -> string*)
(* declare ocaml target_rep function hex_string_of_big_int_no_padding = `Ml_bindings.hex_string_of_big_int_no_padding` *)
definition hex_string_of_big_int_no_padding  :: " nat \<Rightarrow> string "  where 
     " hex_string_of_big_int_no_padding = ( hex_string_of_natural )"

(*val hex_string_of_big_int_no_padding' : integer -> string*)
(*val hex_string_of_big_int_pad2 : natural -> string*)
(*val hex_string_of_big_int_pad4 : natural -> string*)
(*val hex_string_of_big_int_pad5 : natural -> string*)
(*val hex_string_of_big_int_pad6 : natural -> string*)
(*val hex_string_of_big_int_pad7 : natural -> string*)
(*val hex_string_of_big_int_pad8 : natural -> string*)
(*val hex_string_of_big_int_pad16 : natural -> string*)

(*val hex_string_of_nat_pad2 : nat -> string*)

(*val unsafe_hex_string_of_natural : nat -> natural -> string*)

(*val unsafe_hex_string_of_uc_list : list unsigned_char -> string*)
end
