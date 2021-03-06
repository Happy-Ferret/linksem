(*Generated by Lem from elf_note.lem.*)
open HolKernel Parse boolLib bossLib;
open lem_numTheory lem_listTheory lem_basic_classesTheory lem_stringTheory showTheory missing_pervasivesTheory errorTheory byte_sequenceTheory endiannessTheory elf_types_native_uintTheory elf_program_header_tableTheory elf_section_header_tableTheory;

val _ = numLib.prefer_num();



val _ = new_theory "elf_note"

(** [elf_note] contains data types and functions for interpreting the .note
  * section/segment of an ELF file, and extracting information from that
  * section/segment.
  *)

(*open import Basic_classes*)
(*open import List*)
(*open import Num*)
(*open import String*)

(*open import Byte_sequence*)
(*open import Endianness*)
(*open import Error*)
(*open import Missing_pervasives*)
(*open import Show*)

(*open import Elf_program_header_table*)
(*open import Elf_section_header_table*)
(*open import Elf_types_native_uint*)

(** [elf32_note] represents the contents of a .note section or segment.
  *)
val _ = Hol_datatype `
 elf32_note =
  <| elf32_note_namesz : uint32 (** The size of the name field. *)
   ; elf32_note_descsz : uint32 (** The size of the description field. *)
   ; elf32_note_type   : uint32 (** The type of the note. *)
   ; elf32_note_name   : word8 list  (** The list of bytes (of length indicated above) corresponding to the name string. *)
   ; elf32_note_desc   : word8 list  (** The list of bytes (of length indicated above) corresponding to the desc string. *)
   |>`;

   
(** [elf64_note] represents the contents of a .note section or segment.
  *)
val _ = Hol_datatype `
 elf64_note =
  <| elf64_note_namesz : uint64 (** The size of the name field. *)
   ; elf64_note_descsz : uint64 (** The size of the description field. *)
   ; elf64_note_type   : uint64 (** The type of the note. *)
   ; elf64_note_name   : word8 list   (** The list of bytes (of length indicated above) corresponding to the name string. *)
   ; elf64_note_desc   : word8 list   (** The list of bytes (of length indicated above) corresponding to the desc string. *)
   |>`;

   
(** [read_elf32_note endian bs0] transcribes an ELF note section from byte
  * sequence [bs0] assuming endianness [endian].  May fail if transcription fails
  * (i.e. if the byte sequence is not sufficiently long).
  *)
(*val read_elf32_note : endianness -> byte_sequence -> error (elf32_note * byte_sequence)*)
val _ = Define `
 (read_elf32_note endian bs0=  
 (read_elf32_word endian bs0 >>= (\ (namesz, bs0) . 
  read_elf32_word endian bs0 >>= (\ (descsz, bs0) . 
  read_elf32_word endian bs0 >>= (\ (typ, bs0) . 
  repeatM' (w2n namesz) bs0 read_char >>= (\ (name, bs0) . 
  repeatM' (w2n descsz) bs0 read_char >>= (\ (desc, bs0) . 
  return (<| elf32_note_namesz := namesz; elf32_note_descsz := descsz;
    elf32_note_type := typ; elf32_note_name := name; elf32_note_desc := desc |>,
      bs0))))))))`;

      
(** [read_elf64_note endian bs0] transcribes an ELF note section from byte
  * sequence [bs0] assuming endianness [endian].  May fail if transcription fails
  * (i.e. if the byte sequence is not sufficiently long).
  *)
(*val read_elf64_note : endianness -> byte_sequence -> error (elf64_note * byte_sequence)*)
val _ = Define `
 (read_elf64_note endian bs0=  
 (read_elf64_xword endian bs0 >>= (\ (namesz, bs0) . 
  read_elf64_xword endian bs0 >>= (\ (descsz, bs0) . 
  read_elf64_xword endian bs0 >>= (\ (typ, bs0) . 
  repeatM' (w2n namesz) bs0 read_char >>= (\ (name, bs0) . 
  repeatM' (w2n descsz) bs0 read_char >>= (\ (desc, bs0) . 
  return (<| elf64_note_namesz := namesz; elf64_note_descsz := descsz;
    elf64_note_type := typ; elf64_note_name := name; elf64_note_desc := desc |>,
      bs0))))))))`;

      
(** [obtain_elf32_note_sections endian sht bs0] returns all note sections present
  * in an ELF file, as indicated by the file's section header table [sht], reading
  * them from byte sequence [bs0] assuming endianness [endian].  May fail if
  * transcription of a note section fails.
  *)
(*val obtain_elf32_note_sections : endianness -> elf32_section_header_table ->
  byte_sequence -> error (list elf32_note)*)
val _ = Define `
 (obtain_elf32_note_sections endian sht bs0=  
 (let note_sects =    
(FILTER (\ x . 
      x.elf32_sh_type = (n2w : num -> uint32) sht_note
    ) sht)
  in
    mapM (\ x . 
      let offset = (w2n x.elf32_sh_offset) in
      let size1   = (w2n x.elf32_sh_size) in
      byte_sequence$offset_and_cut offset size1 bs0 >>= (\ rel . 
      read_elf32_note endian rel >>= 
  (\p .  (case (p ) of ( (note, _) ) => return note )))
    ) note_sects))`;

    
(** [obtain_elf64_note_sections endian sht bs0] returns all note sections present
  * in an ELF file, as indicated by the file's section header table [sht], reading
  * them from byte sequence [bs0] assuming endianness [endian].  May fail if
  * transcription of a note section fails.
  *)
(*val obtain_elf64_note_sections : endianness -> elf64_section_header_table ->
  byte_sequence -> error (list elf64_note)*)
val _ = Define `
 (obtain_elf64_note_sections endian sht bs0=  
 (let note_sects =    
(FILTER (\ x . 
      x.elf64_sh_type = (n2w : num -> uint32) sht_note
    ) sht)
  in
    mapM (\ x . 
      let offset = (w2n x.elf64_sh_offset) in
      let size1   = (w2n x.elf64_sh_size) in
      byte_sequence$offset_and_cut offset size1 bs0 >>= (\ rel . 
      read_elf64_note endian rel >>= 
  (\p .  (case (p ) of ( (note, _) ) => return note )))
    ) note_sects))`;

    
(** [obtain_elf32_note_segments endian pht bs0] returns all note segments present
  * in an ELF file, as indicated by the file's program header table [pht], reading
  * them from byte sequence [bs0] assuming endianness [endian].  May fail if
  * transcription of a note section fails.
  *)
(*val obtain_elf32_note_segments : endianness -> elf32_program_header_table ->
  byte_sequence -> error (list elf32_note)*)
val _ = Define `
 (obtain_elf32_note_segments endian pht bs0=  
 (let note_segs =    
(FILTER (\ x . 
      x.elf32_p_type = (n2w : num -> uint32) elf_pt_note
    ) pht)
  in
    mapM (\ x . 
      let offset = (w2n x.elf32_p_offset) in
      let size1   = (w2n x.elf32_p_filesz) in
      byte_sequence$offset_and_cut offset size1 bs0 >>= (\ rel . 
      read_elf32_note endian rel >>= 
  (\p .  (case (p ) of ( (note, _) ) => return note )))
    ) note_segs))`;

    
(** [obtain_elf64_note_segments endian pht bs0] returns all note segments present
  * in an ELF file, as indicated by the file's program header table [pht], reading
  * them from byte sequence [bs0] assuming endianness [endian].  May fail if
  * transcription of a note section fails.
  *)
(*val obtain_elf64_note_segments : endianness -> elf64_program_header_table ->
  byte_sequence -> error (list elf64_note)*)
val _ = Define `
 (obtain_elf64_note_segments endian pht bs0=  
 (let note_segs =    
(FILTER (\ x . 
      x.elf64_p_type = (n2w : num -> uint32) elf_pt_note
    ) pht)
  in
    mapM (\ x . 
      let offset = (w2n x.elf64_p_offset) in
      let size1   = (w2n x.elf64_p_filesz) in
      byte_sequence$offset_and_cut offset size1 bs0 >>= (\ rel . 
      read_elf64_note endian rel >>= 
  (\p .  (case (p ) of ( (note, _) ) => return note )))
    ) note_segs))`;

    
(** [obtain_elf32_note_section_and_segments endian pht sht bs0] returns all note
  * sections and segments present in an ELF file, as indicated by the file's
  * program header table [pht] and section header table [sht], reading
  * them from byte sequence [bs0] assuming endianness [endian].  May fail if
  * transcription of a note section or segment fails.
  *)
(*val obtain_elf32_note_section_and_segments : endianness -> elf32_program_header_table ->
  elf32_section_header_table -> byte_sequence -> error (list elf32_note)*)
val _ = Define `
 (obtain_elf32_note_section_and_segments endian pht sht bs0=  
 (obtain_elf32_note_segments endian pht bs0 >>= (\ pht_notes . 
  obtain_elf32_note_sections endian sht bs0 >>= (\ sht_notes . 
  return (pht_notes ++ sht_notes)))))`;

  
(** [obtain_elf64_note_section_and_segments endian pht sht bs0] returns all note
  * sections and segments present in an ELF file, as indicated by the file's
  * program header table [pht] and section header table [sht], reading
  * them from byte sequence [bs0] assuming endianness [endian].  May fail if
  * transcription of a note section or segment fails.
  *)
(*val obtain_elf64_note_section_and_segments : endianness -> elf64_program_header_table ->
  elf64_section_header_table -> byte_sequence -> error (list elf64_note)*)
val _ = Define `
 (obtain_elf64_note_section_and_segments endian pht sht bs0=  
 (obtain_elf64_note_segments endian pht bs0 >>= (\ pht_notes . 
  obtain_elf64_note_sections endian sht bs0 >>= (\ sht_notes . 
  return (pht_notes ++ sht_notes)))))`;

    
(** [name_string_of_elf32_note note] extracts the name string of an ELF note
  * section, interpreting the section's uninterpreted name field as a string.
  *)
(*val name_string_of_elf32_note : elf32_note -> string*)
val _ = Define `
 (name_string_of_elf32_note note=  
 (let bs0   = (byte_sequence$from_byte_lists [note.elf32_note_name]) in
    byte_sequence$string_of_byte_sequence bs0))`;

  
(** [name_string_of_elf64_note note] extracts the name string of an ELF note
  * section, interpreting the section's uninterpreted name field as a string.
  *)  
(*val name_string_of_elf64_note : elf64_note -> string*)
val _ = Define `
 (name_string_of_elf64_note note=  
 (let bs0   = (byte_sequence$from_byte_lists [note.elf64_note_name]) in
    byte_sequence$string_of_byte_sequence bs0))`;
 
val _ = export_theory()

