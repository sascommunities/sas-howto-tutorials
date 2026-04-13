
/* Checking your encoding */
proc options option=encoding;
run;

/* Creating the sample data */
data example_data;
    length words $40;
    input words $;
    datalines;
BAŚĘBAŁŁ
BASEBALL
BĄŚĘBALL
;
run;

/* Length Functions (Length vs. KLength) */
data check_length;
   set example_data;
   word_l = length(words);
   word_kl = klength(words);
run;
proc print;
run;

/* Substring Functions (Substr vs. KSubstr) */
data check_substr;
   set example_data;
   word_s = substr(words,1,4);
   word_ks = ksubstr(words,1,4);
run;
proc print;
run;

/* Count Functions (Count vs. KCountX vs. KCountW vs. KCountC) */
data check_count;
    set example_data;
    word_count = count(words,'BALL');
    word_kcountx = kcountx(words, 'BALL');
    word_kcountw = kcountw(words);
    word_kcountc = kcountc(words,'A');
run;
proc print;
run;

