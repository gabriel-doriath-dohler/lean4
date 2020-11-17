import Lean

open Lean
open Lean.Meta
open Lean.Elab.Tactic

universes u
axiom elimEx (motive : Nat → Nat → Sort u) (x y : Nat)
  (diag  : (a : Nat) → motive a a)
  (upper : (delta a : Nat) → motive a (a + delta.succ))
  (lower : (delta a : Nat) → motive (a + delta.succ) a)
  : motive y x

theorem ex1 (p q : Nat) : p ≤ q ∨ p > q := by
  cases p, q using elimEx
  | diag    => apply Or.inl; apply Nat.leRefl
  | lower d => apply Or.inl; show p ≤ p + d.succ; admit
  | upper d => apply Or.inr; show q + d.succ > q; admit

theorem ex2 (p q : Nat) : p ≤ q ∨ p > q := by
  cases p, q using elimEx
  case lower => admit
  case upper => admit
  case diag  => apply Or.inl; apply Nat.leRefl

axiom parityElim (motive : Nat → Sort u)
  (even : (n : Nat) → motive (2*n))
  (odd  : (n : Nat) → motive (2*n+1))
  (n : Nat)
  : motive n

theorem time2Eq (n : Nat) : 2*n = n + n := by
  rw Nat.mulComm
  show (0 + n) + n = n+n
  rw Nat.zeroAdd
  rfl

theorem ex3 (n : Nat) : Exists (fun m => n = m + m ∨ n = m + m + 1) := by
  cases n using parityElim
  | even i =>
    apply Exists.intro i
    apply Or.inl
    rw time2Eq
    rfl
  | odd i =>
    apply Exists.intro i
    apply Or.inr
    rw time2Eq
    rfl

def ex4 {α} (xs : List α) (h : xs = [] → False) : α := by
  cases he:xs
  | nil      => apply False.elim; exact h he; done
  | cons x _ => exact x

def ex5 {α} (xs : List α) (h : xs = [] → False) : α := by
  cases he:xs using List.casesOn
  | nil      => apply False.elim; exact h he; done
  | cons x _ => exact x

theorem ex6 {α} (f : List α → Bool) (h₁ : {xs : List α} → f xs = true → xs = []) (xs : List α) (h₂ : xs ≠ []) : f xs = false :=
  match he:f xs with
  | true  => False.elim (h₂ (h₁ he))
  | false => rfl

theorem ex7 {α} (f : List α → Bool) (h₁ : {xs : List α} → f xs = true → xs = []) (xs : List α) (h₂ : xs ≠ []) : f xs = false := by
  cases he:f xs
  | true  => exact False.elim (h₂ (h₁ he))
  | false => rfl

theorem ex8 {α} (f : List α → Bool) (h₁ : {xs : List α} → f xs = true → xs = []) (xs : List α) (h₂ : xs ≠ []) : f xs = false := by
  cases he:f xs using Bool.casesOn
  | true  => exact False.elim (h₂ (h₁ he))
  | false => rfl

theorem ex9 {α} (xs : List α) (h : xs = [] → False) : Nonempty α := by
  cases xs using List.rec
  | nil      => apply False.elim; apply h; rfl
  | cons x _ => apply Nonempty.intro; assumption

theorem modLt (x : Nat) {y : Nat} (h : y > 0) : x % y < y := by
  induction x, y using Nat.mod.inductionOn generalizing h
  | ind x y h₁ ih =>
    rw [Nat.modEqSubMod h₁.2]
    exact ih h
  | base x y h₁ =>
    match Iff.mp (Decidable.notAndIffOrNot ..) h₁ with
    | Or.inl h₁ => exact absurd h h₁
    | Or.inr h₁ =>
      have hgt := Nat.gtOfNotLe h₁
      have heq := Nat.modEqOfLt hgt
      rw [← heq] at hgt
      assumption

theorem ex11 {p q : Prop } (h : p ∨ q) : q ∨ p := by
  induction h using Or.casesOn
  | inr h  => ?myright
  | inl h  => ?myleft
  case myleft  => exact Or.inr h
  case myright => exact Or.inl h

theorem ex12 {p q : Prop } (h : p ∨ q) : q ∨ p := by
  cases h using Or.casesOn
  | inr h  => ?myright
  | inl h  => ?myleft
  case myleft  => exact Or.inr h
  case myright => exact Or.inl h

theorem ex13 (p q : Nat) : p ≤ q ∨ p > q := by
  cases p, q using elimEx
  | diag    => ?hdiag
  | lower d => ?hlower
  | upper d => ?hupper
  case hdiag  => apply Or.inl; apply Nat.leRefl
  case hlower => apply Or.inl; show p ≤ p + d.succ; admit
  case hupper => apply Or.inr; show q + d.succ > q; admit

theorem ex14 (p q : Nat) : p ≤ q ∨ p > q := by
  cases p, q using elimEx
  | diag    => ?hdiag
  | lower d => _
  | upper d => ?hupper
  case hdiag  => apply Or.inl; apply Nat.leRefl
  case lower => apply Or.inl; show p ≤ p + d.succ; admit
  case hupper => apply Or.inr; show q + d.succ > q; admit

theorem ex15 (p q : Nat) : p ≤ q ∨ p > q := by
  cases p, q using elimEx
  | diag    => ?hdiag
  | lower d => _
  | upper d => ?hupper
  { apply Or.inl; apply Nat.leRefl }
  { apply Or.inr; show q + d.succ > q; admit }
  { apply Or.inl; show p ≤ p + d.succ; admit }