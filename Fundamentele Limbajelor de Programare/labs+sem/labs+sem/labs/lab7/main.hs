import Data.List
import Data.Maybe

type Name = String

data  Value  =  VBool Bool
        |VInt Int   
        |VFun (Value -> Value)
        |VError

data  Hask  = HTrue | HFalse
        |HIf Hask Hask Hask
        |HLit Int
        |Hask :==: Hask
        |Hask :+:  Hask
        |HVar Name
        |HLam Name Hask
        |Hask :$: Hask
        deriving (Read, Show)

infix 4 :==:
infixl 6 :+:
infixl 9 :$:

type  HEnv  =  [(Name, Value)]

showV :: Value -> String
showV (VBool b)   =  show b
showV (VInt i)    =  show i
showV (VFun _)    =  "<function>"
showV (VError)    =  "<error>"


instance Show Value where
    show = showV

eqV :: Value -> Value -> Bool
eqV (VBool b) (VBool c)    =  b == c
eqV (VInt i) (VInt j)      =  i == j
eqV (VFun _) (VFun _)      =  error "Unknown fun"
eqV (VError ) (VError)      =  error "Unknown error"
eqV _ _               = False

hEval :: Hask -> HEnv -> Value
hEval HTrue r         =  VBool True
hEval HFalse r        =  VBool False

hEval (HIf c d e) r   =
  hif (hEval c r) (hEval d r) (hEval e r)
  where  hif (VBool b) v w  =  if b then v else w
         hif _ _ _ = VError

hEval (HLit i) r      =  VInt i

hEval (d :==: e) r    =   heq (hEval d r) (hEval e r)
    where heq (VInt i) (VInt j) = VBool (i==j)
          heq (VBool b1) (VBool b2) = VBool ( b1==b2)
          -- heq _ _ = VError
          heq _ _ = error "egalitate"
    

hEval (d :+: e) r  =  hadd  (hEval d r) (hEval e r)
    where
        hadd (VInt a) (VInt b) = VInt (a + b)
        -- hadd _ _ = VError
        hadd _ _ = error "adunare"
        
-- hEval (HVar x) r      =  fromMaybe VError (lookup x r)
hEval (HVar x) r      =  fromMaybe (error "Fara valoare") (lookup x r)

hEval (HLam x e) r    =  VFun ( \v -> hEval e ((x,v):r) )

hEval (d :$: e) r    =  happ ( hEval d r) (hEval e r)
    where   
        happ (VFun f ) v = f v
        --happ _ _ = VError
        happ _ _ = error "aplica"

run :: Hask -> String
run pg = showV (hEval pg [])

h0 =  (HLam "x" (HLam "y" ((HVar "x") :+: (HVar "y"))))
      :$: (HLit 3)
      :$: (HLit 4)

f = ( \ x -> if x == 1 then x + 2 else x + 10 ) $ (2 + 3)



test_h0 = eqV (hEval h0 []) (VInt 7)


-- h0 =  (HLam "x" (HLam "y" ((HVar "x") :+: (HVar "y")))) 
    --  :$: (HLit 3)
     -- :$: (HLit 4)
-- *Main> h0
-- (HLam "x" (HLam "y" (HVar "x" :+: HVar "y")) :$: HLit 3) :$: HLit 4
      
--h1 = HLet "x" (HLit 3) ((HLit 4) :+: HVar "x")      

-- test_h0 = eqV (hEval h0 []) (VInt 7)

-- *Main> hEval h0 []
-- 7

h2= hEval (HIf HTrue (HVar "x":+: HVar "y") (HVar "x")) [("x",VInt 2),("y", VInt 30)] -- 32
h3= hEval (HIf HFalse (HVar "x":+: HVar "y") (HVar "x")) [("x",VInt 2),("y", VInt 30)]-- 2

h4= hEval (HIf (HFalse:==:HTrue) (HVar "x":+: HVar "y") (HVar "x")) [("x",VInt 2),("y", VInt 30)]-- <error>  / 2(--heq (VBool i) (VBool j) = VBool (i == j))


h5= hEval (HIf (HFalse:==:HVar "x") (HVar "x":+: HVar "y") (HVar "x")) [("x",VInt 2),("y", VInt 30)]
-- *Main> h5
-- *** Exception: Nu se pot compara  --hEval (h1 :==: h2) r = VBool (hEval h1 r == hEval h2 r) 
-- *Main> h5
-- <error> --cu heq

h6= hEval (HVar "x") [("x",VInt 2),("y", VInt 30)] --2

h7= hEval (HVar "x") [("z",VInt 2),("y", VInt 30)] -- <error>


-- *Main> lookup "x" [("x",VInt 2),("y", VInt 30)]

-- <interactive>:2:1: error:
  --  • No instance for (Show Value) arising from a use of ‘print’
  --  • In a stmt of an interactive GHCi command: print it
-- *Main> lookup "x" [("x", 2),("y",30)]
-- Just 2

-- showV ( fromMaybe VError (lookup "x" [("x", VInt  2),("y", VInt   30)]))

{-
*Main> showV ( fromMaybe VError (lookup "x" [("x", VInt  2),("y", VInt   30)]))
"2"
*Main> fromMaybe VError (lookup "x" [("x", VInt  2),("y", VInt   30)])

<interactive>:5:1: error:
    • No instance for (Show Value) arising from a use of ‘print’
    • In a stmt of an interactive GHCi command: print it
*Main> :r
[1 of 1] Compiling Main             ( main.hs, interpreted )
Ok, one module loaded.
*Main> fromMaybe VError (lookup "x" [("x", VInt  2),("y", VInt   30)])
2
-}

