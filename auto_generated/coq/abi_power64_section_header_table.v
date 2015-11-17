(* Generated by Lem from abis/power64/abi_power64_section_header_table.lem. *)

Require Import Arith.
Require Import Bool.
Require Import List.
Require Import String.
Require Import Program.Wf.

Require Import coqharness.

Open Scope nat_scope.
Open Scope string_scope.

(** [abi_power64_section_header_table] contains Power64 ABI specific definitions
  * related to the section header table.
  *)

Require Import lem_map.
Require Export lem_map.

Require Import lem_num.
Require Export lem_num.


Require Import elf_section_header_table.
Require Export elf_section_header_table.

(* [?]: removed value specification. *)

Definition abi_power64_special_sections   : fmap (string ) ((nat *nat ) % type):= 
  lem_map.fromList [
    (".glink", (sht_progbits, Coq.Init.Peano.plus shf_alloc shf_execinstr))
  ; (".got", (sht_progbits, Coq.Init.Peano.plus shf_alloc shf_write))
  ; (".toc", (sht_progbits, Coq.Init.Peano.plus shf_alloc shf_write))
  ; (".tocbss", (sht_nobits, Coq.Init.Peano.plus shf_alloc shf_write))
  ; (".plt", (sht_nobits, Coq.Init.Peano.plus shf_alloc shf_write))]
  .
