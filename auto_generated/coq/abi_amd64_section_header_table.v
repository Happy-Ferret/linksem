(* Generated by Lem from abis/amd64/abi_amd64_section_header_table.lem. *)

Require Import Arith.
Require Import Bool.
Require Import List.
Require Import String.
Require Import Program.Wf.

Require Import coqharness.

Open Scope nat_scope.
Open Scope string_scope.

(** [abi_amd64_section_header_table] module contains section header table
  * specific definitions for the AMD64 ABI.
  *)

Require Import lem_basic_classes.
Require Export lem_basic_classes.

Require Import lem_map.
Require Export lem_map.

Require Import lem_num.
Require Export lem_num.


Require Import elf_section_header_table.
Require Export elf_section_header_table.


(** AMD64 specific flags.  See Section 4.2.1. *)

Definition shf_abi_amd64_large    :  nat :=  Coq.Init.Peano.mult( 67108864)( 4). (* 0x10000000 *)

(** AMD64 specific section types.  See Section 4.2.2 *)

Definition sht_abi_amd64_unwind    :  nat :=  Coq.Init.Peano.plus ( Coq.Init.Peano.mult( 939524096)( 2))( 1).
(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

Definition abi_amg64_special_sections   : fmap (string ) ((nat *nat ) % type):= 
  lem_map.fromList [
    (".got", (sht_progbits, Coq.Init.Peano.plus shf_alloc shf_write))
  ; (".plt", (sht_progbits, Coq.Init.Peano.plus shf_alloc shf_execinstr))
  ; (".eh_frame", (sht_abi_amd64_unwind, shf_alloc))]
  .
(* [?]: removed value specification. *)

Definition abi_amd64_special_sections_large_code_model   : fmap (string ) ((nat *nat ) % type):= 
  lem_map.fromList [
    (".lbss", (sht_nobits, Coq.Init.Peano.plus (Coq.Init.Peano.plus shf_alloc shf_write) shf_abi_amd64_large))
  ; (".ldata", (sht_progbits, Coq.Init.Peano.plus (Coq.Init.Peano.plus shf_alloc shf_write) shf_abi_amd64_large))
  ; (".ldata1", (sht_progbits, Coq.Init.Peano.plus (Coq.Init.Peano.plus shf_alloc shf_write) shf_abi_amd64_large))
  ; (".lgot", (sht_progbits, Coq.Init.Peano.plus (Coq.Init.Peano.plus shf_alloc shf_write) shf_abi_amd64_large))
  ; (".lplt", (sht_progbits, Coq.Init.Peano.plus (Coq.Init.Peano.plus shf_alloc shf_execinstr) shf_abi_amd64_large))
  ; (".lrodata", (sht_progbits, Coq.Init.Peano.plus shf_alloc shf_abi_amd64_large))
  ; (".lrodata1", (sht_progbits, Coq.Init.Peano.plus shf_alloc shf_abi_amd64_large))
  ; (".ltext", (sht_progbits, Coq.Init.Peano.plus (Coq.Init.Peano.plus shf_alloc shf_execinstr) shf_abi_amd64_large))]
  .
