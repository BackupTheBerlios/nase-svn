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
%left CSTART
%token CEND
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
%token ALBRACE
%token ARBRACE
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
#  use diagnostics;
#  use strict;
  use NASE::globals;
  use NASE::xref;
  use CGI qw/:standard :html3 :netscape -debug/;
  use CGI::Carp qw(fatalsToBrowser);

  # to let the parser code run with strict
  my ($DCOLON,
      $CVSTAG,
      $AIM,
      $COMMENT,
      $WS,
      $VER,
      $DOCSTART,
      $DOCEND,
      $NAME,
      $EOL,
      $PURP,
      $CAT,
      $CALLSEQ,
      $OPTINP,
      $INP,
      $KEYS,
      $OUT,
      $OPTOUT,
      $COMBLO,
      $SIDEFF,
      $RESTR,
      $PROCED,
      $EXAMP,
      $SEEALSO,
      $AUTHOR,
      $MODHIST,
      $URLSTARTN,
      $URLSTARTL,
      $URLSTART,
      $TTSTART,
      $TTEND,
      $BSTART,
      $BEND,
      $CSTART,
      $CEND,
      $ISTART,
      $IEND,
      $SUPSTART,
      $SUPEND,
      $SUBSTART,
      $SUBEND,
      $BREAK,
      $URLEND,
      $TEXT,
      $DEFAULT,
      $LBRACE,
      $RBRACE,
      $CLBRACE,
      $CRBRACE,
      $ALBRACE,
      $ARBRACE,
      $LANK,
      $RANK,
      $SUPERCLASSES,
      $CONSTRUCTION,
      $DESTRUCTION,
      $ABMETHODS,
      $METHODS,
      $PRE,
      $COLON,
      $YYERRCODE,
      @yylhs,
      @yylen,
      @yydefred,
      @yydgoto,
      @yysindex,
      @yyrindex,
      @yygindex,
      $YYTABLESIZE,
      @yytable,
      @yycheck,
      $YYFINAL,
      $YYMAXTOKEN,
      @yyname,
      @yyrule
      );

  my $tab;
  my $colon  = 0;  # 0: no; 1: yes
  my $tag    = 0;
  my $pre    = 0;  # format like in source file
  my $prestr = ''; # string to be cut from pre environments
  my $name   = 0;  # are we in the NAME tag?
  my $aim    = 3;  # we are in the aim tag, 1:yes 2:just left >2:no
  my $aimstr = '';
  my $cat    = 3;  # we are in the cat tag, 1:yes 2:just left >2:no
  my @cat    = ();
  my $str    = '';
  my @str    = ();
  my @line   = ();
  my @lines  = ();
  my $line   = '';

  sub endpre {
    if ($pre) { push(@line, "</PRE>") ; };
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
		    $hentry[2] = $aimstr;
		    $aimstr = '';
                    $aim++}
    if ($cat == 1) {
                    ($str = $line) =~ s,(^\s+|\s+$),,gi;
                    $str =~ s,\s\s+, ,gi;
		    @str = split (/[^_a-zA-Z0-9]/, $str);
		    foreach $str (@str){
		      if (($str ne '') && ($str ne ' ')){ push(@cat, $str); }
		    }
                   }
    if ($cat == 2) {
                    $hentry[3] =  join(",",@cat);
		    @cat = ();
                    $cat++;}

    push(@lines, $line); @line=();
  }


  sub PrintAll {
    line2lines;
    if ($pre) { push(@lines, "</PRE>") ; };
    if ($colon){ push(@lines, "</TD></TR></TABLE>"); }; 
    push(@lines, "</TD></TR>"); 
    $hentry[4] = join("\n", @lines);
    @lines = ();
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
                                            $hentry[1] =  $1;
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
     | CSTART                           { push(@line, '<TT CLASS="command">'); }
     | CEND                             { push(@line, "</TT>"); }
     | ISTART                           { push(@line, "<I>"); }
     | IEND                             { push(@line, "</I>"); }
     | SUPSTART                         { push(@line, "<SUP>"); }
     | SUPEND                           { push(@line, "</SUP>"); }
     | SUBSTART                         { push(@line, "<SUB>"); }
     | SUBEND                           { push(@line, "</SUB>"); }
     | BREAK                            { push(@line, "<BR>"); }
     | DEFAULT                          { push(@line, $1); }
     | WS                               { push(@line, $1); }
     | LBRACE                           { push(@line, $1); }
     | RBRACE                           { push(@line, $1); }
     | CLBRACE                          { push(@line, $1); }
     | CRBRACE                          { push(@line, $1); }
     | ALBRACE                          { push(@line, $1); }
     | ARBRACE                          { push(@line, $1); }
     | COLON                            { push(@line, $1); }
     | DCOLON                           { 
                                          if ($pre) {					    
					    push(@line, "::");
					  } else {
                                            $tab='<TR><TD VALIGN=TOP CLASS="keycode">';
					    if ($colon){ push(@lines, pop(@lines)."</TD></TR>\n"); } 
					    else { $tab = "<TABLE><COLGROUP SPAN=2></COLGROUP>".$tab; };
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
     | PRE EOL                          { beginpre; endpre; line2lines;  }
     | PRE { beginpre; } WORDS EOL      { endpre; line2lines;  }
     ;


LINES : LINE LINES                      
      | LINE                            
      ;



ID   : EXAMP                           { $cat++; $aim++; tagentry($1); }
     | VER                             { $cat++; $aim++; tagentry($1); }
     | NAME                            { $cat++; $aim++; $name = 1; }
     | AIM                             { $cat++; $aim=1; tagentry($1); }
     | PURP                            { $cat++; $aim++; tagentry($1); }
     | CAT                             { $cat=1; $aim++; tagentry($1); }
     | CALLSEQ                         { $cat++; $aim++; tagentry($1); }
     | COMBLO                          { $cat++; $aim++; tagentry($1); }
     | SIDEFF                          { $cat++; $aim++; tagentry($1); }
     | RESTR                           { $cat++; $aim++; tagentry($1); }
     | PROCED                          { $cat++; $aim++; tagentry($1); }
     | SEEALSO                         { $cat++; $aim++; tagentry($1); }
     | AUTHOR                          { $cat++; $aim++; tagentry($1); }
     | MODHIST                         { $cat++; $aim++; tagentry($1); }
     | INP                             { $cat++; $aim++; tagentry($1); }
     | KEYS                            { $cat++; $aim++; tagentry($1); }
     | OPTINP                          { $cat++; $aim++; tagentry($1); }
     | OUT                             { $cat++; $aim++; tagentry($1); }
     | OPTOUT                          { $cat++; $aim++; tagentry($1); }
     | SUPERCLASSES                    { $cat++; $aim++; tagentry($1); }
     | CONSTRUCTION                    { $cat++; $aim++; tagentry($1); }
     | DESTRUCTION                     { $cat++; $aim++; tagentry($1); }
     | ABMETHODS                       { $cat++; $aim++; tagentry($1); }
     | METHODS                         { $cat++; $aim++; tagentry($1); }
     ;
%%
