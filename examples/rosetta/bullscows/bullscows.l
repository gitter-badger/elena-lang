import system'routines.
import extensions.

class GameMaster
{
    object theNumbers.
    object theAttempt.

    constructor new
    [
        // generate secret number
        var aRandomNumbers := (1,2,3,4,5,6,7,8,9) randomize:9.
 
        theNumbers := aRandomNumbers Subarray index:0 length:4.
        theAttempt := Integer new:1.
    ]

    ask
    [
        var aRow := console print:"Your Guess #":theAttempt:" ?"; readLine.
        
        ^ aRow toArray.
    ]

    proceed : aGuess
    [
        var aCows := Integer new:0.
        var aBulls := Integer new:0.

        if (aGuess length != 4)
            [ aBulls append int:(-1). ];
            [
                try(0 to:3 doEach: (:i)
                [
                    var ch := aGuess@i.
                    var aNumber := ch literal; toInt.
                    
                    // check range
                    ifnot ((aNumber > 0) && (aNumber < 10))
                        [ InvalidArgumentException new; raise. ].
                    
                    // check duplicates
                    var duplicate := aGuess seek each: (:x)[ ^(x == ch)and:$(x equal reference:ch; not)].
                    if (nil != duplicate)
                    [
                        InvalidArgumentException new; raise.
                    ].
                    
                    if (aNumber == theNumbers@i)
                        [ aBulls append int:1 ];
                        [
                            (theNumbers ifExists:aNumber)
                                ? [ aCows append int:1 ].
                        ].
                ])
                {
                    generic : e
                    [
                        aBulls int := -1
                    ]
                }.
            ].

        ^ aBulls =>
            -1 [ console writeLine:"Not a valid guess.". ^ true ];
             4 [ console writeLine:"Congratulations! You have won!". ^ false ];
             ! [
                 theAttempt append int:1.
                 
                 console printLine:"Your Score is " : aBulls : " bulls and " : aCows : " cows".
                 
                 ^ true
             ].
    ]
}

program =
[
    var aGameMaster := GameMaster new.

    $(aGameMaster proceed:(aGameMaster ask)) doWhile.
    
    console readChar.
].