(*Generated by Lem from basic_classes.lem.*)
(******************************************************************************)
(* Basic Type Classes                                                         *)
(******************************************************************************)

open Lem_bool

(* ========================================================================== *)
(* Equality                                                                   *)
(* ========================================================================== *)

(* Lem`s default equality (=) is defined by the following type-class Eq.
   This typeclass should define equality on an abstract datatype 'a. It should
   always coincide with the default equality of Coq, HOL and Isabelle.
   For OCaml, it might be different, since abstract datatypes like sets
   might have fancy equalities. *)

type 'a eq_class= { 
  isEqual_method : 'a -> 'a -> bool;
  isInequal_method : 'a -> 'a -> bool
}


(* (=) should for all instances be an equivalence relation 
   The isEquivalence predicate of relations could be used here.
   However, this would lead to a cyclic dependency. *)

(* TODO: add later, once lemmata can be assigned to classes 
lemma eq_equiv: ((forall x. (x = x)) &&
                 (forall x y. (x = y) <-> (y = x)) &&
                 (forall x y z. ((x = y) && (y = z)) --> (x = z)))
*)

(* Structural equality *)

(* Sometimes, it is also handy to be able to use structural equality.
   This equality is mapped to the build-in equality of backends. This equality
   differs significantly for each backend. For example, OCaml can`t check equality
   of function types, whereas HOL can.  When using structural equality, one should 
   know what one is doing. The only guarentee is that is behaves like 
   the native backend equality.

   A lengthy name for structural equality is used to discourage its direct use.
   It also ensures that users realise it is unsafe (e.g. OCaml can`t check two functions
   for equality *)
(*val unsafe_structural_equality : forall 'a. 'a -> 'a -> bool*)

(*val unsafe_structural_inequality : forall 'a. 'a -> 'a -> bool*)
let unsafe_structural_inequality x y = (not (x = y))

(* The default for equality is the unsafe structural one. It can 
   (and should) be overriden for concrete types later. *)

let instance_Basic_classes_Eq_var_dict =({

  isEqual_method = (=);

  isInequal_method = unsafe_structural_inequality})


(* ========================================================================== *)
(* Orderings                                                                  *)
(* ========================================================================== *)

(* The type-class Ord represents total orders (also called linear orders) *)
(*type ordering = LT | EQ | GT*)

(*let orderingIsLess r       = (match r with LT -> true | _ -> false end)*)
(*let orderingIsGreater r    = (match r with GT -> true | _ -> false end)*)
(*let orderingIsEqual r      = (match r with EQ -> true | _ -> false end)*)

(*let ordering_cases r lt eq gt =
  if orderingIsLess r then lt else
  if orderingIsEqual r then eq else gt*)


(*val orderingEqual : ordering -> ordering -> bool*)

let instance_Basic_classes_Eq_Basic_classes_ordering_dict =({

  isEqual_method = Lem.orderingEqual;

  isInequal_method = (fun x y->not (Lem.orderingEqual x y))})

type 'a ord_class= { 
  compare_method                 : 'a -> 'a -> int;
  isLess_method         : 'a -> 'a -> bool;
  isLessEqual_method    : 'a -> 'a -> bool;
  isGreater_method      : 'a -> 'a -> bool;
  isGreaterEqual_method : 'a -> 'a -> bool 
}


(* Ocaml provides default, polymorphic compare functions. Let's use them
   as the default. However, because used perhaps in a typeclass they must be 
   defined for all targets. So, explicitly declare them as undefined for
   all other targets. If explictly declare undefined, the type-checker won't complain and
   an error will only be raised when trying to actually output the function for a certain
   target. *)
(*val defaultCompare   : forall 'a. 'a -> 'a -> ordering*)
(*val defaultLess      : forall 'a. 'a -> 'a -> bool*)
(*val defaultLessEq    : forall 'a. 'a -> 'a -> bool*)
(*val defaultGreater   : forall 'a. 'a -> 'a -> bool*)
(*val defaultGreaterEq : forall 'a. 'a -> 'a -> bool*) 
;;

let genericCompare (less: 'a -> 'a -> bool) (equal: 'a -> 'a -> bool) (x : 'a) (y : 'a) =  
(if less x y then
    (-1)
  else if equal x y then
    0
  else
    1)


(*
(* compare should really be a total order *)
lemma ord_OK_1: (
  (forall x y. (compare x y = EQ) <-> (compare y x = EQ)) &&
  (forall x y. (compare x y = LT) <-> (compare y x = GT)))

lemma ord_OK_2: (
  (forall x y z. (x <= y) && (y <= z) --> (x <= z)) &&
  (forall x y. (x <= y) || (y <= x))
)
*)

(* let's derive a compare function from the Ord type-class *)
(*val ordCompare : forall 'a. Eq 'a, Ord 'a => 'a -> 'a -> ordering*)
let ordCompare dict_Basic_classes_Eq_a dict_Basic_classes_Ord_a x y =  
(if ( dict_Basic_classes_Ord_a.isLess_method x y) then (-1) else
  if ( dict_Basic_classes_Eq_a.isEqual_method x y) then 0 else 1)

type 'a ordMaxMin_class= { 
  max_method : 'a -> 'a -> 'a;
  min_method : 'a -> 'a -> 'a
}

(*val minByLessEqual : forall 'a. ('a -> 'a -> bool) -> 'a -> 'a -> 'a*)
let minByLessEqual le x y = (if (le x y) then x else y)

(*val maxByLessEqual : forall 'a. ('a -> 'a -> bool) -> 'a -> 'a -> 'a*)
let maxByLessEqual le x y = (if (le y x) then x else y)

(*val defaultMax : forall 'a. Ord 'a => 'a -> 'a -> 'a*)

(*val defaultMin : forall 'a. Ord 'a => 'a -> 'a -> 'a*)

let instance_Basic_classes_OrdMaxMin_var_dict dict_Basic_classes_Ord_a =({

  max_method = max;

  min_method = min})


(* ========================================================================== *)
(* SetTypes                                                                   *)
(* ========================================================================== *)

(* Set implementations use often an order on the elements. This allows the OCaml implementation
   to use trees for implementing them. At least, one needs to be able to check equality on sets.
   One could use the Ord type-class for sets. However, defining a special typeclass is cleaner
   and allows more flexibility. One can make e.g. sure, that this type-class is ignored for
   backends like HOL or Isabelle, which don't need it. Moreover, one is not forced to also instantiate
   the functions "<", "<=" ... *)

type 'a setType_class= { 
  setElemCompare_method : 'a -> 'a -> int
}

let instance_Basic_classes_SetType_var_dict =({

  setElemCompare_method = compare})

(* ========================================================================== *)
(* Instantiations                                                             *)
(* ========================================================================== *)

let instance_Basic_classes_Eq_bool_dict =({

  isEqual_method = (=);

  isInequal_method = (fun x y->not ((=) x y))})

let boolCompare b1 b2 = ((match (b1, b2) with
  | (true, true) -> 0
  | (true, false) -> 1
  | (false, true) -> (-1)
  | (false, false) -> 0
))

let instance_Basic_classes_SetType_bool_dict =({

  setElemCompare_method = boolCompare})

(* strings *)

(*val charEqual : char -> char -> bool*)

let instance_Basic_classes_Eq_char_dict =({

  isEqual_method = (=);

  isInequal_method = (fun left right->not (left = right))})

(*val stringEquality : string -> string -> bool*)

let instance_Basic_classes_Eq_string_dict =({

  isEqual_method = (=);

  isInequal_method = (fun l r->not (l = r))})

(* pairs *)

(*val pairEqual : forall 'a 'b. Eq 'a, Eq 'b => ('a * 'b) -> ('a * 'b) -> bool*)
(*let pairEqual (a1, b1) (a2, b2) = ( 
  dict_Basic_classes_Eq_a.isEqual_method a1 a2) && ( dict_Basic_classes_Eq_b.isEqual_method b1 b2)*)

(*val pairEqualBy : forall 'a 'b. ('a -> 'a -> bool) -> ('b -> 'b -> bool) -> ('a * 'b) -> ('a * 'b) -> bool*)

let instance_Basic_classes_Eq_tup2_dict dict_Basic_classes_Eq_a dict_Basic_classes_Eq_b =({

  isEqual_method = (Lem.pair_equal  
  dict_Basic_classes_Eq_a.isEqual_method  dict_Basic_classes_Eq_b.isEqual_method);

  isInequal_method = (fun x y->not ((Lem.pair_equal  
  dict_Basic_classes_Eq_a.isEqual_method  dict_Basic_classes_Eq_b.isEqual_method x y)))})

(*val pairCompare : forall 'a 'b. ('a -> 'a -> ordering) -> ('b -> 'b -> ordering) -> ('a * 'b) -> ('a * 'b) -> ordering*)
let pairCompare cmpa cmpb (a1, b1) (a2, b2) = 
  (Lem.ordering_cases (cmpa a1 a2) (-1) (cmpb b1 b2) 1)

let pairLess dict_Basic_classes_Ord_a dict_Basic_classes_Ord_b (x1, x2) (y1, y2) = (( 
  dict_Basic_classes_Ord_b.isLess_method x1 y1) || (( dict_Basic_classes_Ord_b.isLessEqual_method x1 y1) && ( dict_Basic_classes_Ord_a.isLess_method x2 y2)))
let pairLessEq dict_Basic_classes_Ord_a dict_Basic_classes_Ord_b (x1, x2) (y1, y2) = (( 
  dict_Basic_classes_Ord_b.isLess_method x1 y1) || (( dict_Basic_classes_Ord_b.isLessEqual_method x1 y1) && ( dict_Basic_classes_Ord_a.isLessEqual_method x2 y2)))

let pairGreater dict_Basic_classes_Ord_a dict_Basic_classes_Ord_b x12 y12 = (pairLess 
  dict_Basic_classes_Ord_b dict_Basic_classes_Ord_a y12 x12)
let pairGreaterEq dict_Basic_classes_Ord_a dict_Basic_classes_Ord_b x12 y12 = (pairLessEq 
  dict_Basic_classes_Ord_b dict_Basic_classes_Ord_a y12 x12)

let instance_Basic_classes_Ord_tup2_dict dict_Basic_classes_Ord_a dict_Basic_classes_Ord_b =({

  compare_method = (pairCompare  
  dict_Basic_classes_Ord_a.compare_method  dict_Basic_classes_Ord_b.compare_method);

  isLess_method = 
  (pairLess dict_Basic_classes_Ord_b dict_Basic_classes_Ord_a);

  isLessEqual_method = 
  (pairLessEq dict_Basic_classes_Ord_b dict_Basic_classes_Ord_a);

  isGreater_method = 
  (pairGreater dict_Basic_classes_Ord_a dict_Basic_classes_Ord_b);

  isGreaterEqual_method = 
  (pairGreaterEq dict_Basic_classes_Ord_a dict_Basic_classes_Ord_b)})

let instance_Basic_classes_SetType_tup2_dict dict_Basic_classes_SetType_a dict_Basic_classes_SetType_b =({

  setElemCompare_method = (pairCompare  
  dict_Basic_classes_SetType_a.setElemCompare_method  dict_Basic_classes_SetType_b.setElemCompare_method)})


(* triples *)

(*val tripleEqual : forall 'a 'b 'c. Eq 'a, Eq 'b, Eq 'c => ('a * 'b * 'c) -> ('a * 'b * 'c) -> bool*)
let tripleEqual dict_Basic_classes_Eq_a dict_Basic_classes_Eq_b dict_Basic_classes_Eq_c (x1, x2, x3) (y1, y2, y3) = ( (Lem.pair_equal  
  dict_Basic_classes_Eq_a.isEqual_method (Lem.pair_equal  dict_Basic_classes_Eq_b.isEqual_method  dict_Basic_classes_Eq_c.isEqual_method)(x1, (x2, x3)) (y1, (y2, y3))))

let instance_Basic_classes_Eq_tup3_dict dict_Basic_classes_Eq_a dict_Basic_classes_Eq_b dict_Basic_classes_Eq_c =({

  isEqual_method = 
  (tripleEqual dict_Basic_classes_Eq_a dict_Basic_classes_Eq_b
     dict_Basic_classes_Eq_c);

  isInequal_method = (fun x y->not (tripleEqual 
  dict_Basic_classes_Eq_a dict_Basic_classes_Eq_b dict_Basic_classes_Eq_c x y))})

(*val tripleCompare : forall 'a 'b 'c. ('a -> 'a -> ordering) -> ('b -> 'b -> ordering) -> ('c -> 'c -> ordering) -> ('a * 'b * 'c) -> ('a * 'b * 'c) -> ordering*)
let tripleCompare cmpa cmpb cmpc (a1, b1, c1) (a2, b2, c2) =  
(pairCompare cmpa (pairCompare cmpb cmpc) (a1, (b1, c1)) (a2, (b2, c2)))

let tripleLess dict_Basic_classes_Ord_a dict_Basic_classes_Ord_b dict_Basic_classes_Ord_c (x1, x2, x3) (y1, y2, y3) = (pairLess 
  (instance_Basic_classes_Ord_tup2_dict dict_Basic_classes_Ord_b
     dict_Basic_classes_Ord_c) dict_Basic_classes_Ord_a (x1, (x2, x3)) (y1, (y2, y3)))
let tripleLessEq dict_Basic_classes_Ord_a dict_Basic_classes_Ord_b dict_Basic_classes_Ord_c (x1, x2, x3) (y1, y2, y3) = (pairLessEq 
  (instance_Basic_classes_Ord_tup2_dict dict_Basic_classes_Ord_b
     dict_Basic_classes_Ord_c) dict_Basic_classes_Ord_a (x1, (x2, x3)) (y1, (y2, y3)))

let tripleGreater dict_Basic_classes_Ord_a dict_Basic_classes_Ord_b dict_Basic_classes_Ord_c x123 y123 = (tripleLess 
  dict_Basic_classes_Ord_c dict_Basic_classes_Ord_b dict_Basic_classes_Ord_a y123 x123)
let tripleGreaterEq dict_Basic_classes_Ord_a dict_Basic_classes_Ord_b dict_Basic_classes_Ord_c x123 y123 = (tripleLessEq 
  dict_Basic_classes_Ord_c dict_Basic_classes_Ord_b dict_Basic_classes_Ord_a y123 x123)

let instance_Basic_classes_Ord_tup3_dict dict_Basic_classes_Ord_a dict_Basic_classes_Ord_b dict_Basic_classes_Ord_c =({

  compare_method = (tripleCompare  
  dict_Basic_classes_Ord_a.compare_method  dict_Basic_classes_Ord_b.compare_method  dict_Basic_classes_Ord_c.compare_method);

  isLess_method = 
  (tripleLess dict_Basic_classes_Ord_a dict_Basic_classes_Ord_b
     dict_Basic_classes_Ord_c);

  isLessEqual_method = 
  (tripleLessEq dict_Basic_classes_Ord_a dict_Basic_classes_Ord_b
     dict_Basic_classes_Ord_c);

  isGreater_method = 
  (tripleGreater dict_Basic_classes_Ord_c dict_Basic_classes_Ord_b
     dict_Basic_classes_Ord_a);

  isGreaterEqual_method = 
  (tripleGreaterEq dict_Basic_classes_Ord_c dict_Basic_classes_Ord_b
     dict_Basic_classes_Ord_a)})

let instance_Basic_classes_SetType_tup3_dict dict_Basic_classes_SetType_a dict_Basic_classes_SetType_b dict_Basic_classes_SetType_c =({

  setElemCompare_method = (tripleCompare  
  dict_Basic_classes_SetType_a.setElemCompare_method  dict_Basic_classes_SetType_b.setElemCompare_method  dict_Basic_classes_SetType_c.setElemCompare_method)})

