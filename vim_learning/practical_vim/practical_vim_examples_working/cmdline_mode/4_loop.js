/***
 * here we move cursor to tally, search for the next with *, cw counter, :%s//<c-r><c-w>/g to insert counter in other places
 * we don't have to enter a search pattern because the subistitute command remembers it from *
:6,9s//<C-r><C-w>/g
<C-r><C-a> inserts WORD at command line
overall I find this inefficient except for complicated words
***/
var tally;
for (counter=1; tally <= 10; tally++) {
  // do something with tally
};
