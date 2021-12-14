-- RECURSIVITATE PE LISTE

-- 1
palindrom :: [Char] -> Bool 
palindrom str = str == reverse str

vocale :: [Char] -> Int
vocale [] = 0
vocale str = if head str `elem` ['a','e','i','o','u'] then vocale (tail str) + 1 else vocale (tail str)

nrVocale :: [String] -> Int
nrVocale [] = 0
nrVocale str = if palindrom (head str) then vocale (head str) + nrVocale(tail str) else nrVocale (tail str)

-- nrVocale ["sos", "civic", "palton", "desen", "aerisirea"] = 9

-- 2


-- LIST COMPREHENSION

-- 3
divizor :: Int -> [Int]
divizor 0 = [1]
divizor x = [y | y <- [1..x], x `mod` y == 0]

-- 4
listadiv :: [Int] -> [[Int]]
listadiv list = [divizor x | x <- list]

-- 5
inIntervalComp :: Int -> Int -> [Int] -> [Int]
inIntervalComp x y list = [a | a <- list, x <= a, a <= y]

-- 6
pozitiveComp :: [Int] -> Int
pozitiveComp x = length list where list = [y | y <- x, y > 0]

pozitiveRec :: [Int] -> Int
pozitiveRec [] = 0
pozitiveRec x = if head x > 0 then 1 + pozitiveRec (tail x)
                            else pozitiveRec (tail x)

-- 7
pozitiiImpare :: [Int] -> [Int]
pozitiiImpare x = [ z | (y,z) <- zip x [0..], odd y]
