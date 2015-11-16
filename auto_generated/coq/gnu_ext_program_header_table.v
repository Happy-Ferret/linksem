(* Generated by Lem from gnu_extensions/gnu_ext_program_header_table.lem. *)

Require Import Arith.
Require Import Bool.
Require Import List.
Require Import String.
Require Import Program.Wf.

Require Import coqharness.

Open Scope nat_scope.
Open Scope string_scope.

(** [gnu_ext_program_header_table] contains GNU extension specific functionality
  * related to the program header table.
  *)

Require Import lem_basic_classes.
Require Export lem_basic_classes.

Require Import lem_num.
Require Export lem_num.


(** GNU extensions, as defined in the LSB, see section 11.2. *)

(** The element specifies the location and size of a segment that may be made
  * read-only after relocations have been processed.
  *)
Definition elf_pt_gnu_relro    :  nat :=  Coq.Init.Peano.plus ( Coq.Init.Peano.mult( 4)( 421345620))( 2). (* 0x6474e552 *)
(** The [p_flags] member specifies the permissions of the segment containing the
  * stack and is used to indicate whether the stack should be executable.
  *)
Definition elf_pt_gnu_stack    :  nat :=  Coq.Init.Peano.plus ( Coq.Init.Peano.mult( 4)( 421345620))( 1). (* 0x6474e551 *)
(** Element specifies the location and size of exception handling information. *)
Definition elf_pt_gnu_eh_frame    :  nat :=  Coq.Init.Peano.mult( 4)( 421345620).
(* [?]: removed value specification. *)

