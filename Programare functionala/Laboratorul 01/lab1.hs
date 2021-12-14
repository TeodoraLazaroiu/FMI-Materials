import Data.List

myInt = 555555555555555555555555555555555555555555555555555555555555555

double :: Integer -> Integer
double x = x+x

triple :: Integer -> Integer
triple x = x + x + x

maxim :: Integer -> Integer -> Integer
maxim x y =
     if x > y
          then x
          else y

maxim3 x y z = 
     let u = if x > y
               then x
               else y
     in if u > z
          then u
          else z

-- exercitiul 1 
-- functie cu 2 parametri care calculeaza suma patratelor celor doua numere

patrat :: Integer -> Integer -> Integer
patrat x y = x*x + y*y

-- exercitiul 2
-- functie cu un parametru care intoarce "par" sau "impar"

paritate :: Integer -> [Char]
paritate x = if odd x
               then "impar"
               else "par"
               
-- exercitiul 3
-- functie care calculeaza factorialul unui numar

factorial :: Integer -> Integer
factorial x = product [1..x]

-- exercitiul 4
-- functie care verifica daca primul parametru este mai mare decât
-- dublul celui de-al doilea parametru

functie :: Integer -> Integer -> Bool
functie x y = x > y * 2
