#!/usr/bin/env perl

use strict;
use warnings;

#use strict;
#use warnings;

#variables
  my $i = 1;
  my ($i2 = 1, $i3);
  my $count;
  my $line;
  #my $i = 1; #can only declar once
  my $s = 'string';
  my @s = (1,3,'string');
  my @i; #works but is bad practice

#stdout

  #print
    print 'string';
    print 's1', 's2', 123;

#numbers
  print 1;
  print 4.4;
  print 1.2e10;

  print 1 + 2 - 3*(10/5) ** 4;

#booleans
  print !0;
  print !1 + 0;
  print !'string that converts to 1' + 0;
  print !'';

  print 1 && 'adsf';
  print 1 && '';

  print 0 || 1;
  print 0 || 0;

#compairison
  print 1 == 1;
  print '11' == '11';
  print '11' == '12';
  print '1' == 1;
  print 1 eq 1;
  print 1 eq 0;

  #==	!= <	<= >  >=
  #eq	ne lt	le gt ge

#strings
  print 'as' . 'df';
  print 'as' x 3;
  print length 'foo';
  print substr 'foo', 1, 2;
  print index 'foo', 'o';
  print rindex 'foo', 'o'; #last occurence

  print "as $i df $s\n";
  print 'as $i df $s\n';

  print "1" + 1;
  print 1 . 2;
  print "a" . (1+2);

  #chomp
    $s = "chomp\n\n";
    chomp $s;
    print $s; #remove trailling \n

  #join
    print join (',',(1,2,3));

#regex
  my $mystring;
  my @myarray;

  $mystring = "Hello world!";
  print "m" if $mystring =~ m/World/;
  print "m" if $mystring =~ m/WoRlD/i; #ignore case

  $mystring = "[2004/04/13] The date of this article.";
  print "The first digit is $1." if $mystring =~ m/(\d)/

  $mystring = "[2004/04/13] The date of this article.";
  print "The first number is $1." if $mystring =~ m/(\d+)/

  $mystring = "[2004/04/13] The date of this article.";
  while($mystring =~ m/(\d+)/g) {
    print "Found number $1.";
  }

  $mystring = "[2004/04/13] The date of this article.";
  @myarray = ($mystring =~ m/(\d+)/g);
  print join(",", @myarray);

  $mystring =~ s/world/mom/;
  print $mystring;
  print $mystring if $mystring =~ s/mom/world/; #returns if replaced

  #\A - Matches only at the beginning of a string
  #\Z - Matches only at the end of a string or before a newline
  #\z - Matches only at the end of a string
  #\G - Matches where previous m//g left off 

#lists
  print (1, 2, 'asdf', (1,2) );
  print (1 .. 5);

#array
  my @array = (1, 2, 3);
  #array = ();

  print $array[2];
  print $#array; #last index

  push @array, 4; #put at ent
  print @array;
  
  pop @array; #remove
  print @array;

  shift @array; #left shift
  print @array;

  unshift @array, 0;
  print @array;

  #context magic
    my @array2 = @array; # list context
    print @array2;

    my $length = @array; # scalar context
    print $length;

#hash
  my %hash = ('key1', 'value1', 'key2', 'value2');
  #my %hash = (key1 => 'value1', key2 => 'value2'); #same
  print %hash;
  print $hash{key1};
  print keys %hash;
  print values %hash;

#conditional
  #if
    if (1 == 1) {
        print 'True';
    }

    if (1) {
        print 'Hello';
    }
    elseif (1) {
        print 'Bye';
    }
    else {
        print 'Neither';
    }

    print 'true' if 1 > 0;
    print 'true' unless 1 == 0;

#loops

  #for
    print for (1 .. 10);

  #foreach
    foreach my $element (1, 2, 3, 4, 5) {
        print $element;
    }

    @array = (1 .. 5);
    foreach my $element (@array) {
        print $element;
    }

    #alters value
      @array = (1 .. 5);
      foreach my $element (@array) {
          $element *= 2;
      }

      foreach my $element (@array) {
          print $element;
      }

  #while
    $i = 10;
    while ($i > 0) {
      print $i;
      $i = $i - 1;
    }

    #last = break
      $i = 0;
      while ($i < 100) {
          last if $i == 10;
          print $i;
          $i = $i + 1;
      }

    #inverse notation
      $count = 0;
      print $count, " " while ++$count <= 10;
      print "\n"; 

#defalut variables
  #http://www.kichwa.com/quik_ref/spec_variables.html


  #__
    $_ = 'Hello';
    print;

    print for (1 .. 10);

  #print $.; #input line numeber of last handle read

  $/ = ':';
  print $/; #input record reparator

  $\ = "\n"; #output record separator for print
  $, = "\n"; #output field separator for print
  #$# = ''; #output format for numbers in print
  print $\; 

  print $$; #cur process
  print 'ok' if $?; #status of last process close
  print $0; #name of file of script being executed

  
  #regex
    #$1..$9 #last regex match
    #$& #string of last pattern match
    #$`
    #$'
    #$+

  print $ARGV[0];

#operators

#diamond

  open(FH,"<file");
  @ARRAY = <FH>;

  #while($line = <STDIN>) {
    #chomp $line;
  #}

  #while($line = <>) {
    #chomp;
  #}

#functions
  sub miles_to_kilometers {
    my ($miles) = @_;
    return $miles * 1.609344;
  }

  print miles_to_kilometers(5);

  sub modify
  {
    my($text, $code) = @_;
  }

#file io
  #http://www.troubleshooters.com/codecorn/littperl/perlfile.htm

  #transfor into another
    #open(MYINPUTFILE, "<filename.in");
    #open(MYOUTPUTFILE, ">filename.out");
    #while(<MYINPUTFILE>)
    #{
    #my($line) = $_;
    #chomp($line);
    #if($line =~ m|(\d{5})(.{20})(\d\d)/(\d\d)/(\d\d)|)
    #{
    #my($zip,$name,$mm,$dd,$yy) = ($1,$2,$3,$4,$5);
    #if($yy > 10)
    #{$yy += 1900}
    #else
    #{$yy += 2000}
    #my($first, $last) = split(/ /, $name);
    #$line = sprintf("%-16s%-10s%02d/%02d/%04d%5d",
    #$last,$first,$mm,$dd,$yy,$zip);
    #print MYOUTPUTFILE "$line\n";
    #}
    #}
    #close(MYINPUTFILE);
    #close(MYOUTPUTFILE);

  #modify file
    #open(FH, "+< FILE")                 or die "Opening: $!";
    #@ARRAY = <FH>;
    #foreach my $line (@array) {
        #$line =~ s/a/A/
    #}
    #seek(FH,0,0)                        or die "Seeking: $!";
    #print FH @ARRAY                     or die "Printing: $!";
    #truncate(FH,tell(FH))               or die "Truncating: $!";
    #close(FH)                           or die "Closing: $!";
