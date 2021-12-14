data Fruct = Mar String Bool | Portocala String Int

-- 1.a

ePortocalaDeSicilia :: Fruct -> Bool
ePortocalaDeSicilia (Mar _ _) = False
ePortocalaDeSicilia (Portocala soi felii) =
    soi == "Tarocco" || soi == "Moro" || soi == "Sanguinello"

-- 1.b

listaFructe = [Mar "Ionatan" False,
                Portocala "Sanguinello" 10,
                Portocala "Valencia" 22,
                Mar "Golden Delicious" True,
                Portocala "Sanguinello" 15,
                Portocala "Moro" 12,
                Portocala "Tarocco" 3,
                Portocala "Moro" 12,
                Portocala "Valencia" 2,
                Mar "Golden Delicious" False,
                Mar "Golden" False,
                Mar "Golden" True]

nrFelii :: Fruct -> Int
nrFelii (Portocala soi felii) = felii
nrFelii (Mar soi bool) = 0

nrFeliiSicilia :: [Fruct] -> Int
nrFeliiSicilia [] = 0
nrFeliiSicilia (h:t) = if ePortocalaDeSicilia h then nrFeliiSicilia t + nrFelii h
                        else nrFeliiSicilia t

-- 2

type NumeA = String
type Rasa = String
data Animal = Pisica NumeA | Caine NumeA Rasa
    deriving Show

vorbeste :: Animal -> String
vorbeste (Pisica _) = "Meow!"
vorbeste (Caine _ _) = "Woof!"

-- tipul Maybe
-- data Maybe a = Nothing | Just a

data Linie = L [Int]
    deriving Show
data Matrice = M [Linie]
    deriving Show

verifica :: Matrice -> Int -> Bool
verifica m n = sum (head m) == n