Sreenshots here


## A guide to new learning
1. **Complex Querying with Recursive Rules**
   
   When there is no exact match for a given category list, we recursively generate the more general sublists in descending order by length to enable fuzzy matching.
   https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/b83b5537daff5db05c438cf0cfef9a599cf55b50/prolog/utilities.pl#L50-L65
   For example, given facts as below,
   ```prolog
   gift(senior, luxury, "spa resort").
   gift(senior, "warm greetings").
   ```
   There will be no match for `gift(christmas, senior, luxury, Gift)`, thus we will invoke `all_strict_sublists` to unify all strict sublists of `[christmas, senior, luxury]` into `SubLists`.
   ```prolog
   ?- all_strict_sublists([christmas, senior, luxury], SubLists).
   SubLists = [[senior, luxury], [christmas, senior], [christmas, luxury], [senior], [luxury], [christmas], []] ;
   false.
   ```
   Each sublist in `SubLists` will then be checked against `gift/N` to search for a more general gift, in this case `gift(senior, luxury, "spa resort")` will be the first match.
   
   In practice, we generate strict sublists (`AllTuples`) from a list of category-answer tuples (`Tuple`). 
   https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/b83b5537daff5db05c438cf0cfef9a599cf55b50/prolog/general_gifts.pl#L4-L8
   We then make use of the built-in functions (`=..` and `call/2`) to achieve predicate calls with dynamic arity.
   https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/b83b5537daff5db05c438cf0cfef9a599cf55b50/prolog/general_gifts.pl#L12-L16
   https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/b83b5537daff5db05c438cf0cfef9a599cf55b50/prolog/utilities.pl#L31-L34
2. **Prolog’s Built-In Control Structures**

   
