#import system.
#import system'dynamic.
#import system'routines.
#import system'io.
#import extensions.

#import system'collections.

#symbol feedback =
{
    raiseError : aMessage
    [
        console writeLine:aMessage.
        
        #throw AbortException new.
    ]
    
    raiseError : aMessage1 : aMessage2
    [
        console writeLine:aMessage1:aMessage2.
        
        #throw AbortException new.
    ]
    
    raiseError : aMessage1 : aMessage2 : aMessage3
    [
        console writeLine:aMessage1:aMessage2:aMessage3.
        
        #throw AbortException new.
    ]
}.

#symbol program =
[
    #var source := $nil.
    #var output := $nil.

    #var i := Integer new:1.
    #loop (i < 'program'arguments length)?
    [
        #var arg := 'program'arguments@i.
        (arg == "-o")
            ? [ output := 'program'arguments@(i += 1). ]
            ! [ source := arg. ].
        
        i += 1.
    ].

    (($nil == source)or:($nil == output))
        ? [ feedback raiseError:"Invaid argument list. Usage: assembler -o <output file> <source file>".  ].

    #var lexer := assembler'Lexer new &sourceFile:source.
    lexer scan.
    
    #var parser := assembler'Parser new.
    parser processTokens &tokens:(lexer TokenList).

    #var bin := assembler'BinaryFile new.
    #var cgen := assembler'CodeGenerator new:bin.
    cgen assemble:(parser Output).
    bin finalizeExecutable.
    bin generate:output.
].