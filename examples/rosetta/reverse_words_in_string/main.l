#import system'routines.

program =
[
    var text := ("---------- Ice and Fire ------------",
                  "",
                  "fire, in end will world the say Some",
                  "ice. in say Some",
                  "desire of tasted I've what From",
                  "fire. favor who those with hold I",
                  "",
                  "... elided paragraph last ...",
                  "",
                  "Frost Robert -----------------------").
                 
    text run &each: line 
    [ 
        line split &by:" " reverse run &each: word
        [
            console write:word write:" ".
        ].
        console writeLine.
    ].
].