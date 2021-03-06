#import system'routines.
#import extensions.

extension op
{
    printSolution : bits
        = self zip:bits &into:
            (:s:b) [ s iif:"T":"F" + (s xor:b) iif:"* ":"  " ] summarize:(String new).
}

puzzle =
(
    bits [ bits length == 12 ],
    
    bits [ bits last:6 select &each:x [ x iif:1:0 ] summarize == 3 ],
    
    bits [ bits zip:(RangeEnumerator new &from:1 &to:12) 
                        &into:(:x:i) [ (i int is &even)and:x iif:1:0 ] summarize == 2 ],
    
    bits [ bits@4 iif:(bits@5 && bits@6):true ],
    
    bits [ (bits@1 || bits@2 || bits@3) not ],
    
    bits [ bits zip:(RangeEnumerator new &from:1 &to:12) 
                        &into:(:x:i) [ (i int is &odd)and:x iif:1:0 ] summarize == 4 ],
    
    bits [ (bits@1) xor:(bits@2) ],
    
    bits [ bits@6 iif:(bits@5 && bits@4):true ],
    
    bits [ bits top:6 select &each:x [ x iif:1:0 ] summarize == 3 ],
    
    bits [ bits@10 && bits@11 ],
    
    bits [ ((bits@6) iif:1:0 + (bits@7) iif:1:0 + (bits@8) iif:1:0)==1 ],
    
    bits [ bits top:11 select &each:x [ x iif:1:0 ] summarize == 4 ]
).

program =
[
    console writeLine:"".
    
    0 till:(2 power &int:12) &doEach:n
    [
        var bits := BitArray32 new:n top:12 toArray.
        var results := puzzle select &each: r [ r eval:bits ] toArray.
        
        var counts := bits zip:results &into:(:b:r) [ b xor:r iif:1:0 ] summarize.

        counts =>
            0  [ console writeLine:"Total hit :":(results printSolution:bits). ];
            1  [ console writeLine:"Near miss :":(results printSolution:bits). ];
            12 [ console writeLine:"Total miss:":(results printSolution:bits). ].
    ].
    
    console readChar.
].