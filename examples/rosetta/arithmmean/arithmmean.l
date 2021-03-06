///  a program to find the mean (arithmetic average) of a numeric vector. 
#import extensions.

// --- Average ---

extension op
{
    average
    [
        var aSum := Real new.
        var aCount := Integer new:0.
        
        var anEnumerator := self enumerator.
        
        while (anEnumerator next)
        [
            aSum += anEnumerator get.
            aCount += 1.
        ].
        
        ^ aSum / aCount.
    ]
}
// --- Program ---

program =
[
    var anArray := (1, 2, 3, 4, 5, 6, 7, 8).
    console writeLine:"Arithmetic mean of {":anArray:"} is ":(anArray average) readChar.
]. 