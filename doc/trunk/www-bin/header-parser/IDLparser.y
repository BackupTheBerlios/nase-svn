%left  COLON
%token AIM
%token COMMENT
%token WS
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
%left URLSTART
%token URLEND
%left TEXT
%token DEFAULT
%token LBRACE
%token RBRACE
%token LANK
%token RANK
%token PRE
%%
%{
  use NASE::globals;
  use NASE::xref;
  use CGI qw/:standard :html3 :netscape -debug/;
  use CGI::Carp qw(fatalsToBrowser);

  $colon  = 0;  # 0: no; 1: yes
  $tag    = 0;
  $pre    = 0;  # format like in source file
  $prestr = ''; # string to be cut from pre environments
  $rbrace = 0;  # level of open round braces
  $name   = 0;  # are we in the NAME tag?
  $tmp    = '';

  sub tagentry {
    if ($colon){ push(@lines, "</TD></TR></TABLE>"); 
                 $colon = 0;
               };
    if ($tag){ push(@lines, "</TD></TR>"); };
    push (@lines, "<TR><TD BGCOLOR=#FFFFE0 VALIGN=TOP>".join(" ", @_)."</TD><TD BGCOLOR=#EEEEFF VALIGN=TOP>");
    @line = ();
    $tag = 1;
    if ($pre) { push(@lines, "</PRE>") ; };
    $pre = 0; $prestr='';
  }

  sub beginpre {
    $pre++;
    push(@line, "<PRE>");
  }

  sub line2lines {
    $line = join(" ", @line);
    if ($pre){
      if ($pre eq 2){ 
	              $line =~ m,^(\s+),,; 
                      $prestr = $1;
                    };

      $line =~ s,^($prestr),,; 
      $pre++;
    }
    push(@lines, $line); @line=();
  }



%}

DOCHEADER : START LINES DOCEND EOL      { if ($pre) { push(@lines, "</PRE>") ; };
                                          print join("\n", @lines); 
                                          if ($colon){ print "</TD></TR></TABLE>"; }; 
                                          print "</TD></TR></TABLE>\n"; exit(0); }

START : DOCSTART EOL                    


URL  : URLSTART TEXT URLEND                { push(@line, makeURL($2)); }
     | URLSTART TEXT LBRACE RBRACE URLEND  { push(@line, makeURL($2)); }
     ;

WORDS : WORD WORDS
      | WORD
      ;

WORD : TEXT                             { if ($name) {
                                            ($tmp = $1) =~ s,[ \(\)],,g;
                                            push(@line, h1($tmp."<FONT SIZE=-1><A HREF=".getBaseURL().getSubDir."?file=".lc($tmp)."&mode=text&show=source>source</A> <A HREF=".getBaseURL().getSubDir."?file=".lc($tmp)."&mode=text&show=log>modifications</A> ".showedit(lc($tmp))."</FONT>")); 
					    push(@line, '<TABLE VALIGN=TOP COLS=2 WIDTH="35%,65%">');  
                                            $name=0;
                                          } else {
                                           push(@line, $1); 
                                          }
                                        }
     | LANK                             { push(@line, $1); }
     | RANK                             { push(@line, $1); }
     | URL
     | DEFAULT                          { push(@line, $1); }
     | WS                               { push(@line, $1); }
     | LBRACE                           { push(@line, $1); $rbrace++; }
     | RBRACE                           { push(@line, $1); $rbrace--; }
     | COLON                            { 
                                          if ($pre || $rbrace) {					    
					    push(@line, ":");
					  } else {
                                            $tab="<TR><TD VALIGN=TOP bgcolor=#CCCCCC>";
					    if ($colon){ push(@lines, pop(@lines)."</TD></TR>\n"); } 
					    else { $tab = "<TABLE COLS=2".$tab; };
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
     ;


LINES : LINE LINES                      
      | LINE                            
      ;



ID   : EXAMP                           { tagentry($1); beginpre; }
     | NAME                            { $name = 1; }
     | AIM                             { tagentry($1); }
     | PURP                            { tagentry($1); }
     | CAT                             { tagentry($1); }
     | CALLSEQ                         { tagentry($1); }
     | COMBLO                          { tagentry($1); }
     | SIDEFF                          { tagentry($1); }
     | RESTR                           { tagentry($1); }
     | PROCED                          { tagentry($1); }
     | SEEALSO                         { tagentry($1); }
     | AUTHOR                          { tagentry($1); }
     | MODHIST                         { tagentry($1); beginpre; }
     | INP                             { tagentry($1); }
     | KEYS                            { tagentry($1); }
     | OPTINP                          { tagentry($1); }
     | OUT                             { tagentry($1); }
     | OPTOUT                          { tagentry($1); }
     ;
%%
