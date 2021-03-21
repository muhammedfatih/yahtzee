type RoundInput = (Integer, Integer, Integer, Integer, Integer)
type GameInput = (RoundInput, RoundInput, RoundInput, RoundInput, RoundInput, RoundInput, RoundInput, RoundInput, RoundInput, RoundInput, RoundInput, RoundInput, RoundInput)
data ScoreStrategy = Ones | Twos | Threes | Fours | Fives | Sixes | Change | ThreeOfAKind | FourOfAKind | FiveOfAKind | ShortStraight | LongStraight | FullHouse | Init deriving (Eq, Show)

round1 :: RoundInput
round1 = (1, 1, 1, 1, 1)
round2 :: RoundInput
round2 = (6, 6, 6, 6, 6)
round3 :: RoundInput
round3 = (6, 6, 6, 1, 1)
round4 :: RoundInput
round4 = (1, 1, 1, 2, 2)
round5 :: RoundInput
round5 = (1, 1, 1, 2, 3)
round6 :: RoundInput
round6 = (1, 2, 3, 4, 5)
round7 :: RoundInput
round7 = (1, 2, 3, 4, 6)
round8 :: RoundInput
round8 = (6, 1, 2, 6, 6)
round9 :: RoundInput
round9 = (1, 4, 5, 5, 5)
round10 :: RoundInput
round10 = (5, 5, 5, 5, 6)
round11 :: RoundInput
round11 = (4, 4, 4, 5, 6)
round12 :: RoundInput
round12 = (3, 1, 3, 6, 3)
round13 :: RoundInput
round13 = (2, 2, 2, 4, 6)

gameinput :: GameInput
gameinput = (round1, round2, round3, round4, round5, round6, round7, round8, round9, round10, round11, round12, round13)

play :: GameInput -> [Integer]
play gameinput = (playIter (gameInputList gameinput) [] availableStrategies)
	where
		availableStrategies :: [ScoreStrategy]
		availableStrategies = [Ones, Twos, Threes, Fours, Fives, Sixes, Change, ThreeOfAKind, FourOfAKind, FiveOfAKind, ShortStraight, LongStraight, FullHouse, Init]
		playIter :: [RoundInput] -> [Integer] -> [ScoreStrategy] -> [Integer]
		playIter [] acc availableStrategies = if needBonus (reverse acc) then (reverse (((sum acc)+35):(35:acc))) else reverse ((sum acc):acc)
		playIter (x:xs) acc availableStrategies = playIter xs ((scoreRound x (findBestStrategy x availableStrategies)):acc) (removeItem (findBestStrategy x availableStrategies) availableStrategies)

needBonus :: [Integer] -> Bool
needBonus [x1,x2,x3,x4,x5,x6,_,_,_,_,_,_,_] = if ((x1 + x2 + x3 + x4 + x5 + x6) > 63) then True else False

findBestStrategy :: RoundInput -> [ScoreStrategy] -> ScoreStrategy
findBestStrategy round availableStrategies = findBestStrategyIter round availableStrategies (-1) Init
	where
		findBestStrategyIter :: RoundInput -> [ScoreStrategy] -> Integer -> ScoreStrategy -> ScoreStrategy
		findBestStrategyIter round [] maxScore bestStrategy = bestStrategy
		findBestStrategyIter round (x:xs) maxScore bestStrategy = if (scoreRound round x) > maxScore then findBestStrategyIter round xs (scoreRound round x) x else findBestStrategyIter round xs maxScore bestStrategy 

gameInputList :: GameInput -> [RoundInput]
gameInputList (round1, round2, round3, round4, round5, round6, round7, round8, round9, round10, round11, round12, round13) = [round1, round2, round3, round4, round5, round6, round7, round8, round9, round10, round11, round12, round13]

scoreRound :: RoundInput -> ScoreStrategy -> Integer
scoreRound round Init = (-1)
scoreRound round Ones = rountInputWithCompareInteger round 1
scoreRound round Twos = rountInputWithCompareInteger round 2
scoreRound round Threes = rountInputWithCompareInteger round 3
scoreRound round Fours = rountInputWithCompareInteger round 4
scoreRound round Fives = rountInputWithCompareInteger round 5
scoreRound round Sixes = rountInputWithCompareInteger round 6
scoreRound (dice1, dice2, dice3, dice4, dice5) Change = dice1+dice2+dice3+dice4+dice5
scoreRound round ThreeOfAKind = (numberOfTheElement round (giveAtLeast round 2)) * (giveAtLeast round 2)
scoreRound round FourOfAKind = (numberOfTheElement round (giveAtLeast round 3)) * (giveAtLeast round 3)
scoreRound round FiveOfAKind = if (numberOfTheElement round (giveAtLeast round 4))==5 then 50 else 0
scoreRound round ShortStraight = if ((length (createSuitableList round)) > 3) && isSequantialFor (createSuitableList round) ShortStraight then 25 else 0
scoreRound round LongStraight = if ((length (createSuitableList round)) > 4) && isSequantialFor (createSuitableList round) LongStraight then 35 else 0
scoreRound round FullHouse = if ((length (createSuitableList round)) == 2) && ((numberOfTheElement round (head (createSuitableList round))==2) || (numberOfTheElement round (head (createSuitableList round))==3)) then 40 else 0

isSequantialFor :: [Integer] -> ScoreStrategy -> Bool
isSequantialFor [1,2,3,4] ShortStraight = True
isSequantialFor [1,2,3,4,_] ShortStraight = True
isSequantialFor [2,3,4,5] ShortStraight = True
isSequantialFor [_,2,3,4,5] ShortStraight = True
isSequantialFor [2,3,4,5,_] ShortStraight = True
isSequantialFor [3,4,5,6] ShortStraight = True
isSequantialFor [_,3,4,5,6] ShortStraight = True
isSequantialFor [_,_,_,_] ShortStraight = False
isSequantialFor [_,_,_,_,_] ShortStraight = False
isSequantialFor [1,2,3,4,5] LongStraight = True
isSequantialFor [2,3,4,5,6] LongStraight = True
isSequantialFor [_,_,_,_,_] LongStraight = False

createSuitableList :: RoundInput -> [Integer]
createSuitableList (dice1, dice2, dice3, dice4, dice5) = remove_dups (quicksort [dice1, dice2, dice3, dice4, dice5])

giveAtLeast :: RoundInput -> Integer -> Integer
giveAtLeast (dice1, dice2, dice3, dice4, dice5) number = 
	if (numberOfTheElement (dice1, dice2, dice3, dice4, dice5) dice1) > number then dice1 else
	if (numberOfTheElement (dice1, dice2, dice3, dice4, dice5) dice2) > number then dice2 else
	if (numberOfTheElement (dice1, dice2, dice3, dice4, dice5) dice3) > number then dice3 else
	if (numberOfTheElement (dice1, dice2, dice3, dice4, dice5) dice4) > number then dice4 else
	if (numberOfTheElement (dice1, dice2, dice3, dice4, dice5) dice5) > number then dice5 else 0

numberOfTheElement :: RoundInput -> Integer -> Integer 
numberOfTheElement round 0 = 0
numberOfTheElement round number = (rountInputWithCompareInteger round number) `div` number

rountInputWithCompareInteger :: RoundInput -> Integer -> Integer
rountInputWithCompareInteger (dice1, dice2, dice3, dice4, dice5) number = (integerCompare dice1 number)+(integerCompare dice2 number)+(integerCompare dice3 number)+(integerCompare dice4 number)+(integerCompare dice5 number)

integerCompare :: Integer -> Integer -> Integer
integerCompare number1 number2 = if(number1==number2) then number1 else 0

quicksort :: Ord a => [a] -> [a]
quicksort []     = []
quicksort (p:xs) = (quicksort lesser) ++ [p] ++ (quicksort greater)
    where
        lesser  = filter (< p) xs
        greater = filter (>= p) xs

remove_dups :: (Ord a, Eq a) => [a] -> [a]
remove_dups xs = remove $ quicksort xs
  where
    remove []  = []
    remove [x] = [x]
    remove (x1:x2:xs)
      | x1 == x2  = remove (x1:xs)
      | otherwise = x1 : remove (x2:xs)

removeItem _ []                 = []
removeItem x (y:ys) | x == y    = removeItem x ys
                    | otherwise = y : removeItem x ys