%left  DCOLON
%token CVSTAG
%token AIM
%token COMMENT
%token WS
%token VER
%token DOCSTART
%token DOCEND
%token NAME
%token EOL
%token PURP
%token CAT
%token CALLSEQ
%token OPTINP
%token INP
%token OPTINP
%token KEYS
%token OUT
%token OPTOUT
%token COMBLO
%token SIDEFF
%token RESTR
%token PROCED
%token EXAMP
%token SEEALSO
%token AUTHOR
%token MODHIST
%left URLSTARTN
%left URLSTARTL
%left URLSTART
%left TTSTART
%token TTEND
%left BSTART
%token BEND
%left ISTART
%token IEND
%left SUPSTART
%token SUPEND
%left SUBSTART
%token SUBEND
%token BREAK
%token URLEND
%left TEXT
%token DEFAULT
%token LBRACE
%token RBRACE
%token CLBRACE
%token CRBRACE
%token LANK
%token RANK
%token SUPERCLASSES
%token CONSTRUCTION
%token DESTRUCTION
%token ABMETHODS
%token METHODS
%token PRE
%token COLON


%%
%{
  use NASE::globals;
  use NASE::xref;
  use CGI qw/:standard :html3 :netscape -debug/;
  use CGI::Carp qw(fatalsToBrowser);

  my $colon  = 0;  # 0: no; 1: yes
  my $tag    = 0;
  my $pre    = 0;  # format like in source file
  my $prestr = ''; # string to be cut from pre environments
  my $rbrace = 0;  # level of open round braces
  my $name   = 0;  # are we in the NAME tag?
  my $aim    = 3;  # we are in the aim tag, 1:yes 2:just left >2:no
  my $aimstr = '';

  sub endpre {
    if ($pre) { push(@lines, "</PRE>") ; };
    $pre = 0; $prestr='';
  }

  sub tagentry {
    if ($colon){ push(@lines, "</TD></TR></TABLE>"); 
                 $colon = 0;
               };
    if ($tag){ push(@lines, "</TD></TR>"); }; # dont execute first time
    $tag = 1;
    push (@lines, '<TR><TD CLASS="xmpcode" VALIGN=TOP>'.join("", @_)."</TD>\n".'<TD CLASS="xplcode" VALIGN=TOP>');
    @line = ();
    endpre;
  }


  sub beginpre {
    $pre++;
    push(@line, "<PRE>");
  }

  sub line2lines {
    $line = join("", @line);
    if ($pre){
      if ($pre eq 2){ 
	              $line =~ m,^(\s+),,; 
                      $prestr = $1;
                    };

      $line =~ s,^($prestr),,; 
      $pre++;
    }
    if ($aim == 1) {
                    $aimstr .= $line;
                   }
    if ($aim == 2) {
                    $aimstr =~ s,(^\s+|\s+$),,gi;
                    $aimstr =~ s,\s\s+, ,gi;
		    push(@hentry, $aimstr);
		    $aimstr = '';
                    $aim++}
    push(@lines, $line); @line=();
  }


  sub PrintAll {
    line2lines;
    if ($pre) { push(@lines, "</PRE>") ; };
    print join("\n", @lines);
    if ($colon){ print "</TD></TR></TABLE>"; }; 
    print "</TD></TR>\n"; 
    return 0;
  }


%}

DOCHEADER : START LINES DOCEND EOL      { PrintAll(); return 0;}

START : DOCSTART EOL                    


URL  : URLSTART TEXT URLEND                { push(@line, makeURL($2)); }
     | URLSTARTL TEXT RANK TEXT URLEND     { push(@line, makeURL($2,$4)); }
     | URLSTARTN TEXT RANK TEXT URLEND     { push(@line, "<A HREF=".$2.">".$4."</A>"); }
     | URLSTART TEXT LBRACE RBRACE URLEND  { push(@line, makeURL($2)); }
     ;

WORDS : WORD WORDS
      | WORD
      ;

WORD : CVSTAG                           { push(@line, "<PRE>".$1."</PRE>"); }
     | TEXT                             { if ($name) {
                                            push(@hentry, $1);
                                            $name=0;
                                          } else {
                                            push(@line, $1); 
                                          }
                                        }
     | LANK                             { push(@line, "&lt "); }
     | RANK                             { push(@line, "&gt "); }
     | URL
     | TTSTART                          { push(@line, "<TT>"); }
     | TTEND                            { push(@line, "</TT>"); }
     | BSTART                           { push(@line, "<B>"); }
     | BEND                             { push(@line, "</B>"); }
     | ISTART                           { push(@line, "<I>"); }
     | IEND                             { push(@line, "</I>"); }
     | SUPSTART                         { push(@line, "<SUP>"); }
     | SUPEND                           { push(@line, "</SUP>"); }
     | SUBSTART                         { push(@line, "<SUB>"); }
     | SUBEND                           { push(@line, "</SUB>"); }
     | BREAK                            { push(@line, "<BR>"); }
     | DEFAULT                          { push(@line, $1); }
     | WS                               { push(@line, $1); }
     | LBRACE                           { push(@line, $1); $rbrace++; }
     | RBRACE                           { push(@line, $1); $rbrace--; }
     | CLBRACE                          { push(@line, $1); $rbrace++; }
     | CRBRACE                          { push(@line, $1); $rbrace--; }
     | COLON                            { push(@line, $1); }
     | DCOLON                           { 
                                          if ($pre || $rbrace) {					    
					    push(@line, ":");
					  } else {
                                            $tab='<TR><TD VALIGN=TOP CLASS="keycode">';
					    if ($colon){ push(@lines, pop(@lines)."</TD></TR>\n"); } 
					    else { $tab = "<TABLE COLS=2>".$tab; };
					    unshift(@line, $tab);
					    push(@line, "</TD><TD>");
					    $colon=1;
					  }
                                        }
     ;

LINE : COMMENT EOL                      { line2lines; }
     | COMMENT WORDS EOL                { line2lines; }
     | COMMENT WORDS ID EOL             { line2lines; }
     | COMMENT WORDS ID WORDS EOL       { line2lines; }
     | PRE { beginpre; } EOL            { line2lines; endpre; }
     | PRE { beginpre; } WORDS EOL      { line2lines; endpre; }
     ;


LINES : LINE LINES                      
      | LINE                            
      ;



ID   : EXAMP                           { $aim++; tagentry($1); }
     | VER                             { $aim++; tagentry($1); }
     | NAME                            { $aim++; $name = 1; }
     | AIM                             { $aim=1; tagentry($1); }
     | PURP                            { $aim++; if (parseAim()) { PrintAll(); return 0; } else { tagentry($1);}; }
     | CAT                             { $aim++; tagentry($1); }
     | CALLSEQ                         { $aim++; tagentry($1); }
     | COMBLO                          { $aim++; tagentry($1); }
     | SIDEFF                          { $aim++; tagentry($1); }
     | RESTR                           { $aim++; tagentry($1); }
     | PROCED                          { $aim++; tagentry($1); }
     | SEEALSO                         { $aim++; tagentry($1); }
     | AUTHOR                          { $aim++; tagentry($1); }
     | MODHIST                         { $aim++; tagentry($1); }
     | INP                             { $aim++; tagentry($1); }
     | KEYS                            { $aim++; tagentry($1); }
     | OPTINP                          { $aim++; tagentry($1); }
     | OUT                             { $aim++; tagentry($1); }
     | OPTOUT                          { $aim++; tagentry($1); }
     | SUPERCLASSES                    { $aim++; tagentry($1); }
     | CONSTRUCTION                    { $aim++; tagentry($1); }
     | DESTRUCTION                     { $aim++; tagentry($1); }
     | ABMETHODS                       { $aim++; tagentry($1); }
     | METHODS                         { $aim++; tagentry($1); }
     ;
%%
