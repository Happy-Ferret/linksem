(*Generated by Lem from gnu_extensions/gnu_ext_note.lem.*)
open HolKernel Parse boolLib bossLib;
open lem_listTheory lem_basic_classesTheory lem_boolTheory lem_maybeTheory lem_stringTheory missing_pervasivesTheory errorTheory byte_sequenceTheory endiannessTheory elf_types_native_uintTheory string_tableTheory elf_section_header_tableTheory gnu_ext_section_header_tableTheory elf_noteTheory gnu_ext_noteTheory;

val _ = numLib.prefer_num();



open lemLib;
(* val _ = lemLib.run_interactive := true; *)
val _ = new_theory "gnu_ext_noteAuxiliary"


(****************************************************)
(*                                                  *)
(* Termination Proofs                               *)
(*                                                  *)
(****************************************************)

(* val gst = Defn.tgoal_no_defn (group_elf32_words_def, group_elf32_words_ind) *)
val (group_elf32_words_rw, group_elf32_words_ind_rw) =
  Defn.tprove_no_defn ((group_elf32_words_def, group_elf32_words_ind),
    cheat
  )
val group_elf32_words_rw = save_thm ("group_elf32_words_rw", group_elf32_words_rw);
val group_elf32_words_ind_rw = save_thm ("group_elf32_words_ind_rw", group_elf32_words_ind_rw);


(* val gst = Defn.tgoal_no_defn (group_elf64_words_def, group_elf64_words_ind) *)
val (group_elf64_words_rw, group_elf64_words_ind_rw) =
  Defn.tprove_no_defn ((group_elf64_words_def, group_elf64_words_ind),
    cheat
  )
val group_elf64_words_rw = save_thm ("group_elf64_words_rw", group_elf64_words_rw);
val group_elf64_words_ind_rw = save_thm ("group_elf64_words_ind_rw", group_elf64_words_ind_rw);




val _ = export_theory()

