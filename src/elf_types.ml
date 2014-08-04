(*Generated by Lem from elf_types.lem.*)
open Lem_pervasives

open Bitstring
open Error
open Show

(** unsigned char type and bindings *)

(*type unsigned_char*)

(*val string_of_unsigned_char : unsigned_char -> string*)
(*val nat_of_unsigned_char : unsigned_char -> nat*)
(*val unsigned_char_of_nat : nat -> unsigned_char*)
(*val unsigned_char_land   : unsigned_char -> unsigned_char -> unsigned_char*)
(*val unsigned_char_lshift : unsigned_char -> nat -> unsigned_char*)
(*val unsigned_char_rshift : unsigned_char -> nat -> unsigned_char*)
(*val unsigned_char_plus   : unsigned_char -> unsigned_char -> unsigned_char*)
(*val read_unsigned_char   : bitstring     -> error (unsigned_char * bitstring)*)

let instance_Show_Show_Elf_types_unsigned_char_dict =({

  show_method = Int64.to_string})

(** elf32_addr type and bindings *)

(*type elf32_addr*)

(*val string_of_elf32_addr : elf32_addr -> string*)
(*val nat_of_elf32_addr : elf32_addr -> nat*)
(*val read_elf32_addr : bitstring -> error (elf32_addr * bitstring)*)

let instance_Show_Show_Elf_types_elf32_addr_dict =({

  show_method = Int64.to_string})

(** elf32_half type and bindings *)

(*type elf32_half*)

(*val string_of_elf32_half : elf32_half -> string*)
(*val read_elf32_half : bitstring -> error (elf32_half * bitstring)*)
(*val nat_of_elf32_half : elf32_half -> nat*)

let instance_Show_Show_Elf_types_elf32_half_dict =({

  show_method = Int64.to_string})


(** elf32_off type and bindings *)

(*type elf32_off*)

(*val string_of_elf32_off : elf32_off -> string*)
(*val nat_of_elf32_off : elf32_off -> nat*)
(*val read_elf32_off : bitstring -> error (elf32_off * bitstring)*)

let instance_Show_Show_Elf_types_elf32_off_dict =({

  show_method = Int64.to_string})

(** elf32_word type and bindings *)

(*type elf32_word*)

(*val string_of_elf32_word : elf32_word -> string*)
(*val nat_of_elf32_word : elf32_word -> nat*)
(*val read_elf32_word : bitstring -> error (elf32_word * bitstring)*)

let instance_Show_Show_Elf_types_elf32_word_dict =({

  show_method = Int64.to_string})