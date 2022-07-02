import Data.List
import Data.Maybe
import Data.Function

type Name = String

data  Value  =  VBool Bool
        |VInt Int
        |VFun (Value -> Value)
        |VError
        
data  Hask  = HTrue | HFalse 
        |HIf Hask Hask Hask
        |HLet Name Hask Hask
        -- |HLetRec Name Name Hask Hask
        |HLit Int
        |Hask :==: Hask
        |Hask :+:  Hask
        |Hask :*:  Hask
        |HVar Name
        |HLam Name Hask
        -- |HMu Name Hask
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

eqV :: Value -> Value -> Maybe Bool
eqV (VBool b) (VBool c)    =  Just (b == c)
eqV (VInt i) (VInt j)      =  Just (i == j)
eqV (VFun _) (VFun _)      =  Nothing
eqV (VError ) (VError)     =  Nothing
eqV _ _                    =  Just False

instance Eq Value where
  v1 == v2 = fromMaybe (error "Nu se pot compara") (eqV v1 v2)

-- instance Eq Value where
-- (==) (VBool a) (VBool b) = a == b
-- (==) (VInt a) (VInt b) = a == b
-- (==) _ _ = error ("Nu se poate face egalitatea")

hEval :: Hask -> HEnv -> Value
hEval HTrue r         =  VBool True
hEval HFalse r        =  VBool False
hEval (HLit i) r      =  VInt i

hEval (HIf c d e) r =
  hif (hEval c r) (hEval d r) (hEval e r)
  where  hif (VBool b) v w  =  if b then v else w
         hif _ _ _ = VError   

-- hEval (d :==: e) r     =  heq (hEval d r) (hEval e r)
  -- where  heq (VInt i) (VInt j) = VBool (i == j)
         -- --heq (VBool i) (VBool j) = VBool (i == j)
         -- heq  _ _ = VError   
hEval (h1 :==: h2) r
  | Just b <- eqV (hEval h1 r) (hEval h2 r) = VBool b
  | otherwise = VError        
  
hEval (d :+: e) r    =  hadd (hEval d r) (hEval e r)
  where  hadd (VInt i) (VInt j) = VInt (i + j)
         hadd _ _  = VError   
hEval (d :*: e) r    =  hadd (hEval d r) (hEval e r)
  where  hadd (VInt i) (VInt j) = VInt (i * j)
         hadd _ _  = VError   
  
hEval (HVar x) r      =  fromMaybe VError (lookup  x r)

hEval (HLam x e) r    =  VFun (\v -> hEval e ((x,v):r))

--hEval (HMu x e) r    =  fix (\v -> hEval e ((x,v):r))


hEval (HLet x ex e) r    =  hEval (HLam x e :$: ex) r
-- hEval (HLetRec f x ef e) r    =
--  hEval (HLet f (HMu f (HLam x ef)) e) r

hEval (d :$: e) r    =  happ (hEval d r) (hEval e r)
  where  happ (VFun f) v  =  f v
         happ _ _ = VError

run :: Hask -> String
run pg = showV (hEval pg [])

h0 =  (HLam "x" (HLam "y" ((HVar "x") :+: (HVar "y")))) 
      :$: (HLit 3)
      :$: (HLit 4)
-- *Main> h0
-- (HLam "x" (HLam "y" (HVar "x" :+: HVar "y")) :$: HLit 3) :$: HLit 4
      
--h1 = HLet "x" (HLit 3) ((HLit 4) :+: HVar "x")      

test_h0 = eqV (hEval h0 []) (VInt 7)
-- *Main> test_h0
-- Just True

h2= hEval (HIf HTrue (HVar "x":+: HVar "y") (HVar "x")) [("x",VInt 2),("y", VInt 30)] -- 32
-- *Main> h2
-- 32
h3= hEval (HIf HFalse (HVar "x":+: HVar "y") (HVar "x")) [("x",VInt 2),("y", VInt 30)] -- 2

h4= hEval (HIf (HFalse:==:HTrue) (HVar "x":+: HVar "y") (HVar "x")) [("x",VInt 2),("y", VInt 30)]-- <error>  / 2(--heq (VBool i) (VBool j) = VBool (i == j))


h5= hEval (HIf (HFalse:==:HVar "x") (HVar "x":+: HVar "y") (HVar "x")) [("x",VInt 2),("y", VInt 30)]
-- *Main> h5
-- *** Exception: Nu se pot compara  --hEval (h1 :==: h2) r = VBool (hEval h1 r == hEval h2 r) 
-- *Main> h5
-- <error> --cu heq

h6= hEval (HVar "x") [("x",VInt 2),("y", VInt 30)] --2

h7= hEval (HVar "x") [("z",VInt 2),("y", VInt 30)] -- <error>

--h8 = (HMu "rec" (HLam "n" (HIf (HVar "n" :==: HLit 0) (HLit 1) (HVar "n" :*: (HVar "rec" :$: (HVar "n" :+: HLit (-1))))))) :$: (HLit 5)

--h9 = HLetRec "fact" "n"
  -- (HIf (HVar "n" :==: HLit 0)
    -- (HLit 1)
    -- (HVar "n" :*: (HVar "fact" :$: (HVar "n" :+: HLit (-1))))
  -- )
  -- (HVar "fact" :$: HLit 5)
  
 
-- *Main> h2
-- 32
-- *Main> h3
-- 2
-- *Main> h4
-- 2
-- *Main> h5
-- 2
-- *Main> h6
-- 2
-- *Main> h7
-- <error>

