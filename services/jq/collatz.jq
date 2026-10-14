# One hailstone step in jq, the JSON processor. The input is a JSON document
# that happens to be the number 27.
if . % 2 == 0 then . / 2 else 3 * . + 1 end
