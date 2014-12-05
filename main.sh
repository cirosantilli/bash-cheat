#!/usr/bin/env bash

set -eu

# Main bash language cheatsheet.

# The goal is to make this fully executable and automatic self checking,
# but currently it should not be run as it may do bad things:
# copy and paste individual commands of interest on a shell instead.

## Comments

    echo #

  # Escape comment:

    echo \#

  # If a number sign appears in the middle of a string, no need to escape it:

    echo a#b

  # But you should anyways because it is insane. If there is a space, it becomes a comment again:

    echo a #b

## Help

  # Prints help on a built-in commands. The information shown is the same as in the highly recommended:

    #man bash

  # Bash extension.

  # Bash built-in

  # View all built-in commands:

    help

  # Get help on an specific command:

    help help
    help for

## Spaces

  # More than one tabs or spaces are useless like in C.

  # Indentation is not required. Google recommends 2 spaces: Google says 2 spaces: http://google-styleguide.googlecode.com/svn/trunk/shell.xml?showone=Indentation#Indentation
  # Other styles: <http://unix.stackexchange.com/questions/39210/whats-the-standard-for-indentation-in-shell-scripts>

  # `;` can be used to separate commands much like in c:

    echo a; echo b

  # Unlike C, newlines at the end od a command imply `;`:

    echo a
    echo b

  # So you can't use newlines at will as you can in C

    function init_test {
      wd="`pwd`"
      tmp="`mktemp -d`"
      cd $tmp
    }

    function cleanup_test {
      cd "$wd"
      rm -r "$tmp"
    }

# Execute file oustide PATH:

  echo "echo a" > a
  chmod 777 a
  ./a
  #a
  `realpath a`
  #a

## source

## dot

## .

  # Same as copy pasting commands from another file in the current shell.

  # Different from executing the file in a subshell!

  # Some people recommend using extension `.bashrc` for files that are primarily meant to be sourced.

    a=b
    echo 'a=c' > a.bashrc
    . a.bashrc
    [ "$a" = "c" ] || exit 1

  # Bash also supports a `source` operator:

    source a.bashrc

  # However don't use it as it is not POSIX 7.

## Variable substitution

## Parameter expansion

## ${}

  # Replace a variable by its value.

    a='printf b'
    [ $($a) = b ] || exit 1

  # Inside double quotes, variable substitution can happen.

    a=b
    b="$a"
    [ $b = b ] || exit 1

    a=b
    b="${a}c"
    [ $b = bc ] || exit 1

  # Cannot happens inside single quoted strings.

  # Escape:

    a=b
    [ "\$a" = '$a' ] || exit 1

  # Single dollars become literal dolars:

    [ "$" = "\$" ] || exit 1
    [ "$ " = "\$ " ] || exit 1

  # But I woud not rely on such obscure behaviour.

  ## Environment variables

    # It is not possible to set an environment variable for a single command:

      A=a
      [ "$(env A=b echo "$A")" = "a" ] || exit 1
      [ "$A" = "a" ] || exit 1

  ## Expansion

    # Variables are not called variables, but parameter expansion for a reason:
    # they expand at an early stage, and whatever they expand to is evaluated afterwards.

    # This means for instance that you can use variables to store command names and execute them later:

      a="printf"
      [ "$("$a" b)" = "b" ] || exit 1

    # Word splitting however happens before, so the following fails:

      a="printf b"
      [ "$("$a")" = "b" ] || exit 1

    # With:

      #printf b: command not found

    # Because bash is treating "printf b" as a single command.

  ## Parameters are not expand recursivelly

      b=c
      a='$b'
      [ "$a" = '$b' ] || exit 1
      a="$b"
      [ "$a" = c ] || exit 1

  ## Modifiers in parameter expansion

    # String length:

      s='abcd'
      [ ${#s} -eq 4 ] || exit 1

    # Substrings:

      s='abcd'
      [ ${s:0:1} = 'a'  ] || exit 1
      [ ${s:1:1} = 'b'  ] || exit 1
      [ ${s:0:2} = 'ab' ] || exit 1
      [ ${s:2}   = 'cd' ] || exit 1

    # You can do certain glob operations on strings:

      s='12223'

    # Remove shortest matching preffix:

      [ ${s#1*2} = '223' ] || exit 1

    # Uses pattern matching notation to replace.

    # Mnemonic:

    # - `#` (under 3) comes before `%` (under 5) (left of qwerty) so it is the prefix, and not suffix
    # - `##` has more characters than `#`, so it is the longest match possible

    # Remove longest matching preffix

      [ ${s## 1*2} = '3' ] || exit 1

    # Mnemonic: two `## ` is for long, one `#` is for short

    # Remove shortest matching suffix:

      [ ${s%2*3} = '122' ] || exit 1

    # Remove longest matching suffix:

      [ ${s%%2*3} = '1' ] || exit 1

    # Alternate values: <http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_02>

    # Check if variable is unset (not null):

      var=''
      [ -z "${var+a}" ] && exit 1
      unset var
      [ -z "${var+a}" ] || exit 1

    # Check if variable is unset or null:

      var='a'
      [ -z "${var:+a}" ] && exit 1
      var=''
      [ -z "${var:+a}" ] || exit 1
      unset var
      [ -z "${var:+a}" ] || exit 1

    # Important distinction when running with `-u`, where `[ -z "$VAR" ]` would give an error.
    # This often bytes when running scripts that use `PS1` to check if running interactively with `[ -z "$PS1" ]`,
    # when you want to source them from a non interactive script like a Vagrant provision script.

    ## Applications

      # Get file extension or path without the extension:

        s='a/b.ext'
        [ ${s%.*}  = 'a/b' ] || exit 1
        [ ${s##*.} = 'ext' ] || exit 1

  ## unset

      a=''
      unset a
      [ -z "${a+a}" ] || exit 1

  ## readonly

    # POSIX 7:
    # <http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_23>

      readon=b
      readonly readon
      #readon=c
      #error: readon is readonly

    # TODO how to undo readonly?

  ## Null character

    # It seems that variables cannot contain nul characters in POSIX: http://stackoverflow.com/questions/6570531/assign-string-containing-null-character-0-to-a-variable-in-bash

      printf 'a\0b' | od -tx1
      A="$(printf "a\0b")"
      printf "$A" | od -tx1

    # Outputs:

      #0000000 61 00 62
      #0000003

      #0000000 61 62
      #0000002

    # Bash has the `$""` extension that works for literals.

  ## Special variables

    # Some variables:

    # - are automatically set by bash to special values in addition to those inherited from parent
    # - control the behaviour of bash such as GLOBIGNORE

    # Some are readonly, others read write.

    # Commented list : <http://wikibash-hackers.org/syntax/shellvars>
    # also see man bash / shell variables.

    ## Paths related to current script

      # <http://unix.stackexchange.com/questions/4650/determining-path-to-sourced-shell-script>

      # See the relpath.sh scripts in current directory for some tests.

      ## $0

        # Relative path to the current executed script:

          printf '#!/bin/bash\necho "$0"\n' > a
          chmod +x a
          ./a

        # When on a login shell, it is set to `-bash`.

      ## BASH_SOURCE

        # Vs `$0`: `BASH_SOURCE` is also modified when a script is sourced,
        # so it can also find the path of the sourced script.

        # Get the full path of currently executing script:

          DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

        # Force a script to run from current directory no matter where it was called from:

          #cd "$(dirname "${BASH_SOURCE[0]}")"

      ## $_

        # Last word of last command.

          :
          [ "$_" = ':' ] || exit 1
          echo a b >/dev/null
          [ "$_" = 'b' ] || exit 1
          true
          [ "$_" = 'true' ] || exit 1

        # Before any other command, it is the first argument of invocation.

        # Vs `$0`: `$_` follows the exact way the script was invoqued:
        # it will give different results if you do `bash script.sh` and `./script.sh`:
        # `/bin/bash` and `./scrit.sh` respectively.
        # `$0` always gives `./script.sh` for both.

    ## $1

      printf '#!/bin/bash\necho "$1"\necho "$2"\n' > a
      ./a a b
      #a
      #b

    ## $#

      #number of cli args

        echo '#!/bin/bash
echo "$#"' > a
        ./a a b
        #2
        ./a a b c d
        #4

      #usage

        #safe opt arg getting with shift

          if [ $# -gt 0 ]; then
            arg1="$1"
            #argument 1
            shift
            #destroy arg 1
          fi

          if [ $# -gt 0 ]; then
            arg2="$1"
            #argument 2
            shift
            #destroy arg 2
          fi

    ## $@ ## $*

      # Both list of all arguments separated by SPACES, but `$@` is magic and quote arguments individually.

      # For that reason, "$@" is generally more useful.

      # TODO examples

    #$?

      # Exit status of last program run:

        if false; then :; fi
        echo $?
        #0
        if true; then :; fi
        echo $?
        #1

    ## $$

      #PID of current process

        echo $$

    ## PPID

      # ID of parent process. Linux processes contain this info.

        echo $PPID

    ## LINENO

      # Cur line number:

        echo $LINENO

    ## $!

      # PID of last process put in the background.

      # Similar to `%1`, which is accepted by certain commands.

      # Not affected by foreground jobs.

        sleep 10 &
        PID="$!"
        echo a
        [ "$!" = "$PID" ] || exit 1
        sleep 10 &
        [ ! "$!" = "$PID" ] || exit 1

    # Home dir. /home/ciro/ for me:

      echo $HOME

    # Cur username:

      echo $USER

    ## LOGNAME

      # TODO vs USER: http://unix.stackexchange.com/questions/76354/who-sets-user-and-username-environment-variables

        echo $LOGNAME

    # cur hostname:

      echo $HOSTNAME

    # i686:

      echo $HOSTTYPE

      #x86_64

    # xterm on terminals run from x

      echo $TERM

    # Not sure what it means

      #linux on ctrl+alt+f1 terminal

    #cur working dir. `pwd`

      echo $PWD

    # Last working dir. `pwd`

      echo $OLDPWD

    # Is printed on every terminal line:

      echo $PS1

    # May be very large due to coloring ansi coloring sequences.

    # Second line terminal. default '>' !

      echo $PS2

    # List of current on bash options

      echo $BASHOPTS

    # Readonly, modified indirectly by `shopts`
    # on subshell startup, options in this list are set
    # `man bash` `/shopts` for full list

    # Similar to `BASHOPTS but set with `set` command instead:

      echo $SHELLOPTS

    # 4.2.37(1)-release:

      echo $BASH_VERSION

    # Random number between 0 and 32767:

      echo $RANDOM
      echo $RANDOM

    # Seconds since shell started:

      echo $SECONDS
      echo $SECONDS

    # en_US.UTF-8:

      echo $LANG

    # Terminal width/height:

      echo $COLUMNS
      echo $LINES

    ## SHLVL

      # Depth level of current shell:

        [ "$SHLVL" = 1 ] || exit 1
        bash
        [ "$SHLVL" = 2 ] || exit 1
        exit
        [ "$SHLVL" = 1 ] || exit 1

      # Does not increase on subshells:

        ( [ "$SHLVL" = 1 ] ) || exit 1

      # `BASH_SUBSHELL` does that.

      ## BASH_SUBSHELL

        # `SHLVL` for subshells:

          [ "$BASH_SUBSHELL" = 0 ] || exit 1
          ( [ "$BASH_SUBSHELL" = 1 ] ) || exit 1

    ## IFS

      # Determines at which arguments are to be separated *after expansion and read*.

        (IFS='0'; [ "$(printf '%s%s' 'a0b')" = 'a0b' ]) || exit 1
        (IFS='0'; [ "$(printf '%s%s' $(echo 'a0b'))" = 'ab' ]) || exit 1

      # Important applications:
      #
      # -   transform newline separated list into arguments:x
      #     <http://unix.stackexchange.com/questions/39473/command-substitution-splitting-on-newline-but-not-space>
      #
      # -   loop over the lines of a file:
      #     <http://unix.stackexchange.com/a/7012/32558>

  ## Valid variable names ## identifiers

    # Inconclusive to me: http://stackoverflow.com/questions/2821043/allowed-characters-in-linux-environment-variable-names

    # Seems that at least colon can be used `:`, which is abused on the famous `:(){ :|: & };:` fork bomb obfuscation.
    # http://www.cyberciti.biz/faq/understanding-bash-fork-bomb/

## Parenthesis

## ()

## Command groups

  # Formal name: command group.

  # Spawn subshell and exec command in it.

  # Change current dir, prints previous dir:

    cd; pwd

  # Does not change current dir and prints home dir:

    ( cd; pwd )

  # Equivalent to

    bash -c 'cd; pwd'

  # EXCEPT you don't have to do escaping or quoting!

## Subshell

  # Good source: <http://www.linuxtopia.org/online_books/advanced_bash_scripting_guide/subshells.html>

  ## Create subshells

    # Operations that create subshells:

    # Command groups:

        ( echo a )

    # Commands inside braces do not generate subshells.

    # Both sides of pipes run on subshells:
    # there is not alternative since a pipe must be created between two processes.

      a=0
      echo a | a=1
      [ $a = 0 ] || exit 1

      a=0
      a=1 | echo
      [ $a = 0 ] || exit 1

    # For and while do *not* create a subshell:

      a=0
      for i in 0 1; do
        a=$i
      done
      [ $a = 1 ] || exit 1

      a=0
      while read l; do
        a=$l
      done < <( printf "0\n1\n" )
      [ $a = 1 ] || exit 1

  ## Properties of subshells

    # Unexported variables carry over:

      a=0
      [ "$( ( echo "$a" ) )" = 0 ] || exit 1

    # Assignments do not affect parent:

      a=0
      ( a=1 )
      [ "$a" = 0 ] || exit 1

    # Directory changes do not affect parent:

      cd
      ( cd .. )
      [ "$(pwd)" = "$HOME" ] || exit 1

    # Subshell output can be piped:

      [ "$( ( printf a; printf b ) | cat )" = 'ab' ] || exit 1

    # Subshell input for the first command can come from a pipe:

      [ "$( echo a | ( cat; cat ) )" = 'a' ] || exit 1

    # PID may TODO must? be the same as parent?
    # But subshells are forks, no?

      [ "$(echo $$)" = "$( ( echo $$ ) )" ] || exit 1

  ## Nested shells

    # A subshell is different from a shell launched inside a shell.

    ## export

      # POSIX 7:
      # <http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_22>

      # Subshells inherit variables from parent even it they were not exported:

        a=0
        [ "$( ( echo "$a" ) )" = 0 ] || exit 1

      # But a shell inside a shell does not unless they are exported:

        a=0
        bash -c '[ -z "$a" ]' || exit 1

        export a=0
        bash -c '[ ! -z "$a" ]' || exit 1

      # It does not seem possible to undo an export: only to unset the variable.

      # Functions can only be exported as a bash extension.

        function f { echo a; }
        export -f f
        [ "$(bash -c 'f')" = "a" ] || exit 1

      # Seems not possible in POSIX: http://stackoverflow.com/questions/1885871/exporting-a-function-in-shell

      # With the `-p` argument, gives a list of exported variables,
      # but bash seems to not follow POSIX and use the same format as it uses for `export` (no arguments),
      # which is unspecified. So use use the `export` extension if you really need to
      # while we wait for bash to comply.

      # Sample output:

        #declare -x rvm_user_flag
        #declare -x rvm_version="1.25.31 (stable)"
        #declare -x rvm_wrapper_name

      # `declare` is a bash extension command that sets properties of variables,
      # amongst them exportedness.

    ## declare

      # bash extension to set properties of variables.

      # Unexport:

        export a=0
        declare +x a
        bash -c '[ -z "$a" ]' || exit 1

## Braces

## {}

## Inline group

  # Formal name: inline group.

  # Excutes in current context.

    a=0
    b=1
    { printf $a; printf $b; } | cat

  # Prints `01`.

  # Does not spawn a subshell.

## Command substitution

  # <http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html>

  ## ``

  ## Backtick

    # Same as <#eval expression>

      [ `echo a` = a ] || exit 1

    # External double quote not assumed.

      [ ! `echo "a b"` = "a b" ] || exit 1
      [ "`echo "a b"`" = "a b" ] || exit 1

    # Inner double or single quotes are fine:

      [ "`echo "a b"`" = "a b" ] || exit 1
      [ "`echo 'a b'`" = "a b" ] || exit 1

    # Inner backquotes don't work:

      #`echo `echo a``

    # This is why `$()` is better: you can nest it because it has an open/close pair:

      #$( echo $( echo a ))

    # Therfore consider always using `$()`.

  ## $()

    # Similar to backquote:

      [ "$(echo abc)" = "abc" ] || exit 1
      [ "`echo abc`" = "abc" ] || exit 1

    # Better than backquote because it can be nested:

      [ "$(echo $(echo a))" = "a" ] || exit 1

    # Always use `$()` instead of backquotes.

  ## Trailing newlines

    # Trailing newlines **are removed** after command substition.

      [ "$(printf "a\n\n")" = "a" ] || exit 1

    # Methods to overcome it.

    ## Add dummy char and remove it later:

      # Best POSIX option.

        S="$(printf "a\n\n"; printf "a")"
        [ "$(printf "${S%a}" | wc -c)" = "3" ] || exit 1

    # When reading from a file, Bash extension mapfile:

      TMP_FILE="$(mktemp)"
      printf "a\n\n" > "$TMP_FILE"
      mapfile <"$TMP_FILE" S
      # TODO why fails?:
      #[ "$(printf "${S}" | wc -c)" = "3" ] || exit 1
      rm "$TMP_FILE"

## Process substitution

## <()

  # bash extension.

  # Expands a line of the type `<(echo a)` to either a FIFO or a `/dev/fd`,
  # open file descriptor that contains whatever was echoed.

  # Typical application: pass variables as file contents to utilities
  # that expect files.

    echo 'Process substitution:'
    A='file content'
    echo <(echo "$A")
      # Possible output:
      #/dev/fd/63
    [ "$(cat < <(echo "$A"))" = "$A" ] || exit 1

## Expansion

  # Lots of basic bash functionality is done through expansion:
  # e.g., variables are direclty replaced by their values before the command is evaluated.

  # This allows you to to weird stuff with variables in bash which you couldn't do in other languages,
  # and greatly increases the insanity of Bash.

  ## Pathname expansion

  ## Globbing

    # Formal name: #<pathname expansion>

    # Bash expands certain sequences to filenames before issuing commands.

    # Nonhidden files cur dir (if there is at least one non-hidden file):

      echo *

    # Expansion only happens if there is at least one match.
    # If not, the original sequence is used.

      mkdir empty
      cd empty
      [ `printf *` = '*' ] || exit 1

    # Hidden in files cur dir. Includes the annoying `.` and `..`:

      echo .*

    ## List all files in cur dir except `.` and `..`

      # - <http://stackoverflow.com/questions/2910049/how-to-use-the-wildcard-in-bash-but-exclude-the-parent-directory>
      # - <http://unix.stackexchange.com/questions/1168/how-to-glob-every-hidden-file-except-current-and-parent-directory>

      # The problem is that `.*` includes `.` and `..`, and `..?*` becomes literal if no files match it.

      # I am yet to find a satisfactory POSIX commpliant way to do this.

      ## GLOBIGNORE

        # The best bash extension way without subshell is:

          GLOBIGNORE_OLD="$GLOBIGNORE"
          GLOBIGNORE=".:.."
          echo .*
          GLOBIGNORE="$GLOBIGNORE_OLD"

        # The following *does not work* TODO why:

          env GLOBIGNORE=".:.." echo *

        # With subshell:

          (GLOBIGNORE=".:.."; echo .*)

        # The following *does not work* TODO why:

          env GLOBIGNORE=".:.." bash -c 'echo .*'

      ## dotglob

        # Works for this case, but only if we also want the non hidden files.

        # Harder to properly restore state than `GLOBIGNORE`:

          OPT="nullglob"
          shopt -u | grep -q "$OPT" && changed=true && shopt -s "$OPT"
          echo *
          [ $changed ] && shopt -u "$OPT"; unset changed

      ## nullglob

        # Harder to properly restore state than `GLOBIGNORE` and longer than dotglob, so not useful:

          OPT="nullglob"
          shopt -u | grep -q "$OPT" && changed=true && shopt -s "$OPT"
          echo * .[^.]* ..?*
          [ $changed ] && shopt -u "$OPT"; unset changed

        # nullglob is required because ..?* expands to a literal otherwise.

      # - `ls -A` is good to view, but not usable programmatically if filenames have spaces.

    # Escape:

      echo '*'
      echo "*"

    # Start with a:

      echo a*

    # Second letter a:

      echo ?a*

    # * matches "".

    # Start with a or b:

      echo [ab]*

    # Start with 0, 1 or 2.

      echo [0-2]*

    # Works with vars:

      a=b
      "$a"*

    # Shows all the files that start with b

    ## Combos

      # For loop in cur dir:

        for f in .* *; do echo "$f"; done

    ## Extended globbing

      # Glob with ERE-like expressions instead of BREs

      # Activate:

        shopt -s extglob

      # Behavior:

          # glob             ERE mnemonic
          # ?(pattern-list)  (...|...)?
          # *(pattern-list)  (...|...)*
          # +(pattern-list)  (...|...)+
          # @(pattern-list)  (...|...)  [@ not a RE syntax]
          # !(pattern-list)  "!" used as for negative assertions in RE syntax

      # Note that `|` can only be used if the parenthesis are preceeded by a special char.

      # Works:

          # .@(js|coffee)

      # Fails:

          # .@(js|coffee)

      # Parenthesis are mandatory.

      # Examples:

      # All files except two:

        #echo !(a|b)

      # All files inside directory except two:

        #echo d/!(a|b)

      # If you are going to copy things, use `rsync --exclude a --exclude b`.

  ## Tilde expansion

      [ "`sudo -u a echo ~`" = /home/a ] || exit 1
      [ "`echo ~a`" = /home/a ] || exit 1
      [ "`echo ~root`" = /root ] || exit 1
      [ "`echo ~homeless`" = '~homeless' ] || exit 1

    #escape:

      [ "`echo "~a"`" = "~a" ] || exit 1

    #*obvioustly* this does not work from scripts since scripts can be run as any user

  ## Brace expansion

  ## {..}

    # Bash extension.

    # There seems to be no decent POSIX alternative except an explicit for loop:

    # - <http://stackoverflow.com/questions/169511/how-do-i-iterate-over-a-range-of-numbers-defined-by-variables-in-bash>
    # - <http://stackoverflow.com/questions/7300070/bash-script-looping-through-alphabet>

    # The only options are to use `(())` or `bc`, both of which are really clumsy.

    ##  Alternatives

        [ "`for a in 0{ab,cd}1; do echo -n "$a "; done`" = $'0ab1 0cd1 ' ] || exit 1

      # Nested is ok:

        [ "`for a in 0{a,{b,c}}1; do echo -n "$a "; done`" = $'0a1 0b1 0c1 ' ] || exit 1

    ## Number ## range

        [ "`for a in a{1..3}b; do echo -n "$a"; done`" = $'a1b a2b a3b ' ] || exit 1
        [ "`for a in a{-1..-3}b; do echo "$a"; done`" = $'a-1b\na-2b\na-3b' ] || exit 1
        [ "`for a in a{1..5..2}b; do echo "$a"; done`" = $'a1b\na3b\na5b' ] || exit 1
        [ "`for a in a{5..1..2}b; do echo "$a"; done`" = $'a5b\na3b\na1b' ] || exit 1

    ## Letter range

        [ "`for a in 0{a..c}1; do echo "$a"; done`" = $'0a1\n0b1\n0c1' ] || exit 1
        [ "`for a in 0{a..e..2}1; do echo "$a"; done`" = $'0a1\n0c1\n0e1' ] || exit 1

    # Escape:

      echo "{1..3}"

    # Applications:

      for i in {1..5}; do echo $i; done

      mkdir very/long/path/{a,b}

      cp a{,.bak}

    # Help with code injection exploits if you can't have spaces on the command:
    # https://jon.oberheide.org/blog/2008/09/04/bash-brace-expansion-cleverness/

      {echo,INJECTION};{echo,RULZ}

## Array

## List

  # Bash extension.

  # Major application: the list contains a word with spaces.

  # If not, just use a POSIX 7 for loop as in:

    words="ab cd ef"
    for word in $words; do
      echo "$word"
    done

  # Declare all:

    a=()
    a=( a b c "d d" )

  # Cannot nest:

    #a=( (b) (c) )

  # Declare elements:

    a[10]=b
    a[20]=c

  # Cannot nest:

    #a[0]=(1 2)

  # Concat:

    a+=( "e e" )

  # Access:

    a[0]=1
    a[1]=2
    a[2]=3
    [ ${a[0]} = 1 ] || exit 1
    [ ${a[1]} = 2 ] || exit 1
    [ ${a[2]} = 3 ] || exit 1

  # `{}` is obligatory here

  # For loop iteration:

    is=( a b "a b" )
    for i in "${is[@]}"; do echo $i; done
      # a
      # b
      # a b

    for i in "${a[@]}"; do echo $i; done
      # four lines. @ with quotes "" expands similary to "$@"
      # quotes for each element are actually put on the terminal


  # Range:

    echo ${a[@]:1}

    echo ${a[@]:1:2}

## Map

## Associative array

  # Bash extension.

    declare -A aa
    aa=([a]=1 [b]=2)
    [ ${aa[a]} = 1 ] || exit 1
    [ ${aa[b]} = 2 ] || exit 1

## String

  ## Quoting

  ## String literals

    ## Double quotes

    ## ""

      # Space to var:

        a="a b"
        [ "$a" = "a b" ] || exit 1

      # Command substitution is done inside them:

        [ "$(printf a)" = "a" ] || exit 1

      ## Backslash escapes

        # Backslash is not interpreted on literals.

        # `printf` does interpret them.

        # What `echo` does with them is POSIX undefined behaviour.

          [ ! "$(printf "a\nb")" = "a\nb" ] || exit 1

        # Backslash interpretation can also be achieved by using the dollar single quote extension.

      ## Multiline literals

        # Multiline literals include newlines by default:

          [ "$(echo "a || exit 1
b")" = "$(printf "a\nb" )" ]

        # To avoid adding newlines at multiline literals, use a backslash `\`:

          [ "$(echo "a\ || exit 1
b")" = ab ]

      ## HEREDOC

        # Set stdin of command from a string.

        # Interprets variable expansion and command expansion in its interior like `""` quoted strings.

          [ "$(cat <<ANYTHING || exit 1
`printf a`
ANYTHING
)" = a ]

        # A common values for `ANYTHING` is `EOF` which stands for End Of File.

        # This is a great combo to create files with fixed content:

          cat <<EOF >filename
content
EOF

      # Single line heredoc:

        [ "$(cat <<< "a")" = a ] || exit 1

    ## Single quotes

    ## ''

      # Does not do variable expansion nor command expansion.

        a=b
        b='$a'
        [ "$b" = '$a' ] || exit 1

      # Newlines are not ignored on multiline literals.

        echo 'a\
b'

      # Produces $'a\\\nb'

    # Multiple adjacent quoted strings are joined:

      function f { printf "$1"; }
      [ "$(f "a "" b")" = "a  b" ] || exit 1
      [ "$(f 'a '' b')" = "a  b" ] || exit 1

    # When you want to add varaibles to single quoted strings, don't forget to also doble quote the variables:

      S=" b "
      [ "$(f 'a'$S'c')" = "a" ] || exit 1
      [ "$(f 'a'"$S"'c')" = "a b c" ] || exit 1

    ## Dollar double quote ## $"

      # TODO

    ## Dollar single quote ## $''

      # Bash extension.

      # Interprets backslash.

      # Does not do

      # Backquote assumed

        a=$'a\nb'
        [ "$a" = `echo -e "a\nb"` ] || exit 1
        #not "$'a\nb'" = ...

      # Cannot be quoted

        [ "$'a'" = "'\$a'" ] || exit 1

      # Cannot be nested:

        #a=`echo `echo a``

      # Because both characters are equal, there is no opening and closing like parenthesis.

      # See `$(` for a solution.

      # Trailing newlines are all removed!:

        [ a`printf "\n\n"` = a ] || exit 1

  ## Interpret escapes sequences in literals

    # `$'` strings interpret backslash escapes:

      a=b
      printf $'$a\nb'

    # But `$` is not interpreted as a variable.

    # The following interprets `$` but not backslash escapes:

      a=b
      echo $"$a\nb"

    # Solution: use printf:

      a=b
      printf "$a\nb\n"

  # Null charcter shorthand Bash extension;

    [ '' = $'\0' ] || exit 1

  # Many string operations such as length and basic pattern matching notation
  # operations can be achieved via parameter expansion.

  # Equality:

    [ abc = abc ] || exit 1

  # glob does not work:

    [ ! abc = a*c ] || exit 1

  # Check empty:

    [ -z "" ] || exit 1
    [ ! -z "a" ] || exit 1

  ## Double square brackets

    # Glob works:

      [[ abcd == a*d ]] || exit 1
      [[ abc == a?c ]] || exit 1
      [[ abc == a[bB]c ]] || exit 1

    # Cannot quote right:

      [[ abcd != "a*d" ]] || exit 1

  # Repeat a character N times like Python 'a' * 3.
  # <http://stackoverflow.com/questions/3211891/shell-script-create-string-of-repeated-characters>

    N=3
    C="#"
    [ "$(printf "%${N}s" | tr " " "$C")" = "## #" ] || exit 1

  # Repeat a string N times like python 'ab ' * 3:
  # <http://superuser.com/questions/86340/linux-command-to-repeat-a-string-n-times>

    N=3
    S="ab "
    [ "$(printf "%${N}s" | sed "s/ /$S/g")" = "ab ab ab " ] || exit 1

## True

## False

  # False it is a program that does one thing: `exit(1);` !

  # Very useful with bash

    which true

    [ `if true; then echo a; fi` = a ] || exit 1
    [ -z `if false; then echo a; fi` ] || exit 1

    v=true
    [ `if $v; then echo a; fi` = a ] || exit 1

## Square brackets

## []

  # Bash built-in:

  # Does the exact same as the `test` command.

  ## External [ command

    # Is is possible that your system has an *external* `[` command!

      which \[

    # Gives me:

      #/usr/bin/[

    # On Ubuntu 12.04>

## test

  # Compare values and check files, answer on exit status.

  # Bash implements it as a built-in, and Ubuntu also has `/usr/bin/test`:

    which test

  ## No command line options

    # Without any flags or special operators like `=`,
    # `test` simply checks if an argument was given.

      test && exit 1
      test true || exit 1
      test false || exit 1

    # Expressions don't get evaluated at all.

    # When part of the `test` statement, `!` does not force command evaluation:
    # it simply negates what would happen if it were not there!

      [ ! false ] && exit 1
      [ ! true ] && exit 1

    # So you cannot use it to negate variables.

  ## String compare

      test a = a && echo a
        #a
      test a = b && echo a
        #

  ## Integer compare

    # Always use `-eq` family, never `=` family:

      [ 1 -eq 1 ] || exit 1
      [ 1 -eq 01 ] || exit 1
      [ 1 -lt 2 ] || exit 1
      [ 2 -gt 2 ] || exit 1
      [ 1 -le 2 ] || exit 1
      [ 2 -ge 2 ] || exit 1

  ## File operations

    ## f

      # Exists and is regular file (not a symlink or directory)

        init_test
        touch a
        assert test -f a
        cleanup_test

    ## r

      # File or directory exists and has read permission.

      # Useful in conjunction with `-f` before taking input from a file,
      # since just checking its exsitence is not enough to read from it.

    ## e

      #file exists

      #may be a symlink or directory

      #useful to avoid overwriting useful files

    ## s

      #exists and has size > 0

        rm -rf a
        touch a
        assert test -f a

  ## Logical

      test ! a = a        && assert false
      test a = a -a b = b && assert false
      test a = a -a a = b && assert false
      test a = a -o a = b && assert false
      test a = b -o a = b && assert false

## Extended logical test

## Double square brackets

## [[]]

  # Bash extension.

  # Like `[]`, but more powerful.
  # Exact differences: <http://mywiki.wooledge.org/BashFAQ/031>

## Arithmetic

  ## Arithmetic expansion ## Double parenthesis ## $((

    # Does an arithmetic comparison.

      [ $(( 1+1 )) -eq 2 || exit 1
      (( 1 + 2 == 3 )) || exit 1

    # Can only evaluate a single expression.

    # For multiple exressions, consider `bc`.

  ## Arithmetic test

    # Bash extension.

    # Return true iff the arithmetic expression evaluates to non-zero.

      ((2 - 3)) || exit 1
      ((2 - 0)) && exit 1

    # Same as `[ "$(())" = 0 ]`, so no need to ever use this.

  ## let

    # Bash extension.

    # Compute and assign arigthmetic:

        let i=1+1
        let i=i+1
        [ $i -eq 3 ] || exit 1

    # This is the nicest way to do it i think.

    # NO SPACES ALLOWED! all fail:

      #let i =1+1
      #let i= 1+1
      #let i=1 +1

## Boolean

  # && only execute next command if previous command gives status = 1
  # ||                              = 0

  # If they don't execute, status is unchanged.

  # Therefore, for if `&&` has the same effect as and and `||` the same effect as or.

    [ `true && echo a` = a ] || exit 1
    [ -z `false && echo a` ] || exit 1
    [ `false || echo a` = a ] || exit 1
    [ -z `true || echo a` ] || exit 1

    [ `if true && true; then echo a; fi` = a ] || exit 1
    [ -z `if false && true; then echo a; fi` ] || exit 1
    [ -z `if true && false; then echo a; fi` ] || exit 1
    [ -z `if false && false; then echo a; fi` ] || exit 1

    [ `if true || true; then echo a; fi` = a ] || exit 1
    [ `if false || true; then echo a; fi` = a ] || exit 1
    [ `if true || false; then echo a; fi` = a ] || exit 1
    [ -z `if false || false; then echo a; fi` ] || exit 1

  # To store booleans in variables, simply store strings that contain `true` or `false`
  # and then execute those strings with unquoted expansion:

    b=true
    $b || exit 1
    b=false
    $b && exit 1

## Colon

## :

  # In bash and zsh, exactly identical to `true`:

    false
    [ "$?" = 1 ] || exit 1
    :
    [ "$?" = 0 ] || exit 1

  # Both are POSIX specified, and POSIX specifies a minor difference:
  # `:` is a special built-in and `true` a regular built-in.

    ( x=hi :; [ "$x" = "hi" ] || echo fail )
    ( x=hi true; [ -z "$x" ] || echo fail )

  # Great SO answer: <http://stackoverflow.com/a/3224910/895245>

  # Bottomline: always use `true` because it is more readable,
  # and never do anything whose behaviour depends on being a special built-in or not.

  # If seems however that both of them can be defined to something else by an insane programmer:

    (:(){ echo a; }; :)

## case

  # Each case is a "pattern matching notation" pattern
  # or an pattern | pattern (not a feature in general "pattern matching notation").

    a=
    case $a in
      [a-c])
        echo "1"
      ;;
      [d-e]|[1-3])
        echo "2"
      ;;
      # There can be no spaces between `*` and the rest of the string!
      # Use quoting to avoid the spaces.
      "a "*)
        echo "a b"
      ;;
      *)
        echo "3"
      ;;
    esac

  # Single line:

    a=
    case $a in a) echo "1" ;; *) echo "2" ;; esac

## if

  # Checks return status of given commands.

  # Remember that the `true` and `false` commands sever only to set the exist status.

    if true; then
      :
    elif true; then
      exit 1
    else
      exit 1
    fi

    if false; then
      exit 1
    elif true; then
      # Cannot be empty!
      :
    else
      exit 1
    fi

    if false; then
      :
    elif false; then
      exit 1
    else
      :
    fi

  # A very commom pattern is to use `if` with the brackets `[]` version of `test`,
  # whose main function if to set the return status.

    if [ "a" = "b" ]; then
      exit 1
    fi

  # Use status of last command:

    true
    if [ "$?" = "0" ]; then
      :
    else
      exit 1
    fi

    false
    if [ "$?" = "0" ]; then
      exit 1
    else
      :
    fi

  ## not

  ## Negation

  ## !

  ## Exclamation mark

    # `!` can be either:
    #
    # - part of the if statement
    # - part of the `test` command which is the same as bracket notation `[ ]`.
    #
    # Beware of history expansion that it may cause.

    # Part of the `if` statement:

      if ! true; then
        exit 1
      else
        :
      fi

      if ! false; then
        :
      else
        exit 1
      fi

## for

    for f in a b; do echo "$f"; done
      #'a b'
    for f in 'a b'; do echo "$f"; done
      #'a b'

    echo {1..5..2}
      #'1 3 5'
    for i in {1..5..2}; do echo $i; done
      #$'1\n3\n5\n'

## while

  # Break:

    i=0
    while [ $i -lt 10 ]; do
      echo $i
      let i=i+1
      if [ $i -eq 5 ]; then
        break
      fi
    done

  ## Infinite loops

    # It is hard to escape infinite loops in bash via Ctrl-C because commands are executed in subshells.
    # and the subshell gets the SIGTERM instead of the one with the while loop.

    # http://unix.stackexchange.com/questions/42287/terminating-an-infinite-loop

    # Best solution to stop an interactive infinite loop:

      bash -c 'while true; do sleep 60; done' &

    # And then `kill %1`.

    # If you don't use `bash -c`, Ctrl + Z will work.

  ## While from stdin

    # While can take stdin, and forwards it to the command it runs:

      [ "$(echo a | while cat; do break; done)" = "a" ] || exit 1

    # From file:

      echo a > file
      [ "$(while cat; do break; done <file)" = "a" ] || exit 1

    # With proces substitution Bash extension:

      [ "$(while cat; do break; done <(echo a))" = "a" ] || exit 1

    # This leads to the classic POSIX read loop stdin linewise combo:

      printf "a\nb\n" | while read LINE; do
        echo "$LINE"
      done

    # You ofen see the Bash only command substitution version which
    # you should never use because the POSIX one even golfs better:

      while read LINE; do
        echo "$LINE"
      done < <(printf "a\nb\n")

## File descriptors

## Redirection

  # The following descriptors are always open by default:

  # - 0: stdin
  # - 1: stdout
  # - 2: stderr

  # Echo to stderr:

    echo 'to stderr' 1>&2

  # Descriptor 3 to descriptor 4:

    echo a 3>&4

  # Descriptor 3 to file f:

    echo a 3>f

  # If input descrpitor is not given it defaults 1 (stdout). Decriptor 1 to file f:

    echo a >f

  # Redirect both stdout and stderr to file:

    echo a &>f

  # Bash extension, not present in `sh`, so only in scripts only use:

    echo a >f 2>&1

  # Same as above but desincouraged by the manual since it breaks if file name is a number:

    echo a >&f

  # Append stdout to file:

    echo a >>"$f"

    function outerr {
      echo 'out'
      echo 'err' 1>&2
    }

    outerr
    #out
    #err

    outerr &>/dev/null
    #

    outerr >/dev/null
    #err

    outerr 2>/dev/null
    #out

  ## Multiple redirections

    # The order of multiple redirections matters.

    # Think of them as variable assignments made from right to left.

      outerr >/dev/null 2>&1
      #

      outerr 2>&1 >/dev/null
      #err

  ## Stdin redirection

    # Analogous to stdout redirection.

    # Get stdin of previous command from given file.

      printf abc >f
      [ $(cat <f) = abc ] || exit 1

    # Combo combo with Process Substitution to pass a variable to stdin:

      [ $(cat < <(printf abc)) = abc ] || exit 1

  ## | ## pipe

    # `a | b` connects stdout and stderr of `a` to stdin of `b`.

      [ "`outerr | cat`" = $'out\nerr' ] || exit 1

    # Make a pipe take only stderr:

      outerr |& cat
      outerr >/dev/null | cat

  ## Create file descriptors

    # It is possible to create further file descriptors.

    # First, those descriptors must be made point somewhere,
    # or you get a `bad file descriptor error`:

      #echo a 1>&13

    # The usual way to use them is to redirect them to existing files or other
    # descriptors via the exec redirection combo.

    # From now on, redirect `3` to `1`:

      exec 3<&1

    # Echo to 3:

      echo 3 >&3

    # Close 3

      exec 3>&-

    # Before you close the file, a file descriptor will be pointing to it:

      #$ exec 3<> /tmp/foo
      #$ lsof /tmp/foo
      #COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF    NODE NAME
      #bash    22924 ciro    3u   REG    8,8        0 1713824 /tmp/foo
      #$ exec 3>&-
      #$ lsof /tmp/foo

    # Open file `f` and assign fd 3 to it:

      exec 3<>f

    # Read the first line

      read <&3

    # Close `3`:

      exec 3>&-

    # TODO why is exec needed?

  ## Modify in-place gotcha

    #YOU CANNOT MODIFY A FILE INLINE WITH REDIRECTION LIKE THIS:

      echo $'0\n1' > a
      grep 0 a | cat > a

    #this simply erases a

    #reason:

    #workaround: use sponge from moreutils.

## Commands, built-ins, functions, aliases.

  ## Function

    # Mandatory `;` or newline before closing brackets:

      function f { echo $1; }

      function f {
        echo $1
      }

    # Function actions take effect on calling shell:

      x=a
      function setx { x=b; }
      setx
      [ "$x" = "b" ] || exit 1

    # Number of arguments is not fixed.

      function f { echo $1; }
      [ "$(f a)"   = 'a' ] || exit 1
      [ "$(f a b)" = 'a' ] || exit 1

    ## local

      # Bash extension.

      # Specifies that a variable is only visible from the function.

      # Should be used ideally everywhere in bash, but not POSIX,
      # and there is no good POSIX way of doing it:
      # <http://stackoverflow.com/questions/18597697/posix-compliant-way-to-scope-variables-to-a-function-in-a-shell-script>

  ## alias

    # Expand sequence before it is executed.

      alias echo='echo a'
      [ "$(echo)" = a ] || exit 1
      [ "$(echo b)" = 'a b' ] || exit 1

    ## alias vs function vs script

      # Aliases are strictly less versatile than functions TODO check because:

      # - cannot take arguments like `$1`, to use them inside the command or multiple times as in:

          function f { echo "$1"; echo "$1"; }

      # - cannot be exported to subshells like functions via `export -f` (bash extension to POSIX).

      # External scripts have the advantages that:

      # - they can be called by external programs outside bash sessions
      # - they are not loaded in memory, so they don't take memory space

      # The downside of scripts is that since they are not loaded in memory, they may take more time to load.

    ## Find what an alias maps to

      # Use `type`.

    ## Expand alias to the actual command.

      # http://superuser.com/questions/247770/how-to-expand-aliases-inline-in-bash

    ## Run single command without alias:

      # Start with with a backslash:

        alias echo='echo a'
        [ "$(\echo 'b')" = 'b' ] || exit 1
        [ "$( echo    )" = 'a' ] || exit 1
        unalias echo

      # Escaping any character of the command also works: `e\cho`, `e'c'ho`, etc.

    ## unalias

      # Remove alias for good:

        alias echo='echo a'
        unalias echo
        [ "$(echo 'b')" = 'b' ] || exit 1
        [ "$(echo 'b')" = 'b' ] || exit 1

    # Aliases are not exported, and it does not seem to be possible to do so:

      alias a="echo a"
      [ `a` = a ] || exit 1
      bash
      [ `a` = a ] || exit 1
      #not found, unless you have another a!

  ## command

    # Explicitly turn off aliases and functions for a single command:

      unalias cd
      function cd { echo f; }
      [ $(command x) = "f" ] || exit 1

      alias x="echo a"

  ## keyword

    # - hard coded in bash
    # - not commands, but "parts of commands"
    # - examples: if, do, for, while, end*

  ## compgen

    # POSIX 7

    # List all available commands / built-ins / functions / aliases:
    # all "commands" you can issue from your shell.

    # Commands TODO

      # compgen -c

    # Aliases

      # compgen -a

    # Aliases and commands:

      # compgen -ac

    # Built-ins

      # compgen -b

    # Keywords

      # compgen -k

    # Functions

      # compgen -A function

      # compgen -A function -abck #all above at once

  ## hash

    # POSIX 7

    # The first time bash calls an executable, it searches the path for it.

    # It then stores the basename -> path in a hashmap, and only uses the hashmap from then on.

    # If the command changes location, bash does not search for it again, and just gives an error.

      set -h
      mkdir d
      echo "echo 2" > d/echon
      chmod +x d/echon
      PATH="$PATH:`pwd`:`pwd`/d"
      [ `echon` = 2 ] || exit 1
      echo 'echo 1' > echon
      chmod +x echon
      [ `echon` = 2 ] || exit 1
      #surprise!
      rm -r d
      rm echon

      # ./echon is first in path
      # and sould print 1!

      # With `set -h`
      # Bash does not search the path every time.
      # It would take too long.
      # It remembers paths!

    # Show usage count of used commands:

      hash

    # Forget all paths:

      hash -r

    # Forget path for a single command:

      hash -d firefox

  ## type

    # POSIX 7 http://pubs.opengroup.org/onlinepubs/9699919799/utilities/type.html#tag_20_136

    # Determine type of command (shell keyword, shell buit-in, alias, function or executable in path.

      type if
        #if is a shell keyword

      type cd
        #builtin

    # Aliases:

      alias a='b'
      type a
        #a is aliased to `b'

    # This is a good way to find what an alias is mapped to.

      function f { echo f; }
      type f
        #f is a function
        #f ()
        #{
        #    echo f
        #}

      type mkdir
        #mkdir is /bin/mkdir

    # `-t`: machine readable output
    # `-P`: forces to search PATH for command. possible application: detect if program is installed and in path:

      if [ "`type -P vim`" = "" ]; then
        echo 'vim not installed'
      fi

  ## which

    # Prints full path of executable in path.

    # Does not necessarily reflect the actual program that will actually be used
    # since this is not a bash built-in so it does not know:

    # - the state of the bash path cache
    # - does not see built-ins

    # If you give it a command that only exists as a builtin such as `cd`, outputs nothing.

    # Note however that there are commands which exist both as shell built-ins and
    # as separate executales such as `echo`.

    # Examples:

      which ls

    # Sample output:

      /bin/ls

    # The following print nothing:

      which 'im-not-in-path'

      which 'im-not-executable'

      which cd

  ## Check if command is present

      # <http://stackoverflow.com/questions/592620/how-to-check-if-a-program-exists-from-a-bash-script>

      # Don't use `which`.

      # Options:

        command -v 'foo' >'/dev/null' 2>&1 || echo 'foo not present'
        type 'foo' >'/dev/null' 2>&1 || echo 'foo not present'
        hash 'foo' 2>'/dev/null' || echo 'foo not present'

      # Copy paste for your script:

        for cmd in 'latex' 'pandoc'; do
          printf '%-10s' "$cmd"
          if hash "$cmd" 2>'/dev/null'; then printf 'OK\n'; else printf 'missing\n'; fi
        done

## Options

  # Commands that modify shell behavior.

  ## set

    # POSIX 7

    ## invocation

      # All of the set options options can be set from the command line invocation.

      # For example, it is the same to do:

        #bash -e a.sh

      # and to add:

        #set -e

      # To the top of `a.sh`.

      # There are however certain options which can only be used as command line arguments, such as `-c`.

      # A few options are automatically turned on only for interactive shells, e.g. History Expansion.

    # List all vars and functions that are set:

      set

    # List only set options:

      echo $-

    # Sets the -e option:

      set -e

    # Unsets the -e option:

      set +e

      man bash
      #/SHELLOPTS

    # The `-+o` option allows to input long names.

    # Most, but not all, of the long names have short versions.

      echo a
      set -H
      !e
      set +H
      !e
      set -o histexpand
      !e
      set +o histexpand
      !e

    # View the values of all `-o` options:

      set -o

    # TODO: how to save and restore both single letter and `-o` options?

    ## set readline options

      # `set` can also be used to set readline options that determine how lines are read.

      # If lines are longer than screen, put then on a pager that allows you to navigate right / left with arrow keys.

        set horizontal-scroll-mode on

    ## most useful options

      ## e

        # Stop execution if one command returns != 0

          set +e
          false
          set -e
          # The following whould stop the execution of this script:
          #false

        # It is recommended to add it to all scripts.

      ## u

        # Error on undefined variable:

          set -u

        # It is recommended to add it to all scripts together with `-e`:

          set -eu

      ## v

        # Print every string before it is executed.

        # Useful for debugging.

        # For exapmle:

          a=b
          set -v
          echo $a
          set +v

        # Outputs:

          #echo $a  #stderr
          #b        #stdout

        # Source commands show all that is being sourced.

          echo 'a=b' > a.bashrc
          set -v
          . a.bashrc
          set +v

        # Outputs to stderr:

          . a.bashrc
          a=b

      ## x

        # Print every string before it is executed with all expansions done.

        # Useful for debugging.

        # For example:

          a=b
          set -x
          echo $a
          set +x

        # Outputs:

          #+ echo b    #stderr
          #b       #stdout

        # Verbosily breaks down pipes. Example:

          set -x
          echo a | cat
          set +x

        # Outputs:

          #+ cat
          #+ echo a
          #a

        # This does not happen with `-v`.

  ## shopt

    # Controls boolean options that determine how the shell behaves.

    # shopt vs set: <http://unix.stackexchange.com/questions/32409/set-and-shopt-why-two>
    # shopt is not POSIX, so it only contains bash extensions.

    # Show all options:

      shopt

    # Show one option:

      shopt dotglob

    # Set option:

      shopt -s op

    # Unset option:

      shopt -u op

    # Store shopt state for a single command: http://stackoverflow.com/questions/9126060/is-there-an-easy-way-to-set-nullglob-for-one-glob

      OPT='nullglob'
      shopt -u | grep -q "$OPT" && changed=true && shopt -s "$OPT"
      echo ..*
      [ "$changed" ] && shopt -u "$OPT"; unset changed

    ## invocation

      # All shopt options can be set from the command line invocation with `[-+]O <opt>`

      # For example:

        bash -O dotglob a.sh

      # Is the same as adding:

        shopt -s dotglob

      # to `a.sh`, and:

        bash +O dotglob a.sh

      # is the same as adding:

        shopt -u dotglob a.sh

## tab expansion

  # Bash in interactive mode uses tab for command completion.

  # `sh` does not implement this, so this is not required by POSIX.

  # For example, if you type:

    #ec

  # and then hit `<tab>`, you will get a list like:

    #echo   eclipse  econvert

  # If there is only one possible command, it expands automatically.

  # To avoid this and insert a literal tab, do `<c-v><tab>`, in analogy to the other
  # escape characters input.

## exec

  # POSIX 7.

  # Interface similar to an exec system call: ends current shell and runs given command instead

  # Destroys the calling bash!

    [ $SHLVL = 1 ] || exit 1
    exec bash
    [ $SHLVL = 1 ] || exit 1

  ## exec and redirection

    # Redirect all followint stdout to file a:

      #exec >f
      #printf a

  ## application

    # Start a new bash with a custom environment.
    # and discard the old one

      exec env -i a=b c=d bash --norc --noprofile
      env
      exit

## History

  ## fc

    # POSIX 7: http://pubs.opengroup.org/onlinepubs/9699919799/utilities/fc.html

    # TODO mnemonic? Fix Command.

    # Open "echo a" in the editor determined by the FCEDIT environment variable,
    # and when you quit, executes what you wrote:

      echo a
      fc

    # List latest commands:

      fc -l

    # Sample output:

      # 301     command1
      # 302     command2
      # 303     command2
      # ...

    # List without line numbers (but still with heading spaces.

      fc -nl

    # Print the last command with extra heading spaces:

      fc -ln -1

  ## ctrl-r

    # *Very useful*.

    # Good tutorial: <http://ruslanspivak.com/2010/11/20/bash-history-reverse-intelligent-search/>

  ## History expansion ## ! ## exclamation mark #history substitution

    # Expands to the last command that starts with string.

    # Also expands inside double quotes! but not inside single quotes.

    # Controlled by the `H` option. Turned on by default on interactive shells.

      set -H
      echo a
      !e
      # Shell shows:
      # echo a
      # Output:
      # a
      [ "!e" = "echo a" ] || exit 1

    # The substitution happens early and insanely: it even affects what will go into history.

      echo a
      echo !e
      #echo echo a
      echo !e
      #echo echo echo a

    # TODO why the following expands: http://stackoverflow.com/questions/22125658/escape-history-expansion-exclamation-mark-inside-command-substitution

      echo a
      echo "$(echo '!e')"

## clear

  # Clear terminal screen

      clear

## dirs

  # Move between dirs in stack.

  # Builtins, not in `sh`.

  # Show dir stack:

    dirs

  # -v : verbose. one per line, with line numbers:

    dirs -v

  # Push to dir stack

    pushd .

  # Pop from dir stack and cd to it

    popd

  # Very useful in when you need to cd somewherelse and come back later:

    pushd .
      cd d
      pwd
      pushd .
        cd d2
        pwd
      popd
    popd

echo '
ALL ASSERTS PASSED'

## eval

  # POSIX 7.

  # Exec string in current bash

    eval "a=b"
    [ $a = b ] || exit 1

  # Concatenates arguments, space separated:

    [ `eval echo a` = a ] || exit 1

  ## Applications

    # Make varname from var>

      a=b
      eval "$a=c"
      [ $b = c ] || exit 1
