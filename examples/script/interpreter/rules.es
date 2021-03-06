[[
   #grammar transform
   #grammar cf

   #define start      ::= <= ( > += " 2" += " %""system'dynamic'tapeOp.tape_var[]""" => commands <= " *" "system'dynamic'Tape" "=" # ) =>;

   #define commands   ::= command commands;
   #define commands   ::= comment commands;
   #define commands   ::= $eof;

   #define command    ::= <= += " %""output[0]"" " => ".";
   #define command    ::= <= += " %""input[0]"" " => ",";
   #define command    ::= <= += " %""previous[0]"" " => "<";
   #define command    ::= <= += " %""next[0]"" " => ">";
   #define command    ::= <= += " %""append[0]"" " => "+";
   #define command    ::= <= += " %""reduce[0]"" " => "-";
   #define command    ::= <= += " -2" += " %""system'dynamic'tapeOp.tape_ptr[]"" " += " 1" += " %""system'dynamic'tapeOp.tape_stack[]"" " += "%""push[1]"" " => "[";
   #define command    ::= <= += " 0" += " %""system'dynamic'tapeOp.tape_stack[]"" " += " %""check[0]"" " += " 1" += " %""system'dynamic'tapeOp.tape_stack[]"" " += " %""pop[0]"" " += " %""system'dynamic'tapeOp.tape_jumpif[]"" " => "]";

   #define comment    ::= " " comments;
   #define comment    ::= "'" comments;
   #define comment    ::= "!" comments;
   #define comment    ::= $eol;

   #define comments   ::= $chr comments;
   #define comments   ::= $eps;

   #mode symbolic;
]]
