(*Generated by Lem from gnu_extensions/gnu_ext_abi.lem.*)
open HolKernel Parse boolLib bossLib;
open lem_numTheory lem_listTheory lem_functionTheory lem_basic_classesTheory lem_boolTheory lem_maybeTheory lem_stringTheory lem_assert_extraTheory showTheory lem_sortingTheory missing_pervasivesTheory byte_sequenceTheory elf_types_native_uintTheory lem_tupleTheory elf_headerTheory elf_program_header_tableTheory elf_section_header_tableTheory elf_interpreted_sectionTheory elf_interpreted_segmentTheory elf_symbol_tableTheory elf_fileTheory elf_relocationTheory memory_imageTheory;

val _ = numLib.prefer_num();



val _ = new_theory "gnu_ext_abi"

(*open import Basic_classes*)
(*open import Function*)
(*open import String*)
(*open import Tuple*)
(*open import Bool*)
(*open import List*)
(*open import Sorting*)
(*open import Num*)
(*open import Maybe*)
(*open import Assert_extra*)
(*open import Show*)
(*open import Missing_pervasives*)

(*open import Byte_sequence*)

(* open import Abis *)

(*open import Elf_file*)
(*open import Elf_header*)
(*open import Elf_interpreted_segment*)
(*open import Elf_interpreted_section*)
(*open import Elf_program_header_table*)
(*open import Elf_section_header_table*)
(*open import Elf_symbol_table*)
(*open import Elf_types_native_uint*)
(*open import Elf_relocation*)
(*open import Elf_types_native_uint*)
(*open import Memory_image*)

(** Optional, like [stt_func] but always points to a function or piece of
  * executable code that takes no arguments and returns a function pointer.
  *)
val _ = Define `
 (stt_gnu_ifunc : num= (( 10:num)))`;


(*val gnu_extend: forall 'abifeature. abi 'abifeature -> abi 'abifeature*)
val _ = Define `
 (gnu_extend a=   
  (<| is_valid_elf_header := (a.is_valid_elf_header)
    ; make_elf_header     :=            
( (*  t -> entry -> shoff -> phoff -> phnum -> shnum -> shstrndx -> hdr *)\ t .  \ entry .  \ shoff .  \ phoff .  \ phnum .  \ shnum .  \ shstrndx . 
            let unmod = (a.make_elf_header t entry shoff phoff phnum shnum shstrndx)
            in
              <| elf64_ident    := ((case unmod.elf64_ident of 
                i0 :: i1 :: i2 :: i3  :: i4  :: i5  :: i6  :: 
                _  :: _  :: i9 :: i10 :: i11 :: i12 :: i13 :: i14 :: i15 :: []
                    => [i0; i1; i2; i3; i4; i5; i6;
                        (n2w : num -> unsigned_char) elf_osabi_gnu;
                        (n2w : num -> unsigned_char) (( 1:num));
                        i9; i10; i11; i12; i13; i14; i15]
                ))
               ; elf64_type     := ((n2w : num -> uint16) t)
               ; elf64_machine  := (unmod.elf64_machine)
               ; elf64_version  := (unmod.elf64_version)
               ; elf64_entry    := (unmod.elf64_entry)
               ; elf64_phoff    := ((n2w : num -> uint64) phoff)
               ; elf64_shoff    := ((n2w : num -> uint64) shoff)
               ; elf64_flags    := (unmod.elf64_flags)
               ; elf64_ehsize   := (unmod.elf64_ehsize)
               ; elf64_phentsize:= (unmod.elf64_phentsize)
               ; elf64_phnum    := ((n2w : num -> uint16) phnum)
               ; elf64_shentsize:= (unmod.elf64_shentsize)
               ; elf64_shnum    := ((n2w : num -> uint16) shnum)
               ; elf64_shstrndx := ((n2w : num -> uint16) shstrndx)
               |>)
    ; reloc               := (a.reloc)
    ; section_is_special  := (\ isec .  (\ img .  (
                                a.section_is_special isec img
                                \/ (missing_pervasives$string_prefix (((STRLEN ".gnu.warning"):num)) isec.elf64_section_name_as_string
                                 = SOME(".gnu.warning"))
        (* FIXME: This is a slight abuse. The GNU linker's treatment of 
         * ".gnu.warning.*" section is not really a function of the output
         * ABI -- it's a function of the input ABI, or arguably perhaps just
         * of the linker itself. We have to do something to make sure these
         * sections get silently processed separately from the usual linker
         * control script, because otherwise our link map output doesn't match
         * the GNU linker's. By declaring these sections "special" we achieve
         * this by saying they don't participate in linking proper, just like 
         * ".symtab" and similar sections don't. HMM. I suppose this is 
         * okay, in that although a non-GNU linker might happily link these
         * sections, arguably that is a failure to understand the input files. 
         * But the issue about it being a per-input-file property remains.
         * Q. What does the GNU linker do if a reloc input file whose OSABI
         * is *not* GNU contains a .gnu.warning.* section? That would be a fair
         * test about whether looking at the input ABI is worth doing. *)
                            )))
    ; section_is_large    := (a.section_is_large)
    ; maxpagesize         := (a.maxpagesize)
    ; minpagesize         := (a.minpagesize)
    ; commonpagesize      := (a.commonpagesize)
    ; symbol_is_generated_by_linker := (a.symbol_is_generated_by_linker)
    ; make_phdrs          := (a.make_phdrs) (* FIXME: also make the GNU phdrs! *)
    ; max_phnum           :=(( 1:num) + a.max_phnum) (* FIXME: GNU_RELRO, GNU_STACK; what else? *)
    ; guess_entry_point   := (a.guess_entry_point)
    ; pad_data            := (a.pad_data)
    ; pad_code            := (a.pad_code)
    ; generate_support    := (\ input_fnames_and_imgs .  
        let vanilla_support_img = (a.generate_support input_fnames_and_imgs) in
        (* also generate .note.gnu.build-id *)
        let new_by_range = ((SOME(".note.gnu.build-id", (( 0:num),( 24:num))), FileFeature(ElfSection(( 4:num) (* HACK: calculate this *), 
          <| elf64_section_name :=(( 0:num)) (* ignored *)
           ; elf64_section_type := sht_note
           ; elf64_section_flags := shf_alloc
           ; elf64_section_addr :=(( 0:num)) (* ignored -- covered by element *)
           ; elf64_section_offset :=(( 0:num)) (* ignored -- will be replaced when file offsets are assigned *)
           ; elf64_section_size :=(( 24:num)) (* ignored? NO, we use it in linker_script to avoid plumbing through the element record *)
           ; elf64_section_link :=(( 0:num))
           ; elf64_section_info :=(( 0:num))
           ; elf64_section_align :=(( 4:num))
           ; elf64_section_entsize :=(( 0:num))
           ; elf64_section_body := byte_sequence$empty (* ignored *)
           ; elf64_section_name_as_string := ".note.gnu.build-id"
           |>
        ))) INSERT vanilla_support_img.by_range)
        in
        <|  elements := ((vanilla_support_img.elements) |+ (".note.gnu.build-id", <|
                startpos := NONE
           ;    length1 := (SOME(( 24:num)))
           ;    contents := ([])
           |>))
         ;   by_tag := (by_tag_from_by_range new_by_range)
         ;   by_range := new_by_range
         |>)
    ; concretise_support  := (a.concretise_support)
    ; get_reloc_symaddr   := (a.get_reloc_symaddr)
    |>))`;

val _ = export_theory()

