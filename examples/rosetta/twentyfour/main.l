import system'routines.
import system'collections.
import system'dynamic.
import extensions.

// --- Expression ---

class ExpressionTree
{
    object theTree.
    
    constructor new : aLiteral
    [
        var aLevel := Integer new:0.
        
        aLiteral run each: (:ch)
        [
            var node := Dynamic new.
            
            ch =>
                $43 [ node set level:(aLevel + 1); set operation:%add ];       // +
                $45 [ node set level:(aLevel + 1); set operation:%subtract ];  // -
                $42 [ node set level:(aLevel + 2); set operation:%multiply ];  // *
                $47 [ node set level:(aLevel + 2); set operation:%divide ];    // /
                $40 [ aLevel append int:10. ^ $self ]; // (
                $41 [ aLevel reduce int:10. ^ $self ]; // )
                ! [
                    node set leaf:(ch literal; toReal); set level:(aLevel + 3).
                ].
                    
            if ($nil == theTree)
                [ theTree := node ];
                [
                    if (theTree level >= node level)
                        [
                            node set left:theTree; set right:$nil.
                            
                            theTree := node
                        ];
                        [
                            var aTop := theTree.
                            while (($nil != aTop right)and:$(aTop right; level < node level))
                                [ aTop := aTop right ].
                            
                            node set left:(aTop right); set right:$nil.
                            
                            aTop set right:node
                        ]
                ]
        ]
    ]
    
    eval : aNode
    [
        if (aNode if leaf)
            [ ^ aNode leaf ];
            [
                var aLeft := $self eval:(aNode left).
                var aRight := $self eval:(aNode right).
                
                ^ aLeft~(aNode operation) eval:aRight
            ]
    ]
    
    value
        <= eval:theTree.
        
    readLeaves : aList at:aNode
    [
        if ($nil == aNode)
            [ InvalidArgumentException new; raise ].
        
        if (aNode if leaf)
            [ aList append:(aNode leaf) ];
            [
                $self readLeaves:aList at:(aNode left).
                $self readLeaves:aList at:(aNode right).
            ].
    ]        
    
    readLeaves : aList
        <= readLeaves:aList at:theTree.
}

// --- Game ---

class TwentyFourGame
{
    object theNumbers.
    
    constructor new
    [
        $self newPuzzle.        
    ]
    
    newPuzzle
    [
        theNumbers := (
            1 + randomGenerator eval:9, 
            1 + randomGenerator eval:9, 
            1 + randomGenerator eval:9, 
            1 + randomGenerator eval:9).
    ]
    
    help
    [
        console 
            printLine:"------------------------------- Instructions ------------------------------";
            printLine:"Four digits will be displayed.";
            printLine:"Enter an equation using all of those four digits that evaluates to 24";
            printLine:"Only * / + - operators and () are allowed";
            printLine:"Digits can only be used once, but in any order you need.";
            printLine:"Digits cannot be combined - i.e.: 12 + 12 when given 1,2,2,1 is not allowed";
            printLine:"Submit a blank line to skip the current puzzle.";
            printLine:"Type 'q' to quit";
            writeLine;
            printLine:"Example: given 2 3 8 2, answer should resemble 8*3-(2-2)";
            printLine:"------------------------------- --------------------------------------------".
    ]
    
    prompt
    [
        theNumbers run each: (:n) [ console print:n:" " ].
        
        console print:": "
    ]
    
    resolve : aLine
    [
        var exp := ExpressionTree new:aLine.
        
        var Leaves := ArrayList new.
        exp readLeaves:Leaves.
        
        ifnot (Leaves ascendant; equal indexable:(theNumbers ascendant))
            [ console printLine:"Invalid input. Enter an equation using all of those four digits. Try again.". ^ $self ].
            
        var aResult := exp value.
        if (aResult == 24)
            [
                console printLine:"Good work. ":aLine:"=":aResult.
                
                $self newPuzzle.
            ];
            [ console printLine:"Incorrect. ":aLine:"=":aResult ]
    ]    
}

extension gameOp
{
    playRound : aLine
    [
        if (aLine == "q")
            [ ^ false ];
            [
                if (aLine == "")
                    [ console printLine:"Skipping this puzzle". self newPuzzle. ];
                    [
                        try(self resolve:aLine)
                        {
                            generic : e [
                                   console writeLine:"An error occurred.  Check your input and try again."
                                ]
                        }
                    ].
                    
                ^ true
            ].
    ]
}

// --- program ---

program =
[
    var aGame := TwentyFourGame new; help.
    
    while (aGame prompt; playRound:(console readLine)) [].
].