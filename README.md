
# Prolog Gift Recommender

This will be replaced with a very brief (one paragraph, 2-3 sentences) overview of the project.

Leave the following sentence in so you can easily link back to the requirements and *especially* rubric while editing your project:

This project is in fulfillment of the [CPSC 312 2024W1 project requirements](https://steven-wolfman.github.io/cpsc-312-website-2024W1/project.html).

## Team Members

Our team is:

+ Team Member Name 1 (student # 1): optional awesome nickname 1
+ Tony Huang 2 (student # 2): hy 2
+ Team Member Name 3 (student # 3): optional awesome nickname 3
+ If you have a fourth member: Team Member Name 4 (student # 4): optional awesome nickname 4
+ If you have a fifth member: Team Member Name 5 (student # 5): optional awesome nickname 5

We call ourselves: optional awesome team name.

## Acknowledgments

We surely built on the work of others! Here are resources and people we got support from:

+ A list of acknowledgments with a brief explanation of support received, e.g.:
  "We used Github Copilot extensively to generate first-pass implementations of chunks of the project that we had specified.
  We then manually adjusted and adapted these to our needs."

+ We used chatGpt to generate an empty template for the gift recommender program. We then implemented categories of the different occasions and relationships and the rules for recommending the gift for the occasions and recommendations.

## Product Pitch

Replace this with a pitch for your project and the problem it solves. This is your vision for what the project
would like like as a complete product, ready for awesome action. (Yes, awesomeness seems to be a theme.)
It may be as short as a couple of paragraphs, or it may be longer. It should **definitely** take less than 4 minutes
to read carefully and thoroughly.

Be sure that this touches clearly on the [project requirements](https://steven-wolfman.github.io/cpsc-312-website-2024W1/project.html#project-requirements).

Good goals to aim for are from the top two rubric items for proposal grading:

> Exciting and language-appropriate product idea tackling a problem that is clearly compelling to a significant audience.

Or:

> Solid and language-appropriate product idea with a problem that is of real interest to the submitting team.

(It's easy to focus on the product and not the problem. Remember to include both!)

## Minimal Viable Project

Replace this with a description of the minimal viable project you will actually build for CPSC 312 (if this becomes your final project).
It may be as short as a few paragraphs, or it may be longer. It should **definitely** take less than 4 minutes
to read carefully and thoroughly.

Make clear:
+ how this builds meaningfully toward your product pitch above, without being nearly as much work,
+ how it builds on the strength and power of the language, and
+ how it leads naturally to learning and applying some new element of the language (including what that element is!)

Good goals to aim for are from the top two rubric items for proposal grading:

> The minimal viable project (MVP) builds on the strengths and power of the language in exciting ways that will clearly lead to excellent learning for students.

Or:

> The MVP clearly builds significantly on the language and will lead in interesting and natural ways to learning for the students.

## Proof of Concept

Our proof of concept showcases an application prototype that accepts user input and recommends gifts by searching through a knowledge base matching occasions with relationships between a gifter and the recipient.

The core functionality involves defining a set of occasions (like birthdays and anniversaries) and relationships (such as friend and family), along with a corresponding list of potential gifts.
The user inputs their occasion and relationship, and the system searches for a suitable gift recommendation.

This element is critical because it demonstrates the simplest yet most foundational logic and decision-making process that can be expanded upon in a more comprehensive gift recommendation application.
By establishing a structured way to categorize occasions and relationships with associated gifts, we lay the groundwork for more complex features, such as user preferences.

### Application Workflow
We provide facts for a pre-defined set of occasions and relationships.
https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/595be13cfcccfd4c6c5c4d26d4748da857d1dbbd/prolog/gift_recommender.pl#L3-L13

We then ask the user to input an occasion and relationship.
https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/595be13cfcccfd4c6c5c4d26d4748da857d1dbbd/prolog/gift_recommender.pl#L43-L53

Variables `O` and `R` are then unified with the user inputs.
https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/595be13cfcccfd4c6c5c4d26d4748da857d1dbbd/prolog/gift_recommender.pl#L45
https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/595be13cfcccfd4c6c5c4d26d4748da857d1dbbd/prolog/gift_recommender.pl#L47

We use an if statement to handle invalid occasion-relationship pairs.
https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/595be13cfcccfd4c6c5c4d26d4748da857d1dbbd/prolog/gift_recommender.pl#L48-L52

If a valid gift is found (i.e. `Gift` is unified with a value), it will result in a recommendation.
https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/595be13cfcccfd4c6c5c4d26d4748da857d1dbbd/prolog/gift_recommender.pl#L49

### Rules for gift recommendation
`recommend_gift/3` establishes the logical relationships among occasions, relationships, and gifts.
https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/595be13cfcccfd4c6c5c4d26d4748da857d1dbbd/prolog/gift_recommender.pl#L36-L40

`occasion(O)` checks if `O` matches one of the occasions in the knowledge base.
https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/595be13cfcccfd4c6c5c4d26d4748da857d1dbbd/prolog/gift_recommender.pl#L38

`relationship(R)` checks if `R` matches one of the relationships in the knowledge base.
https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/595be13cfcccfd4c6c5c4d26d4748da857d1dbbd/prolog/gift_recommender.pl#L39

If both checks succeed, the predicate `gift/3` will search for a corresponding gift with the given occasion and relationship.
https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/595be13cfcccfd4c6c5c4d26d4748da857d1dbbd/prolog/gift_recommender.pl#L40

If no valid gift is found, an error message will be printed.
https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/595be13cfcccfd4c6c5c4d26d4748da857d1dbbd/prolog/gift_recommender.pl#L51

### Conclusion
Completing this proof-of-concept gives us confidence that, with further development, we can build a minimal viable product (MVP).
The successful implementation of the basic recommendation logic showcases the ability to handle user input, handle wrong user inputs, process data, and generate output. All of these are essential components of a fully functional application.
Moreover, brevity, composability, and expressivity bestowed upon by Prolog's logical programming paradigm will facilitate extensions, such as adding new occasions, relationships, and gifts, or integrating external data sources for more sophisticated recommendations.

Overall, this proof-of-concept serves as a solid foundation upon which we can construct a more robust gift recommendation system that meets user needs in a practical and engaging manner.
With additional features and refinements, we can transform this initial version into a fully realized application capable of providing personalized gift suggestions for various occasions and relationships.


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

After inputting any matching occasion and relationship, you will receive a gift recommendation.
```
?- recommend.
Enter the occasion (birthday, anniversary, new_year, christmas): new_year.
Enter the relationship (friend, family, colleague, partner): friend.
Recommendation: a box of cereal
true.
```
If the occasion and relationship inputted do not match with each other or are invalid, you will be prompted with an error message.
```
?- recommend.
Enter the occasion (birthday, anniversary, new_year, christmas): easter.
Enter the relationship (friend, family, colleague, partner): enemy.
No gift found, please enter valid occasion and relationship.
```

