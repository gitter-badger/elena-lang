//---------------------------------------------------------------------------
//		E L E N A   P r o j e c t:  ELENA Compiler
//
//		This file contains ELENA Source Reader class implementation.
//
//                                              (C)2005-2017, by Alexei Rakov
//---------------------------------------------------------------------------

#include "elena.h"
// --------------------------------------------------------------------------
#include "source.h"

using namespace _ELENA_ ;

// --- DFA Table ---

const char* DFA_table[30] =
{
        ".????????cc??c??????????????????cmvbxhmehhmmhyhinnnnnnnnnnmmmmmhhddddddddddddddddddddddddddhmhmd?ddddddddddddddddddddddddddhmhhd",
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbbbbbbbbbaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa}",
        "*********cc*********************c***********************************************************************************************",
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaaaaddddddddddaaaaaaaddddddddddddddddddddddddddaaaadaddddddddddddddddddddddddddaaaad",
        "??????????????????????????????????????????g?????ffffffffff???????ffffffffffffffffffffffffff????f?ffffffffffffffffffffffffff????f",
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaaaaffffffffffaaaaaaaffffffffffffffffffffffffffaaaafaffffffffffffffffffffffffffaaaaf",
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa?aa?aaaaa??????????aaaaaaa??????????????????????????aaaa?a??????????????????????????aaaa?",
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaakaaaajaaaaaaaaaaaaahaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
        "*jjjjjjjjj*jj*jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj",
        "?kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkklkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk",
        "?kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkckkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk",
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaahaaaaaaaaaaaaaaaaaaahhhhhaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaahaaaaaaaaaaaaaaaaaaaaaaaaaaaaahaaa",
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa$annnnnnnnnnaaaaaaassssssssssssssssssssssssssaaaaaassssssssssssssssssssssssssaaaaa",
        "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!pppppppppp!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",
        "??????????????????????????????????????????????" "!?pppppppppp???????????????????????????????????????????z????????????q?????????????", //!! the space should be removed after turning off trigraphs
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaassssssssssaaaaaaassssssaaaaaaaaaaaaaaaaaaaaaaaaaassssssataaaraaaaaaaaaaaaaaaaaaa",
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
        "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!nnnnnnnnnn!!!h!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",
        "?vvvvvvvvv?vvv?vvvvvvvvvvvvvvvvvvvwvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv",
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaava}aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa~aaaaaaaa",
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa?aaaaaa$a}}}}}}}}}}aaaaaaaxxxxxxxxxxxxxxxxxxxxxxxxxxaaaaxaxxxxxxxxxxxxxxxxxxxxxxxxxxaaaax",
        "-------------------------------------------------------------h------------------------------------------------------------------",
        "???????????????????????????????????????????|?|??{{{{{{{{{{??????????????????????????????????????????????????????????????????????",
        "????????????????????????????????????????????????{{{{{{{{{{????????????????????????????????????????????????????????q?????????????",
        "????????????????????????????????????????????????{{{{{{{{{{??????????????????????????????????????????????????????????????????????",
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaava}aaaaaaaaaaa}}}}}}}}}}aaaaaaa}}}}}}aaaaaaaaaaaaaaaaaaaaaaaaaa}}}}}}a}aaaaaaaaaaaaaaaaaaaaaaa",
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
};

// --- SourceReader ---

SourceReader :: SourceReader(int tabSize, TextReader* source)
   : _TextParser(DFA_table, tabSize, source)
{
   _lastState = dfaStart;
}

LineInfo SourceReader :: read(char* token, size_t length)
{
   LineInfo info(_position, _column, _row);
   char terminalState = readLineInfo(dfaStart, info);

   switch (terminalState) {
      case dfaError:
         throw InvalidChar(info.column, info.row, _line[_position]);
      case dfaEOF:
         info.state = dfaEOF;
         info.length = 0;
         break;
      case dfaDotLookahead:
         resolveDotAmbiguity(info);
         break;
      case dfaMinusLookahead:
         resolveSignAmbiguity(info);
         break;
   }

   if (info.state == dfaQuote || info.state == dfaCharacter || info.state == dfaWideQuote) {
      copyQuote(info);
   }
   else copyToken(info, token, length);

   _lastState = info.state;

   return info;
}
