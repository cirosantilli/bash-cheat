#!/usr/bin/env perl

#perl cheat

#use use perl on a golfing one liner focus

#python for more involved applications

use strict;
use warnings;

##variables

  my $i = 1;
  my ($i2 = 1, $i3);
  my $count;
  my $line;
  #my $i = 1; #can only declar once
  my $s = 'string';
  my @s = (1,3,'string');
  my @i; #works but is bad practice

##stdout

  ##print

    print 'string';
    print 's1', 's2', 123;

##numbers
  print 1;
  print 4.4;
  print 1.2e10;

  print 1 + 2 - 3*(10/5) ** 4;

##booleans

  print !0;
  print !1 + 0;
  print !'string that converts to 1' + 0;
  print !'';

  print 1 && 'adsf';
  print 1 && '';

  print 0 || 1;
  print 0 || 0;

##compairison

  print 1 == 1;
  print '11' == '11';
  print '11' == '12';
  print '1' == 1;
  print 1 eq 1;
  print 1 eq 0;

  #==	!= <	<= >  >=
  #eq	ne lt	le gt ge

##strings

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

  ##chomp

    $s = "chomp\n\n";
    chomp $s;
    print $s; #remove trailling \n

  ##join

    print join (',',(1,2,3));

##regex

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

##hash map

  my %hash = ('key1', 'value1', 'key2', 'value2');
  #my %hash = (key1 => 'value1', key2 => 'value2'); #same
  print %hash;
  print $hash{key1};
  print keys %hash;
  print values %hash;

##branch

  ##if

    ##single line

      print 'a' if 1;

      #can only use single command: no ``;`` accepted
      print 'a'; print 'b' if 0;
        #prints a

    ##multiline

      if (1)
      {
          print 'Hello';
      }
      elseif (1)
      {
          print 'Bye';
      }
      else
      {
          print 'Neither';
      }

  ##unless

    print 'true' unless 1 == 0;

  ##for

    print for (1 .. 10);

  ##foreach

    foreach my $e (1, 2, 3)
    {
        print $e;
    }

    @a = (1 .. 3);
    foreach my $e (@a)
    {
        print $e;
    }

    #alters value

      @a = (1 .. 5);
      foreach my $e (@a)
      {
          print $e;
          $e *= 2;
      }

  ##while

    $i = 10;
    while ($i > 0)
    {
      print $i;
      $i = $i - 1;
    }

    ##last = break

      $i = 0;
      while ($i < 100) {
          last if $i == 10;
          print $i;
          $i = $i + 1;
      }

    ##single line

      $count = 0;
      print $count, " " while ++$count <= 10;
      print "\n"; 

#defalut variables

  ##sources

  #<http://www.kichwa.com/quik_ref/spec_variables.html>

  ##$_

    #default arg to functions

    $_ = 'Hello';
    print;

  ##$.
  
    #line numeber of last handle read

  ##input record reparator

    #char at which perl stops reading from handle

    $/ = ':';
    print $/;

  ##output record reparator

    #what goes after print

    $\ = "a"; #output record separator for print

    print ''
      #a

  ##$,

    #output field separator for print when printing lists

    $, = ", ";
    print 1..3
      #1, 2, 3

  ##$#
  
    #output format for numbers in print

  ##$$

    #cur process number

    print $$;

  ##status of last process close

    #name of file of script being executed

    print $0;
  
  ##regex

    #$1..$9 #nth capturing group of last regex match
    #$& #entire last regex match
    #$`
    #$'
    #$+

  ##command line arguments

    print $ARGV[0];

##process call

  ##system

    #on background

    #cannot get stdout nor return status

    system("echo", "-n", "a", "b");

  ##qx

    #program waits for end

    #can get stdout and return status

    my $a = qx(echo -n a b);
    my $a = `echo -n a b`;

  ##$?
  
    #status of last process close

    `echo a | grep b`;
    print $?, "\n";

    `echo a | grep a`;
    print $?, "\n";

##diamond

  open(FH,"<file");
  @ARRAY = <FH>;

  ##read from stdin

    #while($l = <STDIN>)
    #{
      #chomp $l;
    #}

    #while($l = <>)
    #{
      #chomp;
    #}

##functions

  #called **subrpocess**

  sub miles_to_kilometers
  {
    my ($miles) = @_;
    return $miles * 1.609344;
  }

  print miles_to_kilometers(5);

  sub modify
  {
    my($text, $code) = @_;
  }

##file io

  #<http://www.troubleshooters.com/codecorn/littperl/perlfile.htm>

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
