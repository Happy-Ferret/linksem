(* Generated by Lem from elf_memory_image_of_elf64_file.lem. *)

Require Import Arith.
Require Import Bool.
Require Import List.
Require Import String.
Require Import Program.Wf.

Require Import coqharness.

Open Scope nat_scope.
Open Scope string_scope.

Require Import lem_basic_classes.
Require Export lem_basic_classes.

Require Import lem_function.
Require Export lem_function.

Require Import lem_string.
Require Export lem_string.

Require Import lem_tuple.
Require Export lem_tuple.

Require Import lem_bool.
Require Export lem_bool.

Require Import lem_list.
Require Export lem_list.

Require Import lem_sorting.
Require Export lem_sorting.

Require Import lem_map.
Require Export lem_map.

Require Import lem_set.
Require Export lem_set.

Require Import lem_num.
Require Export lem_num.

Require Import lem_maybe.
Require Export lem_maybe.

Require Import lem_assert_extra.
Require Export lem_assert_extra.


Require Import byte_sequence.
Require Export byte_sequence.

Require Import default_printing.
Require Export default_printing.

Require Import error.
Require Export error.

Require Import missing_pervasives.
Require Export missing_pervasives.

Require Import show.
Require Export show.

Require Import endianness.
Require Export endianness.


Require Import elf_header.
Require Export elf_header.

Require Import elf_file.
Require Export elf_file.

Require Import elf_interpreted_section.
Require Export elf_interpreted_section.

Require Import elf_interpreted_segment.
Require Export elf_interpreted_segment.

Require Import elf_section_header_table.
Require Export elf_section_header_table.

Require Import elf_program_header_table.
Require Export elf_program_header_table.

Require Import elf_symbol_table.
Require Export elf_symbol_table.

Require Import elf_types_native_uint.
Require Export elf_types_native_uint.

Require Import elf_relocation.
Require Export elf_relocation.

Require Import string_table.
Require Export string_table.


Require Import memory_image.
Require Export memory_image.

Require Import memory_image_orderings.
Require Export memory_image_orderings.


Require Import elf_memory_image.
Require Export elf_memory_image.

(* [?]: removed value specification. *)

Definition section_name_is_unique  (name1 : string ) (f : elf64_file )  : bool := 
    match ( mapMaybe (fun (sec : elf64_interpreted_section ) => 
        if (string_equal name1(elf64_section_name_as_string sec)) then Some sec else None
    )(elf64_file_interpreted_sections f)) with
    
        [_] => true
        | _ => false
    end.
(* [?]: removed value specification. *)

Definition create_unique_name_for_section_from_index  (idx1 : nat ) (s : elf64_interpreted_section ) (f : elf64_file )  : string := 
    let secname1 :=(elf64_section_name_as_string s)
    in if section_name_is_unique secname1 f then secname1 else gensym secname1.
(* [?]: removed value specification. *)

Definition create_unique_name_for_common_symbol_from_linkable_name  (fname1 : string ) (syment : elf64_symbol_table_entry ) (symname : string ) (f : elf64_file )  : string :=  
    (* FIXME: uniqueness? I suppose file names are unique. How to avoid overlapping with 
     * section names? *)
     String.append fname1  (String.append"_" symname).
(* [?]: removed value specification. *)

Definition get_unique_name_for_common_symbol_from_linkable_name  (fname1 : string ) (syment : elf64_symbol_table_entry ) (symname : string )  : string :=  
    (* FIXME: uniqueness? I suppose file names are unique. How to avoid overlapping with 
     * section names? *)
     String.append fname1  (String.append"_" symname).
(* [?]: removed value specification. *)

Definition elf_memory_image_of_elf64_file {abifeature : Type}  (a : abi abifeature) (fname1 : string ) (f : elf64_file )  : annotated_memory_image (abis.any_abi_feature ):=  
    (* Do we have program headers? This decides whether we choose a 
     * sectionwise or segmentwise view. *)
    match ((elf64_file_program_header_table f)) with 
        [] =>   let extracted_symbols :=  (extract_definitions_from_symtab_of_type sht_symtab f)
                in
                let interpreted_sections_without_null := match ((elf64_file_interpreted_sections f)) with 
                    [] => DAEMON
                    | null_entry :: more => more
                end
                in
                let section_names_and_elements := mapMaybei (fun (i : nat ) => (fun (isec1 : elf64_interpreted_section ) => 
                    (* In principle, we can have unnamed sections. But 
                     * don't add the dummy initial SHT entry. This is *not* in the 
                     * list of interpreted sections. *)
                    if elf64_interpreted_section_equal isec1 null_elf64_interpreted_section then
                        (if beq_nat i( 0) then None else DAEMON)
                    else 
                        if beq_nat i( 0) then DAEMON
                        else
                        let created_name := create_unique_name_for_section_from_index i isec1 f
                        in
                        (*let _ = errln ("In file " ^ fname ^ " created element name " ^ created_name ^ " for section idx " ^ (show i) ^ ", name " ^ 
                            isec.elf64_section_name_as_string)
                        in*)
                        Some (created_name, {|startpos := None
                      ;length1 := (Some(elf64_section_size isec1))
                      ;contents := (byte_pattern_of_byte_sequence(elf64_section_body isec1))
                    |})
                ))(elf64_file_interpreted_sections f)
                in
                let common_symbols := (List.filter (fun (x : symbol_definition ) => beq_nat (nat_of_elf64_half ((elf64_st_shndx(def_symentx)))) shn_common) extracted_symbols)
                in
                (*let _ = Missing_pervasives.errln ("Found " ^ (show (length common_symbols)) ^ " common symbols in file " ^ fname)
                in*)
                let common_symbol_names_and_elements := mapMaybei (fun (i : nat ) => (fun (isym : symbol_definition ) => 
                    let symlen := nat_of_elf64_xword(elf64_st_size(def_syment isym))
                    in
                    Some (get_unique_name_for_common_symbol_from_linkable_name fname1(def_syment isym)(def_symname isym), {|startpos := None
                      ;length1 := (Some symlen)
                      ;contents := (missing_pervasives.replicate0 symlen None)
                    |})
                )) common_symbols
                in
                let all_names_and_elements :=  (@ List.app _)section_names_and_elements common_symbol_names_and_elements
                in
                (* -- annotations are reloc sites, symbol defs, ELF sections/segments/headers, PLT/GOT/...
                 * Since we stripped the null SHT entry, mapMaybei would ideally index from one. We add one.  *)
                let elf_sections := mapMaybei (fun (secidx_minus_one : nat ) => (
                    (
  fun (p : (elf64_interpreted_section *((string *element ) % type)) % type) =>
    match ( (p) ) with ( (isec1,  (secname1,  _))) =>
      let r := (Some (secname1, ( 0,(elf64_section_size isec1)))) in
    Some
      (r, FileFeature
            (ElfSection ( Coq.Init.Peano.plus secidx_minus_one ( 1), isec1)))
    end
                    )))
                    (zip interpreted_sections_without_null section_names_and_elements)
                in
                let symbol_defs := mapMaybe
                    (fun (x : symbol_definition ) => 
                        let section_num := nat_of_elf64_half(elf64_st_shndx(def_syment x))
                        in
                        let labelled_range := 
                            if beq_nat section_num shn_abs then
                                (* We have an annotation that doesn't apply to any range.
                                 * That's all right -- that's why the range is a maybe. *)
                                None
                            else if beq_nat section_num shn_common then 
                                (* Each common symbol becomes its own elemenet (\approx section).
                                 * We label *that element* with a (coextensive) symbol definition. *)
                                 let element_name := get_unique_name_for_common_symbol_from_linkable_name 
                                    fname1(def_syment x)(def_symname x)
                                 in
                                 Some(element_name, ( 0, nat_of_elf64_xword(elf64_st_size(def_syment x))))
                            else 
  match ( match ( index0 ( Coq.Init.Peano.minus section_num ( 1))
                    section_names_and_elements) with Some x => x | None =>
            DAEMON end) with (section_name,  _) =>
    Some
      (section_name, (nat_of_elf64_addr (elf64_st_value(def_syment x)), 
      nat_of_elf64_xword (elf64_st_size(def_syment x)))) end
                        in
                        Some (labelled_range, SymbolDef(x))
                    )
                    (extract_definitions_from_symtab_of_type sht_symtab f)
                in
                (* FIXME: should a common symbol be a reference too? 
                 * I prefer to think of common symbols as mergeable sections. 
                 * Under this interpretation, there's no need for a reference. 
                 * BUT the GC behaviour might be different! What happens if
                 * a common symbol is not referenced? *)
                let symbol_refs := mapMaybe
                    (fun  (x : symbol_reference ) => 
                        Some (None, SymbolRef({|ref := x;maybe_reloc := None;maybe_def_bound_to := None |}))
                    )
                    (extract_references_from_symtab_of_type sht_symtab f)
                in
                let all_reloc_sites := List.map 
                    (fun  (x : symbol_reference_and_reloc_site ) =>
                        let rel := match ((maybe_reloc x)) with  
                            Some rel => rel
                            | None => DAEMON
                        end
                        in 
  match ( match ( index0 ( Coq.Init.Peano.minus (ref_src_scnrel) ( 1))
                    section_names_and_elements) with Some y => y | None =>
            DAEMON end) with (section_name,  _) =>
    match ((reloc a) (get_elf64_relocation_a_type (ref_relent rel))) with
        (_,  applyfn) =>
      match ( applyfn (get_empty_memory_image tt) ( 0) x) with
          (width,  calcfn) =>
        (* FIXME: for copy relocs, the size depends on the *definition*.
                             AHA! a copy reloc always *has* a symbol definition locally; it just gets its *value*
                             from the shared object's definition.
                             In other words, a copy reloc always references a defined symbol, and the amount
                             copied is the minimum of that symbol's size and the overridden (copied-from .so)'s 
                             symbol's size. *)
      let offset :=(elf64_ra_offset(ref_relent rel)) in
      ((section_name, (nat_of_elf64_addr offset, width)), SymbolRef (x))
      (* GAH. We don't have an image. 
                            If we pass an empty memory image, will we fail? Need to make it work *)
      end end end
                    )
                    (extract_all_relocs_as_symbol_references fname1 f)
                in
                let all_reloc_pairs := List.map (
  fun (p : (((string *range ) % type)*range_tag (abis.any_abi_feature )) % type) =>
    match ( (p) ) with ( (el_range,  r_tag)) => (Some el_range, r_tag) end) all_reloc_sites
                in
                let reloc_as_triple := 
  fun (p : (range_tag (bool )*range_tag (bool )) % type) =>
    match ( (p) ) with ( (_,  x)) =>
      (match ( x) with SymbolRef(r) =>
         match ((maybe_reloc r)) with Some rel =>
           ((ref_rel_scnrel),(ref_rel_idx rel),(ref_src_scn rel)) | None =>
           DAEMON end | _ => DAEMON end) end
                in
                (*let _ = Missing_pervasives.errln ("Extracted " ^ (show (length all_reloc_sites)) ^ " reloc site tags from "
                    ^ "file " ^ fname ^ ": " ^ (show (List.map reloc_as_triple all_reloc_sites)))
                in*)
                let retrieved_reloc_sites := multimap.lookupBy0 memory_image_orderings.tagEquiv
                    (SymbolRef(null_symbol_reference_and_reloc_site)) 
                    (
  match ( unzip all_reloc_sites) with (fst,  snd) =>
    (set_from_list_by
       (pairCompare
          (fun (x : range_tag (abis.any_abi_feature )) (y : range_tag (abis.any_abi_feature ))=>
             EQ)
          (pairCompare (fun (x : string ) (y : string )=> EQ)
             (pairCompare (genericCompare nat_ltb beq_nat)
                (genericCompare nat_ltb beq_nat)))) (zip snd fst)) end)
                in
                (*let _ = Missing_pervasives.errln ("Re-reading: retrieved " ^ (show (length retrieved_reloc_sites)) ^ " reloc site tags from "
                    ^ "file " ^ fname ^ ": " ^ (show (List.map reloc_as_triple (let (fst, snd) = unzip retrieved_reloc_sites in zip snd fst))))
                in*)
                let elf_header := [(Some("header", ( 0, nat_of_elf64_half(elf64_ehsize(elf64_file_header f)))), FileFeature(ElfHeader((elf64_file_headerf))))]
                in
                (*let _ = Missing_pervasives.errln ("ELF header contributes " ^ (show (List.length elf_header)) ^ " annotations.")
                in*)
                let all_annotations_list :=  (@ List.app _) ((@ List.app _) ((@ List.app _) ((@ List.app _)all_reloc_pairs symbol_refs) symbol_defs) elf_sections) elf_header
                in
                let all_annotations_length := List.length all_annotations_list
                in
                (*let _ = Missing_pervasives.errln ("total annotations: " ^ (show all_annotations_length))
                in*)
                let all_annotations := (set_from_list_by (pairCompare (maybeCompare (pairCompare (fun (x : string ) (y : string )=>EQ) (pairCompare (genericCompare nat_ltb beq_nat) (genericCompare nat_ltb beq_nat)))) (fun (x : range_tag (abis.any_abi_feature )) (y : range_tag (abis.any_abi_feature ))=>EQ)) all_annotations_list)
                in
                let apply_content_relocations := (fun  (name1 : string ) => (fun (content : list (option (byte ) )) => 
                    let this_element_reloc_sites := List.filter (
  fun (p : (((string *((nat *nat ) % type)) % type)*range_tag (abis.any_abi_feature )) % type) =>
    match ( (p) ) with ( ((n,  range1),  _)) => (string_equal name1 n) end) all_reloc_sites
                    in 
  match ( unzip this_element_reloc_sites) with
      (this_element_name_and_reloc_ranges,  _) =>
    let this_element_reloc_ranges := (@ snd _ _)
                                       (unzip
                                          this_element_name_and_reloc_ranges)
  in
  let all_ranges_expanded := expand_unsorted_ranges this_element_reloc_ranges
                               (missing_pervasives.length content) [] in
  relax_byte_pattern content all_ranges_expanded end
                ))
                in
                let new_elements_list := List.map (
  fun (p : (string *element ) % type) =>
    match ( (p) ) with ( (name1,  element1)) =>
      (* We can now mark the relocation sites in the section contents as "subject to change". *)
    ( name1, {|startpos :=(startpos element1) ;length1 :=(length1 element1)
    ;contents := (
    (*let _ = errln ("Reloc-relaxing section " ^ name ^ " in file " ^ fname ^ ": before, first 20 bytes: " ^
                                (show (take 20 element.contents)))
                            in*) let relaxed := 
    apply_content_relocations name1 (contents element1) in
    (*let _ = errln ("After, first 20 bytes: " ^  (show (take 20 relaxed)))
                            in*)
    relaxed) |}) end
                  ) all_names_and_elements
                in
                            (*
                            List.foldr (fun acc -> (fun  element.contents this_element_reloc_ranges
                            let (expand_and_relax : list (maybe byte) -> (natural * natural) -> list (maybe byte)) = fun pat -> (fun r -> (
                                relax_byte_pattern pat (expand_ranges r)
                            ))
                            in*)
                 {|elements := (lem_map.fromList new_elements_list)
                      (* : memory_image -- the image elements, without annotation, i.e. 
                        a map from string to (startpos, length, contents)
                        -- an element is the ELF header, PHT, SHT, section or segment
                        -- exploit the fact that section names beginning `.' are reserved, and 
                           the reserved ones don't use caps: ".PHT", ".SHT", ".HDR"
                        -- what about ambiguous section names? use ".GENSYM_<...>" perhaps 
                      *)
                    ;by_range := all_annotations
                    ;by_tag := 
  match ( unzip all_annotations_list) with (fst,  snd) =>
    (set_from_list_by
       (pairCompare
          (fun (x : range_tag (abis.any_abi_feature )) (y : range_tag (abis.any_abi_feature ))=>
             EQ)
          (maybeCompare
             (pairCompare (fun (x : string ) (y : string )=> EQ)
                (pairCompare (genericCompare nat_ltb beq_nat)
                   (genericCompare nat_ltb beq_nat))))) (zip snd fst)) end
                        (*  : multimap (elf_range_tag 'symdef 'reloc 'filefeature 'abifeature) (string * range) 
                         -- annotations by *)
                  |}
      | pht => let segment_names_and_images := mapMaybei (fun (i : nat ) => (fun (seg : elf64_interpreted_segment ) => 
                    Some( String.append(gensym (hex_string_of_natural(elf64_segment_base seg)))  (String.append"_" (hex_string_of_natural(elf64_segment_type seg))), 
                    {|startpos := (Some(elf64_segment_base seg))
                      ;length1 := (Some(elf64_segment_memsz seg))
                      ;contents := [] (* FIXME *)
                     |})
                ))(elf64_file_interpreted_segments f)
                in
                (* let annotations = *)
                 {|elements := (lem_map.fromList segment_names_and_images)  (* : memory_image -- the image elements, without annotation, i.e. 
                        a map from string to (startpos, length, contents)
                        -- an element is the ELF header, PHT, SHT, section or segment
                        -- exploit the fact that section names beginning `.' are reserved, and 
                           the reserved ones don't use caps: ".PHT", ".SHT", ".HDR"
                        -- what about ambiguous section names? use ".GENSYM_<...>" perhaps 
                      *)
                    ;by_range := (set_from_list_by (pairCompare (maybeCompare (pairCompare (fun (x : string ) (y : string )=>EQ) (pairCompare (genericCompare nat_ltb beq_nat) (genericCompare nat_ltb beq_nat)))) (fun (x : range_tag (abis.any_abi_feature )) (y : range_tag (abis.any_abi_feature ))=>EQ)) [])
                        (* : map element_range (list (elf_range_tag 'symdef 'reloc 'filefeature 'abifeature))
                         -- annotations are reloc sites, symbol defs, ELF sections/segments/headers, PLT/GOT/...  *)
                    ;by_tag := (set_from_list_by (pairCompare (fun (x : range_tag (abis.any_abi_feature )) (y : range_tag (abis.any_abi_feature ))=>EQ) (maybeCompare (pairCompare (fun (x : string ) (y : string )=>EQ) (pairCompare (genericCompare nat_ltb beq_nat) (genericCompare nat_ltb beq_nat))))) [])
                        (*  : multimap (elf_range_tag 'symdef 'reloc 'filefeature 'abifeature) (string * range) 
                         -- annotations by *)
                  |}

    end.
(* [?]: removed value specification. *)

Definition elf_memory_image_header  (img3 : annotated_memory_image (abis.any_abi_feature ))  : elf64_header :=  
    match ( unique_tag_matching (FileFeature(ElfHeader(null_elf_header))) img3) with 
        FileFeature(ElfHeader(x)) => x
        | _ => DAEMON
    end.
(* [?]: removed value specification. *)

Definition elf_memory_image_sht  (img3 : annotated_memory_image (abis.any_abi_feature ))  : option (list (elf64_section_header_table_entry )) :=  
    match ( unique_tag_matching (FileFeature(null_section_header_table)) img3) with 
        FileFeature(ElfSectionHeaderTable(x)) => Some x
        | _ => None
    end.
(* [?]: removed value specification. *)

Definition elf_memory_image_section_ranges  (img3 : annotated_memory_image (abis.any_abi_feature ))  : (list (range_tag (abis.any_abi_feature ))*list (element_range )) % type:=  
    (* find all element ranges labelled as ELF sections *)
    let tagged_ranges := tagged_ranges_matching_tag (FileFeature(ElfSection( 0, null_elf64_interpreted_section))) img3
    in match ( unzip tagged_ranges) with (tags,  maybe_ranges) =>
   (tags, make_ranges_definite maybe_ranges) end.
(* [?]: removed value specification. *)

Definition elf_memory_image_section_by_index  (idx1 : nat ) (img3 : annotated_memory_image (abis.any_abi_feature ))  : option (elf64_interpreted_section ) :=  
  (* find all element ranges labelled as ELF sections *)
  match ( elf_memory_image_section_ranges img3) with
      (allSectionTags,  allSectionElementRanges) =>
    let matches := mapMaybei
                     (fun (i : nat ) =>
                        (fun (tag : range_tag (abis.any_abi_feature )) =>
                           match ( tag) with
                               FileFeature(ElfSection(itsIdx,  s)) =>
                             if beq_nat itsIdx idx1 then Some s else None
                             | _ => DAEMON end)) allSectionTags in
  match ( matches) with [] => None | [x] => Some x | x => DAEMON end end.
(* [?]: removed value specification. *)

Definition elf_memory_image_element_coextensive_with_section  (idx1 : nat ) (img3 : annotated_memory_image (abis.any_abi_feature ))  : option (string ) :=  
  (* find all element ranges labelled as ELF sections *)
  match ( elf_memory_image_section_ranges img3) with
      (allSectionTags,  allSectionElementRanges) =>
    let matches := mapMaybei
                     (fun (i : nat ) =>
                        (fun (p : (range_tag (abis.any_abi_feature )*((string *((nat *nat ) % type)) % type)) % type) =>
                           match ( (p) ) with
                               ( (tag,  (elName,  (rangeStart,  rangeLen)))) =>
                             match ( tag) with
                                 FileFeature(ElfSection(itsIdx,  s)) =>
                               let el_rec := match ( (fmap_lookup_by
                                                        (fun (x : string ) (y : string )=>
                                                           EQ) elName
                                                        (elements img3))) with
                                                 Some x => x | None => 
                                             DAEMON end in
                             let size_matches :=
                             (* HMM. This is complicated. Generally we like to ignore 
                 * isec fields that are superseded by memory_image fields, 
                 * here the element length. But we want to catch the case
                 * where there's an inconsistency, and we *might* want to allow the
                 * case where the element length is still vague (Nothing). *)
                             let range_len_matches_sec := ( beq_nat rangeLen
                                                              (elf64_section_size s))
                             in
                             let sec_matches_element_len := ( (maybeEqualBy
                                                                 beq_nat
                                                                 (Some
                                                                    ((elf64_section_sizes)))
                                                                 (length1 el_rec)))
                             in
                             let range_len_matches_element_len := ( (
                             maybeEqualBy beq_nat (Some (rangeLen))
                               (length1 el_rec))) in
                             (* If any pair are unequal, then warn. *)
                             (*let _ = 
                if (range_len_matches_sec <> sec_matches_element_len
                 || sec_matches_element_len <> range_len_matches_element_len
                 || range_len_matches_sec <> range_len_matches_element_len)
                then errln ("Warning: section lengths do not agree: " ^ s.elf64_section_name_as_string)
                else ()
                in*)
                             range_len_matches_element_len in
                             if beq_nat itsIdx idx1 &&
                                (beq_nat rangeStart ( 0) && size_matches)
                             then
                               (* *) (* Sanity check: does the *) Some elName
                             else None | _ => DAEMON end end))
                     (zip allSectionTags allSectionElementRanges) in
  match ( matches) with [] => None | [x] => Some x | xs => DAEMON end end.
(* [?]: removed value specification. *)

Definition name_of_elf_interpreted_section  (s : elf64_interpreted_section ) (shstrtab : elf64_interpreted_section )  : option (string ) :=  
    match ( get_string_at(elf64_section_name s) (string_table_of_byte_sequence(elf64_section_body shstrtab))) with 
        Success(x) => Some x
        | Fail(e) => None
    end.
(* [?]: removed value specification. *)

Definition elf_memory_image_sections_with_indices  (img3 : annotated_memory_image (abis.any_abi_feature ))  : list ((elf64_interpreted_section *nat ) % type):=  
  (* We have to get all sections and their names,
     * because section names need not be unique. *)
  match ( elf_memory_image_section_ranges img3) with
      (all_section_tags,  all_section_ranges) =>
    List.map
      (fun (tag : range_tag (abis.any_abi_feature )) =>
         match ( tag) with FileFeature(ElfSection(idx1,  i)) => (i, idx1)
           | _ => DAEMON end) all_section_tags end.
(* [?]: removed value specification. *)

Definition elf_memory_image_sections  (img3 : annotated_memory_image (abis.any_abi_feature ))  : list (elf64_interpreted_section ):=  
  match ( unzip (elf_memory_image_sections_with_indices img3)) with
      (secs,  _) => secs end.
(* [?]: removed value specification. *)

Definition elf_memory_image_sections_with_name  (name1 : string ) (img3 : annotated_memory_image (abis.any_abi_feature ))  : list (elf64_interpreted_section ):=  
    let all_interpreted_sections := elf_memory_image_sections img3
    in
    let maybe_shstrtab := elf_memory_image_section_by_index (nat_of_elf64_half ((elf64_shstrndx(elf_memory_image_header img3)))) img3
    in
    let shstrtab := match ( maybe_shstrtab) with  
        None => DAEMON
        | Some x => x
    end
    in
    let all_section_names := List.map (fun (i : elf64_interpreted_section ) => 
        let stringtab := string_table_of_byte_sequence ((elf64_section_bodyshstrtab)) in
        match ( get_string_at(elf64_section_name i) stringtab) with 
            Fail _ => None
            | Success x => Some x
        end) all_interpreted_sections
    in
    mapMaybe (fun (p : (option (string ) *elf64_interpreted_section ) % type) =>
  match ( (p) ) with ( (n,  i)) =>
    if (maybeEqualBy
          (fun (left : string ) (right : string )=> (string_equal left right))
          (Some (name1)) n) then Some i else None end) (zip all_section_names all_interpreted_sections).
(* [?]: removed value specification. *)

Definition elf_memory_image_symbol_def_ranges  (img3 : annotated_memory_image (abis.any_abi_feature ))  : (list (range_tag (abis.any_abi_feature ))*list (option (element_range ) )) % type:=  
  (* find all element ranges labelled as ELF symbols *)
  match ( unzip
            (
            tagged_ranges_matching_tag (SymbolDef (null_symbol_definition))
              img3 )) with (tags,  maybe_ranges) =>
    (* some symbols, specifically ABS symbols, needn't label a range. *)
  (tags, maybe_ranges) end.
(* [?]: removed value specification. *)

Definition name_of_symbol_def0  (sym : symbol_definition )  : string := (def_symname sym).
(* [?]: removed value specification. *)

Definition elf_memory_image_defined_symbols_and_ranges  (img3 : annotated_memory_image (abis.any_abi_feature ))  : list ((option (element_range ) *symbol_definition ) % type):=  
    memory_image_orderings.defined_symbols_and_ranges img3.
(* [?]: removed value specification. *)

Definition elf_memory_image_defined_symbols  (img3 : annotated_memory_image (abis.any_abi_feature ))  : list (symbol_definition ):=  
  match ( elf_memory_image_symbol_def_ranges img3) with
      (all_symbol_tags,  all_symbol_ranges) =>
    lem_list.mapMaybe
      (fun (tag : range_tag (abis.any_abi_feature )) =>
         match ( tag) with SymbolDef(ent) => Some ent | _ => DAEMON end)
      all_symbol_tags end.
(* [?]: removed value specification. *)

Definition name_of_elf_section  (sec : elf64_interpreted_section ) (img3 : annotated_memory_image (abis.any_abi_feature ))  : option (string ) :=  
   (* let shstrndx = natural_of_elf64_half ((elf_memory_image_header img).elf64_shstrndx)
   in
   match elf_memory_image_section_by_index shstrndx img with
        Nothing -> Nothing
        | Just shstrtab -> name_of_elf_interpreted_section sec shstrtab
  end *)
   Some(elf64_section_name_as_string sec).
(* [?]: removed value specification. *)

Definition name_of_elf_element  (feature : elf_file_feature ) (img3 : annotated_memory_image (abis.any_abi_feature ))  : option (string ) :=  
    match ( feature) with 
        ElfSection(_,  sec) => name_of_elf_section sec img3
        | _ => None (* FIXME *) 
    end.
(* [?]: removed value specification. *)

Definition get_unique_name_for_section_from_index  (idx1 : nat ) (isec1 : elf64_interpreted_section ) (img3 : annotated_memory_image (abis.any_abi_feature ))  : string := 
    (* Don't call gensym just to retrieve the name *)
    match ( elf_memory_image_element_coextensive_with_section idx1 img3) with 
        Some n => n
        | None => DAEMON
    end.
