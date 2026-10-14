# One hailstone step in Uiua, a stack-based array language written in glyphs.
# ⊸◿2 keeps n and pushes n mod 2; ⨬ picks the branch: halve, or triple plus one.
Step ← ⨬(÷2|+1×3)⊸◿2
&p Step ⋕&sc
