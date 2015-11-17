(* Generated by Lem from test_image.lem. *)

Require Import Arith.
Require Import Bool.
Require Import List.
Require Import String.
Require Import Program.Wf.

Require Import coqharness.

Open Scope nat_scope.
Open Scope string_scope.

Require Import lem_list.
Require Export lem_list.

Require Import lem_map.
Require Export lem_map.

Require Import lem_maybe.
Require Export lem_maybe.

Require Import lem_set.
Require Export lem_set.

Require Import missing_pervasives.
Require Export missing_pervasives.


Require Import elf_relocation.
Require Export elf_relocation.

Require Import elf_header.
Require Export elf_header.

Require Import elf_symbol_table.
Require Export elf_symbol_table.

Require Import elf_types_native_uint.
Require Export elf_types_native_uint.


Require Import abi_amd64_relocation.
Require Export abi_amd64_relocation.


Require Import elf_memory_image.
Require Export elf_memory_image.

Require Import memory_image.
Require Export memory_image.


Require Import command_line.
Require Export command_line.

Require Import input_list.
Require Export input_list.

Require Import linkable_list.
Require Export linkable_list.

Require Import byte_sequence.
Require Export byte_sequence.

Require Import link.
Require Export link.


Definition ref_rec0   : symbol_reference :=  {|ref_symname := "test"                  (* symbol name *)
               ;ref_syment :=
                  {|elf64_st_name  := (elf64_word_of_nat( 0))
                   ;elf64_st_info  := (unsigned_char_of_nat( 0))
                   ;elf64_st_other := (unsigned_char_of_nat( 0))
                   ;elf64_st_shndx := (elf64_half_of_nat shn_undef)
                   ;elf64_st_value := (elf64_addr_of_nat( 0))
                   ;elf64_st_size  := (elf64_xword_of_nat( 0))
                   |}
               ;ref_sym_scn :=( 0)
               ;ref_sym_idx :=( 0)
               |}.

(* the record representing the symbol reference and relocation site *)
Definitionref_and_reloc_rec0   : symbol_reference_and_reloc_site := 
 {|ref := ref_rec0
    ;maybe_def_bound_to := None
    ;maybe_reloc := (Some(
      {|ref_relent  := 
                {|elf64_ra_offset := (elf64_addr_of_nat( 0))
                 ;elf64_ra_info   := (elf64_xword_of_nat r_x86_64_pc32)
                 ;elf64_ra_addend := (elf64_sxword_of_int((Zpred (Zpos (P_of_succ_nat 0)))))
                 |}
          ;ref_rel_scn :=( 0)
          ;ref_rel_idx :=( 0)
          ;ref_src_scn :=( 0)
       |}
    ))
  |}.

Definition def_rec0   : symbol_definition :=  
   {|def_symname := "test"
    ;def_syment :=    {|elf64_st_name  := (elf64_word_of_nat( 0))
                       ;elf64_st_info  := (unsigned_char_of_nat( 0))
                       ;elf64_st_other := (unsigned_char_of_nat( 0))
                       ;elf64_st_shndx := (elf64_half_of_nat shn_undef)
                       ;elf64_st_value := (elf64_addr_of_nat( 0))
                       ;elf64_st_size  := (elf64_xword_of_nat( 0))
                       |}
    ;def_sym_scn :=( 0)
    ;def_sym_idx :=( 1)
    ;def_linkable_idx :=( 0)
    |}.
(* [?]: removed value specification. *)

Definition meta0   : list ((option ((string *((nat *nat ) % type)) % type) *range_tag (abis.any_abi_feature )) % type):=  [
        (Some (".text", ( 1, 4)), SymbolRef(ref_and_reloc_rec0))
    ;   (Some (".data", ( 0, 8)), SymbolDef(def_rec0))]
.


Definition img1  (instr_bytes : list (byte ))  : annotated_memory_image (abis.any_abi_feature ):=  
    let initial_img := 
     {|elements := (lem_map.fromList [(".text", {|startpos := (Some( 4194304))
           ;length1 := (Some( 16))
           ;contents := (List.map (fun (x : byte ) => Some x) instr_bytes)
          |});
          (".data", {|startpos := (Some( 4194320))
           ;length1 := (Some( 8))
           ;contents := (List.map (fun (x : byte ) => Some x) (lem_list.replicate( 8) (byte_of_nat( 42))))
          |})]
          )
        ;by_range := (set_from_list_by (lem_basic_classes.pairCompare (maybeCompare (lem_basic_classes.pairCompare (fun (x : string ) (y : string )=>EQ) (lem_basic_classes.pairCompare (lem_basic_classes.genericCompare nat_ltb beq_nat) (lem_basic_classes.genericCompare nat_ltb beq_nat)))) (fun (x : range_tag (abis.any_abi_feature )) (y : range_tag (abis.any_abi_feature ))=>EQ)) meta0)
        ;by_tag := (by_tag_from_by_range ((set_from_list_by (lem_basic_classes.pairCompare (maybeCompare (lem_basic_classes.pairCompare (fun (x : string ) (y : string )=>EQ) (lem_basic_classes.pairCompare (lem_basic_classes.genericCompare nat_ltb beq_nat) (lem_basic_classes.genericCompare nat_ltb beq_nat)))) (fun (x : range_tag (abis.any_abi_feature )) (y : range_tag (abis.any_abi_feature ))=>EQ)) meta0)))
     |} 
    in 
    let ref_input_item
     := ("test.o", Reloc(Sequence([])), ((File(Filename("blah"), command_line.null_input_file_options)), [InCommandLine( 0)]))
    in 
    let ref_linkable_item := (RelocELF(initial_img), ref_input_item, input_list.null_input_options)
    in
    let bindings_by_name := lem_map.fromList [
        ("test", [( 0, (( 0, ref_rec0, ref_linkable_item), Some( 0, def_rec0, ref_linkable_item)))])]
    
    in
    relocate_output_image abis.sysv_amd64_std_abi bindings_by_name initial_img.
