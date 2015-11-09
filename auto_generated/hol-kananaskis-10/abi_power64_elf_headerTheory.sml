structure abi_power64_elf_headerTheory :> abi_power64_elf_headerTheory =
struct
  val _ = if !Globals.print_thy_loads then print "Loading abi_power64_elf_headerTheory ... " else ()
  open Type Term Thm
  infixr -->

  fun C s t ty = mk_thy_const{Name=s,Thy=t,Ty=ty}
  fun T s t A = mk_thy_type{Tyop=s, Thy=t,Args=A}
  fun V s q = mk_var(s,q)
  val U     = mk_vartype
  (*  Parents *)
  local open elf_headerTheory
  in end;
  val _ = Theory.link_parents
          ("abi_power64_elf_header",
          Arbnum.fromString "1445439229",
          Arbnum.fromString "405396")
          [("elf_header",
           Arbnum.fromString "1445438753",
           Arbnum.fromString "972064")];
  val _ = Theory.incorporate_types "abi_power64_elf_header" [];

  val idvector = 
    let fun ID(thy,oth) = {Thy = thy, Other = oth}
    in Vector.fromList
  [ID("min", "fun"), ID("min", "bool"), ID("endianness", "endianness"),
   ID("list", "list"), ID("fcp", "cart"), ID("num", "num"),
   ID("bool", "!"), ID("bool", "/\\"), ID("min", "="), ID("bool", "F"),
   ID("elf_header", "elf_class_64"), ID("elf_header", "elf_data_2lsb"),
   ID("elf_header", "elf_data_2msb"), ID("elf_header", "elf_ii_class"),
   ID("elf_header", "elf_ii_data"), ID("elf_header", "elf_ma_ppc64"),
   ID("endianness", "endianness_CASE"), ID("missing_pervasives", "id"),
   ID("abi_power64_elf_header", "is_valid_abi_power64_machine_architecture"),
   ID("abi_power64_elf_header", "is_valid_abi_power64_magic_number"),
   ID("lem_list", "list_index"), ID("option", "option"),
   ID("option", "option_CASE"), ID("words", "w2n")]
  end;
  local open SharingTables
  in
  val tyvector = build_type_vector idvector
  [TYOP [1], TYOP [2], TYOP [0, 1, 0], TYV "'a", TYOP [4, 0, 3],
   TYOP [3, 4], TYOP [0, 5, 2], TYOP [5], TYOP [0, 7, 0], TYOP [0, 2, 0],
   TYOP [0, 5, 0], TYOP [0, 10, 0], TYOP [0, 8, 0], TYOP [0, 0, 0],
   TYOP [0, 0, 13], TYOP [0, 7, 8], TYOP [0, 1, 14], TYOP [0, 7, 7],
   TYOP [21, 4], TYOP [0, 7, 18], TYOP [0, 5, 19], TYOP [0, 4, 0],
   TYOP [0, 21, 0], TYOP [0, 0, 22], TYOP [0, 18, 23], TYOP [0, 4, 7]]
  end
  val _ = Theory.incorporate_consts "abi_power64_elf_header" tyvector
     [("is_valid_abi_power64_magic_number", 6),
      ("is_valid_abi_power64_machine_architecture", 8)];

  local open SharingTables
  in
  val tmvector = build_term_vector idvector tyvector
  [TMV("cls", 4), TMV("ed", 4), TMV("endian", 1), TMV("m", 7),
   TMV("magic", 5), TMC(6, 9), TMC(6, 11), TMC(6, 12), TMC(7, 14),
   TMC(8, 14), TMC(8, 15), TMC(9, 0), TMC(10, 7), TMC(11, 7), TMC(12, 7),
   TMC(13, 7), TMC(14, 7), TMC(15, 7), TMC(16, 16), TMC(17, 17),
   TMC(18, 8), TMC(19, 6), TMC(20, 20), TMC(22, 24), TMC(23, 25)]
  end
  local
  val DT = Thm.disk_thm val read = Term.read_raw tmvector
  in
  fun op is_valid_abi_power64_machine_architecture_def x = x
    val op is_valid_abi_power64_machine_architecture_def =
    DT(((("abi_power64_elf_header",0),[]),[]),
       [read"%7%3%9%20$0@@%10$0@%19%17@@@|@"])
  fun op is_valid_abi_power64_magic_number_def x = x
    val op is_valid_abi_power64_magic_number_def =
    DT(((("abi_power64_elf_header",1),[]),[]),
       [read"%6%4%5%2%9%21$1@$0@@%23%22$1@%19%15@@@%11@%0%23%22$2@%19%16@@@%11@%1%18$2@%8%10%24$1@@%12@@%10%24$0@@%14@@@%8%10%24$1@@%12@@%10%24$0@@%13@@@|@|@@|@|@"])
  end
  val _ = DB.bindl "abi_power64_elf_header"
  [("is_valid_abi_power64_machine_architecture_def",
    is_valid_abi_power64_machine_architecture_def,
    DB.Def),
   ("is_valid_abi_power64_magic_number_def",
    is_valid_abi_power64_magic_number_def,
    DB.Def)]

  local open Portable GrammarSpecials Parse
    fun UTOFF f = Feedback.trace("Parse.unicode_trace_off_complaints",0)f
  in
  val _ = mk_local_grms [("elf_headerTheory.elf_header_grammars",
                          elf_headerTheory.elf_header_grammars)]
  val _ = List.app (update_grms reveal) []
  val _ = update_grms
       (UTOFF temp_overload_on)
       ("is_valid_abi_power64_machine_architecture", (Term.prim_mk_const { Name = "is_valid_abi_power64_machine_architecture", Thy = "abi_power64_elf_header"}))
  val _ = update_grms
       (UTOFF temp_overload_on)
       ("is_valid_abi_power64_machine_architecture", (Term.prim_mk_const { Name = "is_valid_abi_power64_machine_architecture", Thy = "abi_power64_elf_header"}))
  val _ = update_grms
       (UTOFF temp_overload_on)
       ("is_valid_abi_power64_magic_number", (Term.prim_mk_const { Name = "is_valid_abi_power64_magic_number", Thy = "abi_power64_elf_header"}))
  val _ = update_grms
       (UTOFF temp_overload_on)
       ("is_valid_abi_power64_magic_number", (Term.prim_mk_const { Name = "is_valid_abi_power64_magic_number", Thy = "abi_power64_elf_header"}))
  val abi_power64_elf_header_grammars = Parse.current_lgrms()
  end
  val _ = Theory.LoadableThyData.temp_encoded_update {
    thy = "abi_power64_elf_header",
    thydataty = "compute",
    data =
        "abi_power64_elf_header.is_valid_abi_power64_machine_architecture_def abi_power64_elf_header.is_valid_abi_power64_magic_number_def"
  }

val _ = if !Globals.print_thy_loads then print "done\n" else ()
val _ = Theory.load_complete "abi_power64_elf_header"
end