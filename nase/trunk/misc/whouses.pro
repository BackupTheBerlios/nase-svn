

PRO WHOUSES, routine


NASEDIR = GetEnv("NASEPATH")
IF NASEDIR EQ "" THEN Console, "environment variable NASEPATH not set", /FATAL

hasPerl = Command("perl", /NOSTOP)
IF hasPerl EQ !NONE THEN Console, 'you need perl to use this routine', /FATAL

Spawn, NASEDIR+"/doc/tools/whouses "+routine


END
