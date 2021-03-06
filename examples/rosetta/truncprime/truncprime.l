#import system'calendar.
#import extensions.

const MAXN = 1000000.

extension mathOp
{
    is &prime
    [
        int n := self int.
        
        if (n < 2) [ ^ false. ].        
        if (n < 4) [ ^ true. ].        
        if (n mod:2 == 0) [ ^ false. ].        
        if (n < 9) [ ^ true. ].        
        if (n mod:3 == 0) [ ^ false. ].
        
        int r := n sqrt.        
        int f := 5.
        while (f <= r)
        [
            if ((n mod:f == 0) || (n mod:(f + 2) == 0))
                [ ^ false. ].
                
            f := f + 6.
            
        ].
        
        ^ true.
    ]
    
    is &rightTruncatable
    [
        int n := self.
        
        while (n != 0)
        [
            ifnot (n is &prime)
                [ ^ false. ].
            
            n := n / 10.
        ].
        
        ^ true.
    ]

    is &leftTruncatable
    [
        int n := self.
        int tens := 1.
        
        while (tens < n)
            [ tens := tens * 10. ].
            
        while (n != 0)
        [
            ifnot (n is &prime)
                [ ^ false. ].

            tens := tens / 10.
            n := n - (n / tens * tens).
        ].
        
        ^ true.
    ]
}

program =
[
    var aStart := now.
    
    var n := MAXN.
    var max_lt := 0.
    var max_rt := 0.

    while ((max_lt == 0) || (max_rt == 0))
    [
        (n literal indexOf:"0" == -1) ?
        [
            if ((max_lt == 0) and:[ n is &leftTruncatable ])
                [
                    max_lt := n.
                ].
                
            if ((max_rt == 0) and:[ n is &rightTruncatable ])
                [
                    max_rt := n.
                ].
        ].
                        
        n := n - 1.            
    ].

    var anEnd := now.
    
    console writeLine:"Largest truncable left is ":max_lt.    
    console writeLine:"Largest truncable right is ":max_rt.
    
    var aDiff := anEnd - aStart.
    console writeLine:"Time elapsed in msec:":(aDiff milliseconds).
    
    console readChar.
].