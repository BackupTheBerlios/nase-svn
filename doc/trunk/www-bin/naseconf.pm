package naseconf;

use DBIx::HTMLView;

# This is the db description, the first argument to DB is the DBI
# specifikation of you database, while the second and the third is the
# username and password.

# Below you can specify which db to use for testing (default is
# HTMLViewTester on a local mysql server). To run the test you will have
# to create the database specified. The test script will populate this 
# database with the tables it needs for it's tests. Below is specific 
# instructions on how to do this with mySQL and mSQL.

# mySQL is the sugested database engine, using it the test script
# takes less than half the time of what it needs using mSQL. mySQL can
# be found at http://www.mysql.org/. To set up a test database using
# an installed mysql server you simply:
#
#   mysqladmin create HTMLViewTester
#
# Then to make it accessable by everyone type:
#
#   mysql -e "insert into db values ('localhost','HTMLViewTester','','y'\
#   ,'y','y','y','y','y','y','y','y','y')" mysql
#
# You sometimes have to restart the mysqld server before this kind of
# changes to the access information taks any effekt.

# If you have mSQL installed setting up a local db for the test is
# simple. Just start msqlconfig, and the press the following keys:
#
#   D (Database configuration)
#   n (to create a new databse)
#   HTMLViewTester (to name the newly created database HTMLViewTester)
#   r (to set the read premitions)
#     (the name of the user you'll be running the tests as)
#   w (to set the write premitions)
#     (the name of the user you'll be running the tests as)
#   a (to set the access methods allowed)
#   local (to allow loacl accesses only)
#
# Now the new database is set up properly, press q, w, q, to return to
# the main menu, write the configuration to the disk and exit
# msqconfig. Now cahnge the DBI specifikation string (1a argument)
# below to "DBI:mSQL:HTMLViewTester"

sub dbi {
  my ($usr, $pw)=@_;
  return mysqlDB("DBI:mysql:nase", "chiefnase", "misfitme", 
		 Table('news', Id('date'), Text('news'))
		);
}
1;

# Local Variables:
# mode:              perl
# tab-width:         8
# perl-indent-level: 2
# End:
