# 1. Yahtzee Game

The game consists of a number of rounds. In each round, a player gets three rolls of the dice, although they can choose to end their turn after one or two rolls. After the first roll the player can save any dice they want and re-roll the other dice. This procedure is repeated after the second roll. The player has complete choice as to which dice to roll. It is possible to re-roll both dice that were or were not rolled before.

The Yahtzee scorecard contains 13 different category boxes and in each round, after the third roll, the player must choose one of these categories. The score entered in the box depends on how well the five dice match the scoring rule for the category. Details of the scoring rules for each category are given below. As an example, one of the categories is called Three of a Kind. The scoring rule for this category means that a player only scores if at least three of the five dice are the same value. The game is completed after 13 rounds by each player, with each of the 13 boxes filled. The total score is calculated by summing all thirteen boxes, together with any bonuses.

The Yahtzee scorecard contains 13 scoring boxes divided into upper and lower sections. 

[Reference](https://en.wikipedia.org/wiki/Yahtzee#Rules)

# 2. Objectives

The aim of the homework is to implement the Yahtzee dice game. As it was declared in the homework assignment game has 13 scoring strategies and 13 rounds. Every scoring strategy can be applied only one round. Our aim is finding the highest score according to given 13 rounds.

# 3. Data Structuresand Variables

During the program, two customized variable type and one data structure were created. 

* Customized variable type RoundInput is tuple with five integer values. It is used for keeping the dices’ values for each round separately.

* Customized variable type GameInput is tuple with thirteen RoundInput values. It is used for keeping RoundInputs for game.

* New Data structure is ScoreStrategy. It is derived from Show and Eq classes. It keeps the game strategies.

# 4. Program Flow

Program’s main function is play. It accepts a GameInput variable as parameter, and returns a list of scores for each round. It sends the PlayIter function GameInput variable as list, with help of the gameInputList function, and available strategies list.

PlayIter function helps the Play function. It has an accumulator variable with type of Integer list, which is used for score values for each round. PlayIter function finds the strategy that earns each round with highest score. 

findBestStrategy function helps the PlayIter function to find the highest score for a given RoundInput and available strategies. It uses the scoreRound function to find each round score for each strategy. 

scroeRound helps both findBestStrategy and PlayIter functions. It needs a RoundInput and a strategy to apply that RoundInput, and it returns the score for the RoundInput according to given strategy.

scoreRound function uses the rountInputWithCompareInteger function to find suitable score for Ones, Twos, Threes, Fours, Fives and Sixes strategies. rountInputWithCompareInteger function uses integerCompare function to understand which dice values equal for a given integer. It returns to scoreRound function sum of the dice values, which equal to a given number.

integerCompare function helps the rountInputWithCompareInteger function. It returns one of the equal number values, if two integer values are equal, it returns zeroif they are not equal.

scoreRound function uses numberOfTheElement and giveAtLeast functions for ThreeOfAKind and FourOfAKind strategies.

numberOfTheElement takes a round and an integer, and returns the number of the given integer in the round’s dices’ values. rountInputWithCompareInteger helps the function.

giveAtLeast takes a RoundInput and an integer as parameters, and it returns at least number of given integer dice value. For example giveAtLeast round1 3 returns, at least 3 of the same value of a dice, for instance 3.

scoreRound function uses createSuitableListand isSequantialForfunctions for ShortStraight, LongStraightand FullHouse strategies.

createSuitableList function is prepare an ordered list of integer  without any duplicated values from a given RoundInput. It uses remove_dups and quicksort functions.

isSequantialFor function takes list of the integer and scoreStrategy and it returns a Boolean.  The first input is createSuitableList RoundInput.It uses pattern matching and if list is suitable to get score, it returns true, else it returns false.