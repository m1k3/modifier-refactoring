# Assignment

During support we sometimes write some quickfix solutions, which we
think will not be needed apart from that one time task. Thus the code
usually has no tests, is not documented and just everything in one large
file. Attached you find an example for such an assumed one time task -
modifier.rb.

I'd like you to do the following:

* give me a short explanation of what the code actually does.
* refactor the code and ensure that the refactored code does the same as
  before.
* create a git repository containing the initial files and do regular
  and small commits to log your process.
* send me your git bundle containing your changes.

# Solution process

1. I fixed some really glaring stuff like the lack of a Gemfile and
   the lack of a ruby-version file to know what version of ruby I'm
   supposed to use.

2. I retabbed and fixed whitespace issues with the files. Not
   modifying the contents at all.

3. I ran the single test that tests the lib/combiner.rb file. It passed
   so that's a good start. Let's try to refactor the combiner.rb class.

4. People should be banished from programming when writing with this
   level of difficult to decipher code. I am not touching this code with
   a ten-foot stick unless I have at least a vague idea of what's going on.
   I am forced to use pry to see what's going on.

5. OK combiner examined. The idea there is that they try to fill an
   array from the .next element from all the enums that are passed in.
   They then fetch minimum elements from that array based on the key
   method. They terminate if they run out of elements or enums.

6. Finally a first commit where I was able to extract a few methods to
   break apart the monstrous combine method in to smaller pieces.

7. The combiner is starting to come together. I identified the reason
   why the code was so convoluted, requiring an intermediate array and
   tons of operations on that array - the standard ruby Enumerator
   throws an exception so we need to store the last value in the
   intermediate array. I replaced it with a NilEnumerator and I can
   simplify the code greatly.

8. The Combiner refactoring is done. It's by no means perfect, but at
   least its readable enough to not get lost for half an hour while
   trying to comprehend what its doing.

9. Moving on to the modifier.rb. We need to get it tested somehow to be
   able to move around parts and make it into an actual shell script.
   Again I am not touching this code with a ten-foot stick unless I have
   at least a vague idea of what's going on.

10. The modifier.rb transforms an input CSV file with a few rules into a
    new CSV file. It first sorts the values based on 'Click' column and
    then goes over each row and transforms the values. The code is very
    convoluted due to the fact that at some point there was a requirement to
    have multiple files with data and merge them into a single file.  The
    rows were merged based on the KEYWORD_UNIQUE_ID column. The code has to
    handle multiple values for a row comming from multiple files and
    reconsile them (combine_hashes). This is why the Combiner colaborator
    was introduced. There is a possible bug if we were to switch to multiple
    input files, because the code currently sorts by 'Clicks' and the
    Combiner assumes that the values are sorted by the merge identtifier
    KEYWORK_UNIQUE_ID which may cause unexpected behavior. We don't have
    multiple input files so we shouldn't run into this bug.

11. I've setup a crude testing harness that just verifies that the
    Modifier reads the input file and produces the sorted intermediary
    and the final output product. I can now start to tease out
    functionality.

12. Refactored the write_output method to stop using StopIteration for
    flow controll.

13. Teasing out the sorter class where the sorter code can live.

14. Teasing out the merger class where the merge code can live. It could
    be also split, because there are the transformation methods, but
    this seems to be enough.

15. Ran out of time so I am doing one more refactoring on Merger#combine_hashes
    and calling it.
