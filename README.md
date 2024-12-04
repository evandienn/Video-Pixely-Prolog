
<img width="1225" alt="Screenshot 2024-12-03 at 21 40 47" src="https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/assets/5562/a2fad5f5-532d-4a68-811f-3c3b26843d95">

<img width="1225" alt="Screenshot 2024-12-03 at 21 41 00" src="https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/assets/5562/25799e71-1089-4a07-87d2-fffae7c54ee0">

<img width="1225" alt="Screenshot 2024-12-03 at 21 41 24" src="https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/assets/5562/0fb46758-aff1-4a9f-84f6-d5a2769a7379">

<img width="1225" alt="Screenshot 2024-12-03 at 21 41 36" src="https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/assets/5562/73dcd73f-bb81-4a77-876b-103622117bd7">

Here is a link to our [proposal](Project_Proposal.md)

This is the link to our [DEMO](https://youtu.be/urUTzmyJlpc)

### How to test and run the code: Prolog

Clone the repository and navigate to the Prolog subdirectory:

```bash
cd prolog
```

Load the gift recommender using swipl:

```bash
swipl gift_recommender.pl
```

Enter `recommend.` in the terminal to trigger the user input prompt:

```prolog
recommend.
```
After inputting any matching occasion and relationship and the other categories, you will receive a gift recommendation.

If no match is found, the system will recommend a more general gift based on your selection.

You can also choose to add your own suggestion of what gifts to recommend to dynamically update our knowledge base by choosing option 2 and specifying the relevant categories


## A Guide to MVP

1. User Input and Output

   - Improvements to Input
     
     We have implemented wrapper read functions around `read_string/5` (`read_str/1` and its derivatives) to ensure all user inputs will always be white-spaces-trimmed and single-lined, replacing the use of `read/1` which expects a Prolog term as its input. That has prevented classes of invalid inputs while improving user experience by eliminating the need of a trailing period in user input.
     https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/utilities.pl#L86-L87

   - Improvements to Output
  
     - General Gifts

       We have made an extra step beyond our proposal when it comes to gift recommendation. Even when there is no exact gift for a given category list, we will attempt to provide more general recommendations by checking the strict sublists of category list against the `gift/N` predicates. For more details, please refer to **Complex Querying with Recursive Rules** below.

     - Pretty Print
  
       Thanks to `print_with_category_items/4` and `print_with_category_items/5`, we can now generate and print a neat sentence from a list of Category-Answer tuples. 
       https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/utilities.pl#L147-L172
       For example,
       ```prolog
       ?- print_with_category_items("The gift", [occasion/1,gender/1,age_group/3], [christmas,male,[infant,0,5]], " is a pacifier").
       The gift when the occasion is Christmas, the gender is male and the age group is infant (0 - 5 years) is a pacifier
       true.
       ```
     
     - Text Styling
       
       Bored with monochromic output? So are we! That's why we have implemented `style_format/3` and `ansi_style/2` to colorize our world in a consistent way. (powered by `ansi_format/3`)
       https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/utilities.pl#L142-L144
       https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/styles.pl#L3-L9
       Simply passing one of the predefined styles (e.g. `information`) as `Style` in `style_format/3`, `unescape/format/3` or `print_with_category_items/5`, the world will be more colorful and stylish.
     
   - Code Flow Example for User Input Prompt

     - We now provide a selection menu with enumerated options instead of requiring users to input their choices in full text, unless they want to provide an option not provided by our MVP.
       https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/gift_recommender.pl#L10-L18
  
     - After printing the selection menu, we use `read_number/2` to read a number from users that specify what option they want to choose and map the number with the corresponding item in the category using `get_item/3`.
       https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/gift_recommender.pl#L23-L28
  
     - If `N = 0` in `get_item/3`, it indicates users want to provide their own option, we read their input as free text with `read_str/1`.
         https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/gift_recommender.pl#L47-L53

    - Code Flow Example for Gift Recommendation
  
      We use `recommend_gift/2` to recommend a gift after getting the answers (i.e. `Answers`) for all categories (i.e. `Categories`) from users. Differing from the PoC, the MVP no longer checks against `gift/3` for recommendations, instead, it constructs the gift predicate on the fly.
      
      - The first case of `recommend_gift/2` attempts to match an existing `gift/N` predicate by dynamically invoking `G` which is constructed from `Answers`. The result will be unified to `Gift` as the recommendation and subsequently printed together with `Categories` and `Answers` in a neat way.
        https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/gift_recommender.pl#L61-L67
      - If the first case fails, the second case will attempt to match for more general recommendations. For more details about how `recommend_general_gifts/2` works, please refer to **Complex Querying with Recursive Rules**.
        https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/gift_recommender.pl#L69-L72

2. Knowledge Base Construction

   We statically define facts and relationships between categories and gifts in `facts.pl` entailing our knowledge base, a foundation our MVP functions upon.
   https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/facts.pl#L4-L79
   
3. Error Handling and User Feedback

   Since most user interactions in our MVP involve a selection menu, users are expected to give a valid number (i.e. a number corresponding to a menu item) as their input. How can we tell a valid number from an invalid input? How can we recover from that?
      
   `read_number_or_blank/2` and its derivative `read_number/2` come to our rescue. (They are derivatives of `read_str/1` in turn)
   
   - The first case of `read_number_or_blank/2` will match the user input with a number a blank string,
     https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/utilities.pl#L89-L94
   - If the predicate higher up in the stack requests a reentry (e.g. `NoOrBlank` is beyond the range of `Items` so `get_items/4` fails),
     https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/new_gifts.pl#L62-L67
     or the first case has failed, the second case will print `Question` and prompt users for another input, **(the printing `Style` is `error` here)**
     https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/utilities.pl#L101-L103
     Since the second case is tail-recursive, `read_number_or_blank/2` will never end until users provide a valid input.
   
4. Foundation for Expansion

   - Incorporating complex relationships

     Evolving from our PoC, the MVP has incorporated new predicates `age_group/3`, `budget/3`, and `gift/N` (where 1 <= N <= 7). Rather than hardcoding the logic for the new relationships with varying arities, we have introduced significant dynamism into our program. As such, our codebase has become highly extensible for incorporating more complex relationships including arbitrarily nested predicates. We believe that only minor modifications to our codebase, primarily related to output formatting, are needed to provide full support for these complex relationships. (**A guide to new learning** has provided various examples for new fact assertion and gift recommendation in a dynamic way)
      
   - Adjusting recommendations based on user preferences

     Based on the foundations laid, we have implemented a new feature "suggest new gift" beyond the scope of my proposal. Users can now suggest new gifts for any category combination they specify through the new user interface. Given the successful implementation of this use case, we can see no foreseeable roadblocks in implementing new features for adjusting recommendations based on user preferences.
     
   - Adding natural language processing (NLP) to allow for a more conversational experience
   

## A guide to new learning
1. **Complex Querying with Recursive Rules**
   
   When there is no exact match for a given category list, we recursively generate the more general sublists in descending order by length to enable fuzzy matching.
   https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/utilities.pl#L50-L65
   For example, given the facts below,
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
   https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/general_gifts.pl#L4-L8
   We then make use of the built-in functions (`=..` and `call/2`) to achieve predicate calls with dynamic arity.
   https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/general_gifts.pl#L12-L16
   https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/utilities.pl#L31-L34
   
2. **Prolog’s Built-In Control Structures**

   We leverage logical and non-logical control structures to achieve different goals:

   - **Logical Control Structures**
     
     In the following example, we will illustrate how we use a combination of control structures in concert to achieve an objective, i.e. asserting a fact into the knowledge base if it does not already exist.
     https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/gift_recommender.pl#L36-L45
     - If Structure
       https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/gift_recommender.pl#L39-L45
       We proceed to assertion only after receiving the user permission, realized as `YN = yes ->` being the matching arm.
     - Negation
       https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/gift_recommender.pl#L42
       We require `call(C)` to fail (i.e. `Category(Item)` is false) to proceed to the next step, so we use the prefix operator `\+` to negate the evaluation of `call(C)`.
     - Exception handling
       https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/gift_recommender.pl#L42
       Because of the inherent dynamism, calling (`call(C)`) will trigger the exception "Unknown procedure" if `Category/1` is non-existent and non-dynamic. Instead of letting the whole program fail, we wrap `\+ call(C)` with `catch/3` setting `dynamic(Category/1)` as the "Recover", that means if invoking `call(C)` throws an exception (because `Category/1` does not exist and is non-dynamic), `dynamic(Category/1)` will be called to recover from the exception rather than unwinding the call stack.
       
   - **Non-logical Control Structures**
     
       `halt/1` is a non-logical control structure that will unconditionally terminate the program together with the `swipl` process.
       https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/menu.pl#L4-L7
       We employ this structure to implement the quit option in the main menu.
     
3. **Dynamic Knowledge Base Expansion**

   To enable user-defined category items and gifts, the knowledge base of our program has to be dynamically extensible:

   - We use the declaration-site construct `:- dynamic ...`
     https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/facts.pl#L2
     and the call-site predicate `dynamic/1`
     https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/gift_recommender.pl#L42
     https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/new_gifts.pl#L93
     to enable runtime dynamism.
   
   - Then we use `assertz\1` to assert new facts into the knowledge base.
     https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/gift_recommender.pl#L41-L43
     https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/new_gifts.pl#L80-L82

   - **An Intriguing Caveat**
   
     We have discovered that Prolog treats imported predicates differently from locally declared predicates when it comes to `dynamic/1`. We originally planned to use `dynamic/1` exclusively until we were hit with mysterious bugs where new assertions would completely override the imported predicates.
     For example, if we called `assertz(occasion(easter))` into the knowledge base,
     https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/facts.pl#L5-L8
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
   
4. **Higher-Order Predicates**

   We have used various kinds of built-in higher-order predicates in Prolog or even compose our own higher-order predicates to achieve different goals

   - Direct Uses
     - `maplist/3`

       When rendering the "suggest new gift" menu, we generate the menu options by prepending `"specify the "` into each of the categories. Here we use `maplist/3`, whose first term (i.e. `specify_category`) is a mapping predicate of arity 2, second term (i.e. `Category`) the original list, and the third term (i.e. `SCs`) the result list.
       https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/new_gifts.pl#L29-L31
       In `specify_category/2`, the first term is an element in the original list, we unify the mapped result to `SC` which will end up in the new list.
       https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/new_gifts.pl#L26-L27
       
     - `predsort/3`
       
       Here, we sort `Unsorted` to `[_|SubLists]` by using `predsort/3`, whose first term (i.e. `compare_by_length_then_intrinsic`) is a comparison predicate of arity 3,
       https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/utilities.pl#L57
       The comparison predicate is then passed through 3 arguments and required to unify the comparison result to `Delta`. Here we sort primarily by the sublist length in descending order. `Delta` should be unified to one of the three atoms, `'='`, `'<'` and `'>'`.
       https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/utilities.pl#L43-L48

   - Compositions
     - `menu/2`
  
       - At the entry point of the program (`recommend/0`), we render the main menu by passing a list of menu option predicates and a list of category predicates to `menu/2`.
       (We pass predicates in the form `pred/N` instead of `pred` to facilitate readability and code discovery. For category predicates, their arity also serves other purposes which will be explained later)
         https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/gift_recommender.pl#L79-L81
         
       - We strip the arities in the option predicates by calling `destructure_preds/2` before proceeding to `menu_internal/2`. (e.g. `[recommend/1, suggest_new_gift/1]` to `[recommend, suggest_new_gift]`)
         https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/menu.pl#L9-L15
         
       - After matching a menu option with the user input, we call `call(Option, Categories)` to launch a menu option. `call/2` is a built-in higher-order predicate that invokes the given term (i.e. `Option`) with an extra argument (i.e. `Categories`).

         Suppose the user has chosen the option "recommend", the `call/2` predicate will effectively become `call(recommend, Categories)`, which is equivalent to calling `recommend(Categories)`.
         https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/menu.pl#L16-L22

     - `all_items/2`

       Rendering enumerated lists of category items as selection items is a staple in our program, as in the function "recommend"
       https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/gift_recommender.pl#L11-L19
       and "suggest new gift"
       https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/new_gifts.pl#L50-L61

       `all_items/2` is the unsung hero that unifies all items under a `Category/N` with `Items`.
       https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/utilities.pl#L209-L211

       - Why `all_items/2` instead of `findall/3`?
         https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/utilities.pl#L211-L213
         You can see we use `findall/3` inside `all_items/2`, however, we have to work with category predicates with varying arities whereas the direct use of `findall/3` expects one-size-fits-all `Template` and `Goal`. Therefore, we construct `Template` and `Goal` dynamically with `goal_n_arity/3`.
         https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/539cb1dd56871623f80cecd101d39bb761fe37f7/prolog/utilities.pl#L219-L226
         For example, we get
         ```prolog
         ?- goal_n_arity(age_group/3, Template, Goal).
         Template = [_A, _B, _C],
         Goal = age_group(_A, _B, _C) .         
         ```




<img width="1225" alt="Screenshot 2024-12-03 at 22 38 58" src="https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/assets/5562/6a8a96d6-d322-4e7b-9593-349a2eb5d334">



