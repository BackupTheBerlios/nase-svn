%left  COLON
%token DOCSTART
%token DOCEND
%token NAME
%token EOL
%token PURP
%token CAT
%token CALL
%token SEQ
%token OPT
%token INP
%token KEYS
%token OUT
%token COMBLO
%token SIDEFF
%token RESTR
%token PROCED
%token EXAMP
%token SEEALSO
%token AUTHOR
%token MODHIST
%left URLSTART
%token URLEND
%left TEXT
%%
%{
  use NASE::xref;
  use CGI qw/:standard :html3 :netscape -debug/;
  use CGI::Carp qw(fatalsToBrowser);

  sub tabEntry {
    print "<TR><TD>", join(" ", @_), "</TD>";
  }
  sub tabEntry2 {
    print "<TD>", join(" ", @_), "</TD>";
  }

  $colonActive = 0;
#  local @tagrhs, $colonActive;
%}

DOCHEADER : START TAGS DOCEND EOLS     { print "</TABLE>\n"; }

START : DOCSTART EOLS                  { print "<TABLE COLS=2>\n"; } 



TAGS : TAG                             { $colonActive = 0; }
     | TAG TAGS                        { $colonActive = 0; }
     ;

TAG  : ID1 DATA    { print join(" ", @lines), "</TR>\n"; @lines = (); }
     | ID1 EOLS    { print "<TD></TD></TR>\n"; }
     | ID2 DATA    { print join(" ", @lines), "</TR>\n"; @lines = (); }
     | ID2 EOLS    { print "<TD></TD></TR>\n"; }
     ;

ID1  : NAME                            { tabEntry($1); }
     | PURP                            { tabEntry($1); }
     | CAT                             { tabEntry($1); }
     | CALL SEQ                        { tabEntry($1, $2); }
     | COMBLO                          { tabEntry($1); }
     | SIDEFF                          { tabEntry($1); }
     | RESTR                           { tabEntry($1); }
     | PROCED                          { tabEntry($1); }
     | EXAMP                           { tabEntry($1); }
     | SEEALSO                         { tabEntry($1); }
     | AUTHOR                          { tabEntry($1); }
     | MODHIST                         { tabEntry($1); }
     ;

ID2  : INP                             { tabEntry($1); }
     | KEYS                            { tabEntry($1); }
     | OPT INP                         { tabEntry($1, $2); }
     | OUT                             { tabEntry($1); }
     | OPT OUT                         { tabEntry($1, $2); }
     ;


URL  : URLSTART TEXT URLEND            { unshift(@line, makeURL($2)); }

CONTENT : TEXT                         
        | URL


#                                         push(@tagrhs, "<TD>", $1, "</TD><TD>:</TD><TD>", $3, "</TD>" );
#	                               }

LINE : CONTENT EOLS                    { unshift(@line, $1); }
     | CONTENT LINE                    { unshift(@line, $1); }
     | CONTENT COLON LINE              { 
                                         if ($colonActive){ unshift(@line, "</TD></TR>\n"); }
                                         unshift(@line, "<TD>", $1, "</TD><TD>:</TD><TD>");
                                         $colonActive=1;
                                       }
     ;

DATA : LINE      { unshift(@lines, join(" ", @line), "\nline\n"); @line = (); }
     | LINE DATA { unshift(@lines, join(" ", @line), "\n"); @line = (); }
#print "<TD>",$1,"</TD><TD>:</TD><TD>",$3,"</TD></TR>\n"; }
     ;
   
EOLS : EOL
     | EOL EOLS
%%
