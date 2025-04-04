#include <iostream>
#include <sstream>
#include "tokens.hpp"
#include "output.hpp"

int main() {
    enum tokentype token;

    // read tokens until the end of file is reached
    while ((token = static_cast<tokentype>(yylex()))) {
        classifyToken(token);
    }
    return 0;
}

void classifyToken(tokentype token) {
    switch (token) {
        case STRING:
            handleString();

        case UNCLOSED_STRING:
            output::errorUnclosedString();

        case UNDEFINED_ESCAPE:
            output::errorUndefinedEscape(yytext);
        
        case UNDEFINED_HEXA:
            handleUndefinedHexa();

        case UNKNOWN_CHAR:
            output::errorUnknownChar(yytext[0]);

        default:
            output::printToken(yylineno, token, yytext);
    }
}

void handleUndefinedHexa() {
    std::string str = yytext;
    std::size_t size = str.size();
    std::size_t start, end;

    if (str[size - 2] == 'x')
        start = size - 2;
    else
        start = size - 3;
    
    if (str[size - 1] == '"')
        end = size - 2;
    else
        end = size - 1;

        std::size_t length = end - start + 1;

    const char* cstr = (str.substr(start, length)).c_str();
    output::errorUndefinedEscape(cstr);
}

void handleString() {
    std::string str = yytext;
    std::string output = "";
    std::size_t size = str.size();
    
    for (std::size_t i = 0; i < size; i++) {
        char current = str[i];
        char next = str[i + 1];

        if (current == '"')
            continue;
        
        if (current == '\\') {
            i++;
            if (next == 'n') {
                output += "\n";
            }
            else if (next == 'r') {
                output += "\r";
            }
            else if (next == 't') {
                output += "\t";
            }
            else if (next == '"') {
                output += "\"";
            }
            else if (next == 'x') {
                std::stringstream hexstr;
                hexstr << std::hex << str.substr(i + 1, 2);
                int hexval = 0;
                hexstr >> hexval;

                output += hexval;
                i += 2;
            }
            else {
                output += "\\";
            }
        }
        else
            output += current;
    }
    output::printToken(yylineno, STRING, output.c_str());
}