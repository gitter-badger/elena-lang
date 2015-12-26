// Write a program to create an ordered collection A of functions of a real number. At least one function should be built-in and 
// at least one should be user-defined; try using the sine, cosine, and cubing functions. 
// Fill another collection B with the inverse of each function in A. 
// Implement function composition as in Functional Composition. Finally, demonstrate that the result of applying the composition 
// of each function in A and its inverse in B to a value, is the original value

#define system.
#define system'routines.
#import system'math.
#import extensions'routines.
 
#class(extension)op
{
    #method compose : f : g
        = (self::g eval)::f eval.
}
 
#symbol program =
[
   #var fs := (%(mathOp get&sin)(0), %(mathOp get&cos)(0), =[ self power:3.0r ]).
   #var gs := (%(mathOp get&arcsin)(0), %(mathOp get&arccos)(0), =[ self power:(1.0r / 3) ]).
 
   fs zip:gs &into: (:f:g)[ 0.5r compose:f:g ]
        run &each:printingLn.
].