#!/usr/bin/perl
 
# A workout buddy matching platform

# Set up database
use DBI;
my $dbh = DBI->connect("DBI:mysql:databasename:localhost",
    "username", "password");
 
# Get data from the form
my %form;
foreach my $pair (split /&/, $ENV{'QUERY_STRING'}) {
    my ($name, $value) = split /=/, $pair;
    $form{$name} = $value;
}
 
# Create the query
my $sql = "INSERT INTO users (name,city,state,activities,email) VALUES ('$form{'name'}','$form{'city'}','$form{'state'}','$form{'activities'}','$form{'email'}')";
my $sth = $dbh->prepare($sql);
$sth->execute;
 
# Print the page
print "Content-type: text/html\n\n";
print "<html><head><title>Matching Platform</title></head><body>";
print "<h1>Thanks for joining</h1>\n";
print "<p>You have been added to our database of users seeking workout buddies</p>";
print "</body></html>";

# Add a form for users to enter data
print "<form action=\"buddy.cgi\" method=\"post\">\n";
print "<p>Name: <input type=\"text\" name=\"name\" size=\"30\" maxlength=\"60\"></p>\n";
print "<p>Email: <input type=\"text\" name=\"email\" size=\"30\" maxlength=\"60\"></p>\n";
print "<p>City: <input type=\"text\" name=\"city\" size=\"30\" maxlength=\"30\"></p>\n";
print "<p>State: <input type=\"text\" name=\"state\" size=\"2\" maxlength=\"2\"></p>\n";
print "<p>Activities: <textarea name=\"activities\" rows=\"4\" cols=\"30\"></textarea></p>\'";
print "<input type=\"submit\" value=\"Submit\">\n";
print "</form>\n";

# Retrieve users from the database
my $sql = "SELECT name, city, state, activities, email FROM users";
my $sth = $dbh->prepare($sql);
$sth->execute;
 
# Print out a table of users
print "<table>\n";
print "<tr>";
print "<th>Name</th>";
print "<th>City</th>";
print "<th>State</th>";
print "<th>Activities</th>";
print "<th>Email</th>";
print "</tr>\n";
while (my @row = $sth->fetchrow_array) {
    print "<tr>";
    print "<td>$row[0]</td>";
    print "<td>$row[1]</td>";
    print "<td>$row[2]</td>";
    print "<td>$row[3]</td>";
    print "<td>$row[4]</td>";
    print "</tr>\n";
}
print "</table>\n";
 
# Clean up
$dbh->disconnect;