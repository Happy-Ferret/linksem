(*Generated by Lem from elf_interpreted_section.lem.*)
open HolKernel Parse boolLib bossLib;
open lem_numTheory lem_listTheory lem_basic_classesTheory lem_boolTheory lem_maybeTheory lem_stringTheory showTheory missing_pervasivesTheory errorTheory byte_sequenceTheory elf_types_native_uintTheory string_tableTheory elf_section_header_tableTheory;

val _ = numLib.prefer_num();



val _ = new_theory "elf_interpreted_section"

(** Module [elf_interpreted_section] provides a record of "interpreted" sections,
  * i.e. the data stored in the section header table converted to more amenable
  * infinite precision types, and operation on those records.
  *)

(*open import Basic_classes*)
(*open import Bool*)
(*open import List*)
(*open import Maybe*)
(*open import Num*)
(*open import String*)

(*open import Byte_sequence*)
(*open import Error*)
(*open import String_table*)

(*open import Elf_types_native_uint*)
(*open import Elf_section_header_table*)

(*open import Missing_pervasives*)
(*open import Show*)

(** [elf32_interpreted_section] exactly mirrors the structure of a section header
  * table entry, barring the conversion of all fields to more amenable types.
  *)
val _ = Hol_datatype `
 elf32_interpreted_section =
  <| elf32_section_name    : num       (** Name of the section *)
   ; elf32_section_type    : num       (** Type of the section *)
   ; elf32_section_flags   : num       (** Flags associated with the section *)
   ; elf32_section_addr    : num       (** Base address of the section in memory *)
   ; elf32_section_offset  : num       (** Offset from beginning of file *)
   ; elf32_section_size    : num       (** Section size in bytes *)
   ; elf32_section_link    : num       (** Section header table index link *)
   ; elf32_section_info    : num       (** Extra information, depends on section type *)
   ; elf32_section_align   : num       (** Alignment constraints for section *)
   ; elf32_section_entsize : num       (** Size of each entry in table, if section is one *)
   ; elf32_section_body    : byte_sequence (** Body of section *)
   ; elf32_section_name_as_string : string (** Name of the section, as a string; "" for no name (name = 0) *)
   |>`;

   
(** [elf32_interpreted_section_equal s1 s2] is an equality test on interpreted
  * sections [s1] and [s2].
  *)
(*val elf32_interpreted_section_equal : elf32_interpreted_section -> elf32_interpreted_section -> bool*)
val _ = Define `
 (elf32_interpreted_section_equal x y=
     ((x.elf32_section_name = y.elf32_section_name) /\    
(x.elf32_section_type = y.elf32_section_type) /\    
(x.elf32_section_flags = y.elf32_section_flags) /\    
(x.elf32_section_addr = y.elf32_section_addr) /\    
(x.elf32_section_offset = y.elf32_section_offset) /\    
(x.elf32_section_size = y.elf32_section_size) /\    
(x.elf32_section_link = y.elf32_section_link) /\    
(x.elf32_section_info = y.elf32_section_info) /\    
(x.elf32_section_align = y.elf32_section_align) /\    
(x.elf32_section_entsize = y.elf32_section_entsize) /\ equal
    x.elf32_section_body y.elf32_section_body /\    
(x.elf32_section_name_as_string = y.elf32_section_name_as_string)))`;


(** [elf64_interpreted_section] exactly mirrors the structure of a section header
  * table entry, barring the conversion of all fields to more amenable types.
  *)
val _ = Hol_datatype `
 elf64_interpreted_section =
  <| elf64_section_name    : num       (** Name of the section *)
   ; elf64_section_type    : num       (** Type of the section *)
   ; elf64_section_flags   : num       (** Flags associated with the section *)
   ; elf64_section_addr    : num       (** Base address of the section in memory *)
   ; elf64_section_offset  : num       (** Offset from beginning of file *)
   ; elf64_section_size    : num       (** Section size in bytes *)
   ; elf64_section_link    : num       (** Section header table index link *)
   ; elf64_section_info    : num       (** Extra information, depends on section type *)
   ; elf64_section_align   : num       (** Alignment constraints for section *)
   ; elf64_section_entsize : num       (** Size of each entry in table, if section is one *)
   ; elf64_section_body    : byte_sequence (** Body of section *)
   ; elf64_section_name_as_string : string (** Name of the section, as a string; "" for no name (name = 0) *)
   |>`;


(** [compare_elf64_interpreted_section s1 s2] is an ordering comparison function
  * on interpreted sections suitable for use in sets, finite maps and other
  * ordered structures.
  *)
(*val compare_elf64_interpreted_section : elf64_interpreted_section -> elf64_interpreted_section ->
  ordering*)
val _ = Define `
 (compare_elf64_interpreted_section s1 s2=    
 (pairCompare (lexicographic_compare (genericCompare (<) (=))) compare_byte_sequence 
    ([s1.elf64_section_name    ;
      s1.elf64_section_type    ;
      s1.elf64_section_flags   ;
      s1.elf64_section_addr    ;
      s1.elf64_section_offset  ;
      s1.elf64_section_size    ;
      s1.elf64_section_link    ;
      s1.elf64_section_info    ;
      s1.elf64_section_align   ;
      s1.elf64_section_entsize], s1.elf64_section_body)
    ([s2.elf64_section_name    ;
      s2.elf64_section_type    ;
      s2.elf64_section_flags   ;
      s2.elf64_section_addr    ;
      s2.elf64_section_offset  ;
      s2.elf64_section_size    ;
      s2.elf64_section_link    ;
      s2.elf64_section_info    ;
      s2.elf64_section_align   ;
      s2.elf64_section_entsize], s2.elf64_section_body)))`;


val _ = Define `
(instance_Basic_classes_Ord_Elf_interpreted_section_elf64_interpreted_section_dict= (<|

  compare_method := compare_elf64_interpreted_section;

  isLess_method := (\ f1 .  (\ f2 .  (compare_elf64_interpreted_section f1 f2 = LT)));

  isLessEqual_method := (\ f1 .  (\ f2 .  (IN) (compare_elf64_interpreted_section f1 f2) ({LT; EQ})));

  isGreater_method := (\ f1 .  (\ f2 .  (compare_elf64_interpreted_section f1 f2 = GT)));

  isGreaterEqual_method := (\ f1 .  (\ f2 .  (IN) (compare_elf64_interpreted_section f1 f2) ({GT; EQ})))|>))`;


(** [elf64_interpreted_section_equal s1 s2] is an equality test on interpreted
  * sections [s1] and [s2].
  *)
(*val elf64_interpreted_section_equal : elf64_interpreted_section -> elf64_interpreted_section -> bool*)
val _ = Define `
 (elf64_interpreted_section_equal x y=
     ((x.elf64_section_name = y.elf64_section_name) /\    
(x.elf64_section_type = y.elf64_section_type) /\    
(x.elf64_section_flags = y.elf64_section_flags) /\    
(x.elf64_section_addr = y.elf64_section_addr) /\    
(x.elf64_section_offset = y.elf64_section_offset) /\    
(x.elf64_section_size = y.elf64_section_size) /\    
(x.elf64_section_link = y.elf64_section_link) /\    
(x.elf64_section_info = y.elf64_section_info) /\    
(x.elf64_section_align = y.elf64_section_align) /\    
(x.elf64_section_entsize = y.elf64_section_entsize) /\ equal
    x.elf64_section_body y.elf64_section_body /\    
(x.elf64_section_name_as_string = y.elf64_section_name_as_string)))`;


(** [null_elf32_interpreted_section] --- the null interpreted section.
  *)
(*val null_elf32_interpreted_section : elf32_interpreted_section*)
val _ = Define `
 (null_elf32_interpreted_section=  
 (<| elf32_section_name :=(( 0:num))
   ; elf32_section_type :=(( 0:num))
   ; elf32_section_flags :=(( 0:num))
   ; elf32_section_addr :=(( 0:num))
   ; elf32_section_offset :=(( 0:num))
   ; elf32_section_size :=(( 0:num))
   ; elf32_section_link :=(( 0:num))
   ; elf32_section_info :=(( 0:num))
   ; elf32_section_align :=(( 0:num))
   ; elf32_section_entsize :=(( 0:num)) 
   ; elf32_section_body := byte_sequence$empty
   ; elf32_section_name_as_string := ""
   |>))`;


(** [null_elf64_interpreted_section] --- the null interpreted section.
  *)
(*val null_elf64_interpreted_section : elf64_interpreted_section*)
val _ = Define `
 (null_elf64_interpreted_section=  
 (<| elf64_section_name :=(( 0:num))
   ; elf64_section_type :=(( 0:num))
   ; elf64_section_flags :=(( 0:num))
   ; elf64_section_addr :=(( 0:num))
   ; elf64_section_offset :=(( 0:num))
   ; elf64_section_size :=(( 0:num))
   ; elf64_section_link :=(( 0:num))
   ; elf64_section_info :=(( 0:num))
   ; elf64_section_align :=(( 0:num))
   ; elf64_section_entsize :=(( 0:num)) 
   ; elf64_section_body := byte_sequence$empty
   ; elf64_section_name_as_string := ""
   |>))`;


(** [elf64_interpreted_section_matches_section_header sect ent] checks whether
  * the interpreted section and the corresponding section header table entry
  * match.
  *)
(*val elf64_interpreted_section_matches_section_header : 
    elf64_interpreted_section
        -> elf64_section_header_table_entry
            -> bool*)
val _ = Define `
 (elf64_interpreted_section_matches_section_header i sh=
   ((i.elf64_section_name = w2n sh.elf64_sh_name) /\  
(i.elf64_section_type = w2n sh.elf64_sh_type) /\  
(i.elf64_section_flags = w2n sh.elf64_sh_flags) /\  
(i.elf64_section_addr = w2n sh.elf64_sh_addr) /\  
(i.elf64_section_offset = w2n sh.elf64_sh_offset) /\  
(i.elf64_section_size = w2n sh.elf64_sh_size) /\  
(i.elf64_section_link = w2n sh.elf64_sh_link) /\  
(i.elf64_section_info = w2n sh.elf64_sh_info) /\  
(i.elf64_section_align = w2n sh.elf64_sh_addralign) (* WHY? *) /\  
(i.elf64_section_entsize = w2n sh.elf64_sh_entsize)))`;

  (* Don't compare the name as a string, because it's implied by the shshtrtab index. *)
  (* NOTE that we can have multiple sections *indistinguishable*
   * except by their section header table index. Imagine 
   * multiple zero-size bss sections at the same address with the same name.
   * That's why in elf_memory_image we always label each ElfSection
   * with its SHT index.
   *)

val _ = type_abbrev( "elf32_interpreted_sections" , ``: elf32_interpreted_section list``);
val _ = type_abbrev( "elf64_interpreted_sections" , ``: elf64_interpreted_section list``);

(** [string_of_elf32_interpreted_section sect] returns a string-based representation
  * of interpreted section, [sect].
  *)
(*val string_of_elf32_interpreted_section : elf32_interpreted_section -> string*)

(** [string_of_elf64_interpreted_section sect] returns a string-based representation
  * of interpreted section, [sect].
  *)
(*val string_of_elf64_interpreted_section : elf64_interpreted_section -> string*)
   
(** [is_valid_elf32_section_header_table_entry sect stab] checks whether a
  * interpreted section conforms with the prescribed flags and types declared
  * in the "special sections" table of the ELF specification.
  * TODO: some of these entries in the table are overridden by ABI supplements.
  * Make sure it is these that are passed in rather than the default table
  * declared in the spec?
  *)
(*val is_valid_elf32_section_header_table_entry : elf32_interpreted_section ->
  string_table -> bool*)
val _ = Define `
 (is_valid_elf32_section_header_table_entry ent stbl=  
 ((case string_table$get_string_at ent.elf32_section_name stbl of
      Fail    f    => F
    | Success name =>
      (case FLOOKUP elf_special_sections name of
          NONE           => F (* ??? *)
        | SOME (typ, flags) =>            
(typ = ent.elf32_section_type) /\ (flags = ent.elf32_section_flags)
      )
  )))`;

  
(** [is_valid_elf64_section_header_table_entry sect stab] checks whether a
  * interpreted section conforms with the prescribed flags and types declared
  * in the "special sections" table of the ELF specification.
  * TODO: some of these entries in the table are overridden by ABI supplements.
  * Make sure it is these that are passed in rather than the default table
  * declared in the spec?
  *)  
(*val is_valid_elf64_section_header_table_entry : elf64_interpreted_section ->
  string_table -> bool*)
val _ = Define `
 (is_valid_elf64_section_header_table_entry ent stbl=  
 ((case string_table$get_string_at ent.elf64_section_name stbl of
      Fail    f    => F
    | Success name =>
      (case FLOOKUP elf_special_sections name of
          NONE           => F (* ??? *)
        | SOME (typ, flags) =>            
(typ = ent.elf64_section_type) /\ (flags = ent.elf64_section_flags)
      )
  )))`;

  
(** [is_valid_elf32_section_header_table sects] checks whether all entries in
  * [sect] are valid.
  *)
(*val is_valid_elf32_section_header_table : list elf32_interpreted_section ->
  string_table -> bool*)
val _ = Define `
 (is_valid_elf32_section_header_table0 ents stbl=  
 (EVERY (\ x .  is_valid_elf32_section_header_table_entry x stbl) ents))`;

  
(** [is_valid_elf64_section_header_table sects] checks whether all entries in
  * [sect] are valid.
  *)
(*val is_valid_elf64_section_header_table : list elf64_interpreted_section ->
  string_table -> bool*)
val _ = Define `
 (is_valid_elf64_section_header_table0 ents stbl=  
 (EVERY (\ x .  is_valid_elf64_section_header_table_entry x stbl) ents))`;
   
val _ = export_theory()

