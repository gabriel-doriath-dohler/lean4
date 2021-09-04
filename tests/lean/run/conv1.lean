set_option pp.analyze false

def p (x y : Nat) := x = y

example (x y : Nat) : p (x + y) (y + x + 0) := by
  conv =>
    whnf
    congr
    . skip
    . whnf; skip
  traceState
  rw [Nat.add_comm]
  rfl

example (x y : Nat) : p (x + y) (y + x + 0) := by
  conv =>
    whnf
    rhs
    whnf
  traceState
  rw [Nat.add_comm]
  rfl

example (x y : Nat) : p (x + y) (y + x + 0) := by
  conv =>
    whnf
    lhs
    whnf
  conv =>
    rhs
    whnf
  traceState
  apply Nat.add_comm x y

example (x y : Nat) : p (x + y) (0 + y + x) := by
  conv =>
    whnf
    rhs
    rw [Nat.zero_add, Nat.add_comm]
    traceState
    skip
    done

axiom div_self (x : Nat) : x ≠ 0 → x / x = 1

example (h : x ≠ 0) : x / x + x = x.succ := by
  conv =>
    lhs
    arg 2
    rw [div_self]
    skip
    tactic => assumption
    done
  show 1 + x = x.succ
  rw [Nat.succ_add, Nat.zero_add]

example (h1 : x ≠ 0) (h2 : y = x / x) : y = 1 := by
  conv at h2 =>
    rhs
    rw [div_self]
    skip
    tactic => assumption
  assumption

example : id (fun x => 0 + x) = id := by
  conv =>
    lhs
    arg 1
    ext y
    rw [Nat.zero_add]

def f (x : Nat) :=
  if x > 0 then
    x + 1
  else
    x + 2

example (g : Nat → Nat) (h₁ : g x = x + 1) (h₂ : x > 0) : g x = f x := by
  conv =>
    rhs
    simp [f, h₂]
  exact h₁

example (h₁ : f x = x + 1) (h₂ : x > 0) : f x = f x := by
  conv =>
    rhs
    simp [f, h₂]
  exact h₁