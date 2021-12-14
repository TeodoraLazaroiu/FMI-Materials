
-- 1 primeste o lista de perechi si returneaza
-- primele elemente din fiecare pereche

firstEl :: [(a,b)] -> [a]
firstEl = map fst

-- 2 primeste o lista de liste si returneaza
-- o lista cu sume elementelor din fiecare lista

sumList :: [[Int]] -> [Int]
sumList = map sum

-- 3 primeste o lista si returneaza lista
-- cu el pare injumatatire si cele impare dublate

prel2 :: [Int] -> [Int]
prel2 = map (\x -> if even x then x `div` 2 else x * 2)

-- 4 primeste un caracter si o lista de siruri si
-- returneaza sirurile ce contin acel caracter

contineCaracter :: Char -> [String] -> [String]
contineCaracter c = filter (c `elem`)

-- 5 primeste o lista de intregi si returneaza
-- lista patratelor numerelor impare

patrat :: [Int] -> [Int]
patrat ls = map (^2) (filter odd ls)
-- patrat ls = map (^2) $ filter (odd) ls

-- 6 primeste ca argument o listă de întregi si întoarce
-- lista pătratelor numerelor din pozitii impare

patratImp :: [Int] -> [Int]
patratImp x = map (^2) ([a | (a,b) <- zip x [1..], odd b])

-- 7 primeste ca argument o listă de siruri de caractere
-- si întoarce lista obtinută prin eliminarea consoanelor

numaiVocale :: [[Char]] -> [[Char]]
numaiVocale = map (filter(`elem` "aeiouAEIOU"))

-- 10 Scriet, i o funct, ie care verifică faptul că toate
-- elementele dintr-o listă sunt True

allTrue :: [Bool] -> Bool
allTrue = foldr (&&) True

-- 11.a functie care elimina un caracter dintr-un sir

rmChar :: Char -> String -> String
rmChar ch = filter (/= ch)

-- 11.c

rmCharFold :: String -> String -> String
rmCharFold = foldr rmChar