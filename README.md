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
   
3. **Prolog’s Built-In Control Structures**

   We leverage on logical and non-logical control structures to achieve different goals:

   - **Logical Control Structures**
     
     In the following example, we will illustrate how we use a combination of control structures in concert to achieve an objective, i.e. asserting a fact into the knowledge base if it does not already exist.
     https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/b83b5537daff5db05c438cf0cfef9a599cf55b50/prolog/gift_recommender.pl#L36-L45
     - If Structure
       https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/b83b5537daff5db05c438cf0cfef9a599cf55b50/prolog/gift_recommender.pl#L39-L45
       We proceed to assertion only after receiving the user permission, realized as `YN = yes ->` being the matching arm.
     - Negation
       https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/b83b5537daff5db05c438cf0cfef9a599cf55b50/prolog/gift_recommender.pl#L42
       We require `call(C)` to fail (i.e. `Category(Item)` is false) to proceed to the next step, so we use the prefix operator `\+` to negate the evaluation of `call(C)`.
     - Exception handling
       https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/b83b5537daff5db05c438cf0cfef9a599cf55b50/prolog/gift_recommender.pl#L42
       Because of the inherent dynamism, calling (`call(C)`) will trigger the exception "Unknown procedure" if `Category/1` is non-existent and non-dynamic. Instead of letting the whole program fail, we wrap `\+ call(C)` with `catch/3` setting `dynamic(Category/1)` as the "Recover", that means if invoking `call(C)` throws an exception (because `Category/1` does not exist and is non-dynamic), `dynamic(Category/1)` will be called to recover from the exception rather than unwinding the call stack.
       
   - **Non-logical Control Structures**
     
       `halt/1` is non-logical control structure that will unconditionally terminate the program together with the `swipl` process.
       https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/b83b5537daff5db05c438cf0cfef9a599cf55b50/prolog/menu.pl#L4-L7
       We employ this structure to implement the quit option in the main menu.
     
4. **Dynamic Knowledge Base Expansion**

   To enable user-defined category items and gifts, the knowledge base of our program has to be dynamically extensible:

   - We use the declaration-site construct `:- dynamic ...`
     https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/b83b5537daff5db05c438cf0cfef9a599cf55b50/prolog/facts.pl#L2
     and the call-site predicate `dynamic/1`
     https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/b83b5537daff5db05c438cf0cfef9a599cf55b50/prolog/gift_recommender.pl#L42
     https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/b83b5537daff5db05c438cf0cfef9a599cf55b50/prolog/new_gifts.pl#L93
     to enable runtime dynamism.
   
   - Then we use `assertz\1` to assert new facts into the knowledge base.
     https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/b83b5537daff5db05c438cf0cfef9a599cf55b50/prolog/gift_recommender.pl#L41-L43
     https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/b83b5537daff5db05c438cf0cfef9a599cf55b50/prolog/new_gifts.pl#L80-L82

   - **An Intriguing Caveat**
   
     We have discovered is that Prolog treats imported predicates differently from locally declared predicates when it comes to `dynamic/1`. We originally planned to use `dynamic/1` exclusively until we were hit with mysterious bugs where new assertions would completely override the imported predicates.
     For example, if we called `assertz(occasion(easter))` into the knowledge base,
     https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/b83b5537daff5db05c438cf0cfef9a599cf55b50/prolog/facts.pl#L5-L8
     The effective knowledge base would become
     ```prolog
     occasion(easter).
     ```
     instead of
     ```prolog
     occasion(birthday).
     occasion(anniversary).
     occasion(new_year).
     occasion(christmas).
     occasion(easter).
     ```
     Apparently Prolog will always override imported predicates of the same signature (e.g. `occasion/1`)when asserting new facts (e.g. `occasion(easter)`), **unless** the signature is declared **dynamic** in the declaration site. This results in our decision to declare dynamic for all `gift/N` predicates in `facts.pl` despite some of them not even having definitions yet.
  
     An alternative can be discarding the use of modules by lumping all source files into one mega file such that there would be only one knowledge base in the program. We opted out of this route because we do not want to compromise on clean code.
   
