-- One hailstone step in Haskell. A pure function can't open a socket, so
-- the shim deals with the outside world and Haskell just transforms stdin.
step :: Integer -> Integer
step n
  | even n = n `div` 2
  | otherwise = 3 * n + 1

main :: IO ()
main = interact $ (++ "\n") . show . step . read
