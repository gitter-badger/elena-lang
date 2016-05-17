//---------------------------------------------------------------------------
//		E L E N A   P r o j e c t:  ELENA VM Script Engine
//
//                                               (C)2011-2016 by Alexei Rakov
//---------------------------------------------------------------------------

#include "elena.h"
// --------------------------------------------------------------------------
#include "session.h"
#include "cfparser.h"
#include "inlineparser.h"

using namespace _ELENA_;
using namespace _ELENA_TOOL_;

// --- Session ---

Session::Session(path_t rootPath)
   : _rootPath(rootPath)
{
   _currentParser = new InlineScriptParser();
}

Session :: ~Session()
{
   freeobj(_currentParser);
}

void Session :: parseDirectives(MemoryDump& tape, _ScriptReader& reader)
{
   TapeWriter writer(&tape);

   do {
      if (reader.compare(";")) {
         break;
      }
      else if(reader.compare("#start")) {
         writer.writeCommand(START_VM_MESSAGE_ID);
      }
      else if (reader.compare("#config")) {
         ScriptBookmark bm = reader.read();
         if (bm.state == dfaIdentifier) {
            writer.writeCommand(LOAD_VM_MESSAGE_ID, reader.lookup(bm));
         }
         //else throw EParseError(reader.info.column, reader.info.row);
      }
      else if (reader.compare("#map")) {
         ScriptBookmark bm = reader.read();

         IdentifierString forward;
         if (bm.state == dfaFullIdentifier) {
            forward.append(reader.lookup(bm));

            bm = reader.read();
            if (!reader.compare("="))
               throw EParseError(bm.column, bm.row);

            bm = reader.read();
            if (bm.state == dfaFullIdentifier) {
               forward.append('=');
               forward.append(reader.lookup(bm));
               writer.writeCommand(MAP_VM_MESSAGE_ID, forward);
            }
            else throw EParseError(bm.column, bm.row);
         }
         else throw EParseError(bm.column, bm.row);
      }
      else if (reader.compare("#use")) {
         ScriptBookmark bm = reader.read();

         if (bm.state == dfaQuote) {
            writer.writeCommand(USE_VM_MESSAGE_ID, reader.lookup(bm));
         }
         else {
            IdentifierString package;
            package.append(reader.lookup(bm));

            bm = reader.read();
            if (!reader.compare("="))
               throw EParseError(bm.column, bm.row);

            bm = reader.read();
            if (bm.state == dfaQuote) {
               package.append('=');
               package.append(reader.lookup(bm));
               writer.writeCommand(USE_VM_MESSAGE_ID, package);
            }
            else throw EParseError(bm.column, bm.row);
         }
      }
      else return;

      reader.read();
   }
   while(true);
}

void Session :: parseMetaScript(MemoryDump& tape, _ScriptReader& reader)
{
   reader.read();

   if (reader.compare("[[")) {
      while (!reader.compare("]]")) {
         ScriptBookmark bm = reader.read();

         if(reader.compare("#define")) {
            _currentParser->parseGrammarRule(reader);
         }
         else if (reader.compare("#grammar")) {
            reader.read();

            if (reader.compare("cf")) {
               _currentParser = new CFParser(_currentParser);
            }
            else throw EParseError(bm.column, bm.row);
         }
//         else if(ConstantIdentifier::compare(token, "#mode")) {
//            _currentParser->parseDirective(reader);
//         }
         else parseDirectives(tape, reader);
      }
   }
   else reader.reset();
}

void Session :: parseScript(MemoryDump& tape, _ScriptReader& reader)
{
   TapeWriter writer(&tape);

   _currentParser->parse(reader, writer);
}

void* Session :: translate(TextReader* source)
{
   _lastError.clear();

   ScriptReader scriptReader(source);
   int offset = _tape.Length();
   if (offset != 0)
      throw EInvalidOperation("Tape is not released");

   parseMetaScript(_tape, scriptReader);
   parseScript(_tape, scriptReader);

   _lastError.copy("done");

   return _tape.get(offset);
}

void* Session :: translate(ident_t script)
{
   try {
      IdentifierTextReader reader(script);

      return translate(&reader);
   }
//   catch(EUnrecognizedException) {
//      _lastError.copy("Unrecognized expression");
//
//      return NULL;
//   }
//   catch(EInvalidExpression e) {
//      _lastError.copy("Rule ");
//      _lastError.append(e.nonterminal);
//      _lastError.append(": invalid expression at ");
//      _lastError.appendInt(e.row);
//      _lastError.append(':');
//      _lastError.appendInt(e.column);
//
//      return NULL;
//   }
   catch(EParseError e) {
      _lastError.copy("Invalid syntax at ");
      _lastError.appendInt(e.row);
      _lastError.append(':');
      _lastError.appendInt(e.column);

      return NULL;
   }
   catch (EInvalidOperation e) {
      _lastError.copy("Invalid operation ");
      _lastError.append(':');
      _lastError.append(e.Error());

      return NULL;
   }
}

void* Session :: translate(path_t path, int encoding, bool autoDetect)
{
   try {
      Path scriptPath(_rootPath);
      if (path[0] == '~') {
         scriptPath.combine(path + 2);
      }
      else scriptPath.copy(path);

      TextFileReader reader(scriptPath, encoding, autoDetect);

      if (!reader.isOpened()) {
         _lastError.copy("Cannot open the script file:");

         ident_c tmp[_MAX_PATH];
         Path::savePath(path, tmp, _MAX_PATH);
         _lastError.append(tmp);

         return NULL;
      }

      return translate(&reader);
   }
//   catch(EUnrecognizedException) {
//      _lastError.copy("Unrecognized expression");
//
//      return NULL;
//   }
//   catch(EInvalidExpression e) {
//      _lastError.copy("Rule ");
//      _lastError.append(e.nonterminal);
//      _lastError.append(": invalid expression at ");
//      _lastError.appendInt(e.row);
//      _lastError.append(':');
//      _lastError.appendInt(e.column);
//
//      return NULL;
//   }
   catch(EParseError e) {
      _lastError.copy("Invalid syntax at ");
      _lastError.appendInt(e.row);
      _lastError.append(':');
      _lastError.appendInt(e.column);

      return NULL;
   }
   catch (EInvalidOperation e) {
      _lastError.copy("Invalid operation ");
      _lastError.append(':');
      _lastError.append(e.Error());

      return NULL;
   }
}
