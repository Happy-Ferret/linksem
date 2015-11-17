(* Generated by Lem from abis/amd64/abi_amd64_program_header_table.lem. *)

Require Import Arith.
Require Import Bool.
Require Import List.
Require Import String.
Require Import Program.Wf.

Require Import coqharness.

Open Scope nat_scope.
Open Scope string_scope.

(** [abi_amd64_program_header_table], program header table specific definitions
  * for the AMD64 ABI.
  *)

Require Import lem_basic_classes.
Require Export lem_basic_classes.

Require Import lem_bool.
Require Export lem_bool.

Require Import lem_num.
Require Export lem_num.

Require Import lem_string.
Require Export lem_string.


(** New segment types. *)

(** The segment contains the stack unwind tables *)
Definition abi_amd64_pt_gnu_eh_frame     :  nat :=  Coq.Init.Peano.mult( 2)( 842691240). (* 0x6474e550 *)
Definition abi_amd64_pt_sunw_eh_frame    :  nat :=  Coq.Init.Peano.mult( 2)( 842691240). (* 0x6474e550 *)
Definition abi_amd64_pt_sunw_unwind      :  nat :=  Coq.Init.Peano.mult( 2)( 842691240).
(* [?]: removed value specification. *)

Definition string_of_abi_amd64_elf_segment_type  (m : nat )  : string := 
  if beq_nat m abi_amd64_pt_gnu_eh_frame then
    "GNU_EH_FRAME"
  else if beq_nat m abi_amd64_pt_sunw_eh_frame then
    "SUNW_EH_FRAME"
  else if beq_nat  m abi_amd64_pt_sunw_unwind then
    "SUNW_UNWIND"
  else
    "Invalid AMD64 segment type".
(* [?]: removed value specification. *)

Definition abi_amd64_is_valid_program_interpreter  (s : string )  : bool :=  (string_equal s "/lib/ld64.so.1") || (string_equal s "/lib64/ld-linux-x86-64.so.2").
