-- LISTE

-- 1 returneaza divizorii pozitivi

factori :: Int -> [Int]
factori x = [y | y <- [1..x], x `rem` y == 0]

-- 2 verifica daca e numar prim

prim :: Int -> Bool
prim x = length (factori x) == 2

-- 3 lista de numere prime din intervalul 1, n

numerePrime :: Int -> [Int]
numerePrime x = [y | y <- [0..x], prim y]

-- 4 definirea unui functii zip pentru 3 argumente

myzip3 :: [Int] -> [Int] -> [Int] -> [(Int, Int, Int)]
myzip3 x y z = [(a, b, c) | ((a, b), c) <- zip (zip x y) z]

zip3FaraZip :: [a] -> [b] -> [c] -> [(a, b, c)]
zip3FaraZip [] _ _ = []
zip3FaraZip _ [] _ = []
zip3FaraZip _ _ [] = []
zip3FaraZip (a : as) (b : bs) (c : cs) = (a, b, c) : zip3FaraZip as bs cs

-- 5
ordonataNat :: [Int] -> Bool
ordonataNat [] = True
ordonataNat [x] = True
ordonataNat (x:xs) = x < head xs && ordonata xs

-- 7 functie care verifica daca o lista e ordonata

ordonata :: [Int] -> Bool
ordonata [] = True
ordonata [_] = True
ordonata (x:y:z)
    | x < y = ordonata (y:z)
    | otherwise = False

-- 9
compuneList :: (b -> c) -> [a -> b] -> [a -> c]
compuneList f listf = [f.g | g <- listf]

-- 10
aplicaList :: a -> [a -> b] -> [b]
aplicaList x listf = [f x | f <- listf]