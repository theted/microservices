;; One hailstone step in hand-written WebAssembly text. wasmtime calls the
;; exported function with n and prints whatever comes back.
(module
  (func (export "step") (param $n i64) (result i64)
    (if (result i64)
      (i64.eqz (i64.rem_u (local.get $n) (i64.const 2)))
      (then
        (i64.div_u (local.get $n) (i64.const 2)))
      (else
        (i64.add (i64.mul (local.get $n) (i64.const 3)) (i64.const 1))))))
