(* Generated by Lem from abis/x86/abi_x86_relocation.lem. *)

Require Import Arith.
Require Import Bool.
Require Import List.
Require Import String.
Require Import Program.Wf.

Require Import coqharness.

Open Scope nat_scope.
Open Scope string_scope.

(** [abi_x86_relocation] contains X86 ABI specific definitions relating to
  * relocations.
  *)

Require Import lem_basic_classes.
Require Export lem_basic_classes.

Require Import lem_num.
Require Export lem_num.

Require Import lem_string.
Require Export lem_string.


Require Import show.
Require Export show.


(** Relocation types. *)

Definition r_386_none    :  nat :=  0.
Definition r_386_32    :  nat :=  1.
Definition r_386_pc32    :  nat :=  2.
Definition r_386_got32    :  nat :=  3.
Definition r_386_plt32    :  nat :=  4.
Definition r_386_copy    :  nat :=  5.
Definition r_386_glob_dat    :  nat :=  6.
Definition r_386_jmp_slot    :  nat :=  7.
Definition r_386_relative    :  nat :=  8.
Definition r_386_gotoff    :  nat :=  9.
Definition r_386_gotpc    :  nat :=  10.

(** Found in the "wild" but not in the ABI docs: *)

Definition r_386_tls_tpoff    :  nat :=  14.
Definition r_386_tls_dtpmod32    :  nat :=  35.
Definition r_386_tls_dtpoff32    :  nat :=  36.
Definition r_386_irelative    :  nat :=  42.
(* [?]: removed value specification. *)

Definition string_of_x86_relocation_type  (m : nat )  : string := 
  if beq_nat m r_386_none then
    "R_386_NONE"
  else if beq_nat m r_386_32 then
    "R_386_32"
  else if beq_nat m r_386_pc32 then
    "R_386_PC32"
  else if beq_nat m r_386_got32 then
    "R_386_GOT32"
  else if beq_nat m r_386_plt32 then
    "R_386_PLT32"
  else if beq_nat m r_386_copy then
    "R_386_COPY"
  else if beq_nat m r_386_glob_dat then
    "R_386_GLOB_DAT"
  else if beq_nat m r_386_jmp_slot then
    "R_386_JUMP_SLOT"
  else if beq_nat m r_386_relative then
    "R_386_RELATIVE"
  else if beq_nat m r_386_gotoff then
    "R_386_GOTOFF"
  else if beq_nat m r_386_gotpc then
    "R_386_GOTPC"
  else if beq_nat m r_386_tls_tpoff then
    "R_386_TLS_TPOFF"
  else if beq_nat m r_386_tls_dtpmod32 then
    "R_386_TLS_DTPMOD32"
  else if beq_nat m r_386_tls_dtpoff32 then
    "R_386_TLS_DTPOFF32"
  else if beq_nat m r_386_irelative then
    "R_386_IRELATIVE"
  else
    "Invalid x86 relocation".
