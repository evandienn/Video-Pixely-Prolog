
# Gifterly

Gifterly is an intelligent gift recommendation system designed to simplify the process of finding thoughtful, personalized gifts for loved ones. Powered by Prolog, Gifterly uses logic-based inference to match user insights about a recipient—like hobbies, personality, and past preferences—with relevant, high-quality gift suggestions. Our ultimate goal is to integrate natural language processing (NLP) for a conversational user experience, allowing users to simply describe their recipient and receive tailored, thoughtful gift ideas instantly.


This project is in fulfillment of the [CPSC 312 2024W1 project requirements](https://steven-wolfman.github.io/cpsc-312-website-2024W1/project.html).

## Team Members

Our team is:

+ Yasser Sanobar (student # 1): The burger
+ Tony Huang 2 (student # 2): hy
+ Evan Dien (student # 3): ED
+ Kai Lau (student # 4): Kai

We call ourselves: Burgersssss

## Acknowledgments

We surely built on the work of others! Here are resources and people we got support from:

+ A list of acknowledgments with a brief explanation of support received, e.g.:
  "We used Github Copilot extensively to generate first-pass implementations of chunks of the project that we had specified.
  We then manually adjusted and adapted these to our needs."

+ We used chatGpt to generate an empty template for the gift recommender program. We then implemented categories of the different occasions and relationships and the rules for recommending the gift for the occasions and recommendations.

## Product Pitch

Gifterly – Your Personal Gift Recommendation Wizard

Choosing the perfect gift for loved ones is a universal challenge. People spend hours browsing online, second-guessing their choices, or even putting off the decision out of uncertainty—especially when shopping for those “hard-to-shop-for” friends or family members. Gifterly aims to change this, offering an intuitive, Prolog-powered gift recommendation system that transforms the gift selection process into a fast, easy, and personalized experience. Our vision is to make gift-giving a joyful, stress-free experience by matching users’ knowledge about their loved ones with high-quality, thoughtful gift suggestions.

The Problem We’re Solving: Gifting can be stressful and overwhelming. When it comes to holidays, birthdays, or anniversaries, people want gifts that resonate and feel meaningful. Yet conventional e-commerce search engines fall short—they deliver endless results without understanding the unique personality or preferences of the gift recipient. Gifterly goes beyond generic recommendations by using Prolog’s powerful inference capabilities to assess factors like personality, occasion, hobbies, and past gift preferences, tailoring each suggestion to be as unique as the person receiving it. As we envision it, Gifterly would go one step further: ideally, the system would incorporate a natural language processing (NLP) model to allow users to express their preferences conversationally, enhancing ease of use and personalization even further.

How It Works: Gifterly begins by asking users questions about the recipient, such as hobbies, style, and any hints about past gifts they've enjoyed. However, we aim for Gifterly to eventually go beyond structured questions; with an NLP model, users could describe what they know about the recipient in natural, conversational language. This would allow Gifterly to interpret and analyze even more nuanced details and preferences, which the Prolog engine would then use to refine gift recommendations. The combination of Prolog’s logic-driven inference engine and NLP-powered input would create a truly intuitive experience, delivering instant and highly personalized suggestions without overwhelming the user.

The Vision for Awesomeness: Imagine never facing the stress of last-minute gift shopping or the disappointment of seeing a lackluster reaction to a mismatched gift. With Gifterly, every user has a smart, conversational assistant who guides them toward memorable gifts that fit each relationship perfectly. Whether for family, friends, or colleagues, Gifterly would transform gifting from a chore into an enjoyable, meaningful experience. By integrating an NLP model, we envision a platform where users can simply share what they know about their loved ones, in their own words, and receive tailored, thoughtful recommendations that make every gift-giving moment special.

Gifterly: Give with confidence, powered by intelligence and personal touch.



## Minimal Viable Project
Gifterly is a Prolog-based gift recommendation application designed to simplify the process of finding personalized gifts. Our MVP provides gift suggestions based on key information about the recipient, such as their relationship to the gifter and the occasion for the gift. By implementing this core functionality, Gifterly creates a foundation for a more advanced recommendation system that can be expanded to incorporate user preferences, advanced filtering, and potentially a conversational interface.

### Building Toward the Product Pitch

This MVP meaningfully advances our product pitch by implementing the core functionality:

1. **User Input and Output**  
   - The MVP will prompt users to provide specific details about the recipient:
   - The occasion (e.g., birthday, anniversary, Christmas).
   - The recipient's relationship to the gifter (e.g., friend, family, colleague, partner).
   - Using these inputs, Gifterly will generate tailored gift recommendations based on a structured Prolog knowledge base.

2. **Knowledge Base Construction**  
   - A small, structured database of gift suggestions will be constructed, with entries associated with particular occasions and relationships. This knowledge base forms the core logic for the recommendation system.

3. **Error Handling and User Feedback**  
   - The system will handle invalid or unrecognized inputs (e.g., an unlisted occasion or relationship) by prompting the user to provide valid information.

4. **Foundation for Expansion**  
   - This MVP lays the groundwork for future features, such as incorporating complex relationships, adjusting recommendations based on user preferences, and potentially adding natural language processing (NLP) to allow for a more conversational experience.

### Leveraging Prolog's Strengths

Gifterly’s design takes advantage of Prolog’s natural fit for rule-based systems and inference-driven logic. Here’s how we leverage Prolog’s strengths:

1. **Logical Inference and Pattern Matching**  
   - Prolog’s pattern-matching abilities make it well-suited for implementing a recommendation system based on relationships and occasions, allowing for simple and intuitive rule definitions.

2. **Declarative Syntax for Knowledge Representation**  
   - Using Prolog facts and rules to define relationships between occasions, relationships, and gifts provides a clean, maintainable structure. This approach also makes it easy to add or modify gift options as the system expands.

3. **Backtracking for Searching**  
   - Prolog’s backtracking mechanism allows us to query multiple possible gift recommendations. This is useful in scenarios where users may want to view several gift options for a given occasion and relationship.

### Learning and Applying Advanced Prolog Concepts

This project provides an opportunity to explore and apply advanced Prolog concepts, such as:

1. **Complex Querying with Recursive Rules**
   - **What We’ll Learn**: Using recursion to navigate and filter through the knowledge base.
   - **Application**: Recursive rules could enable a deeper analysis of user input, allowing for more sophisticated filtering of gift options based on specific conditions.

2. **Prolog’s Built-In Control Structures**
   - **What We’ll Learn**: How to handle conditional checks and fail cases using Prolog’s control constructs.
   - **Application**: This allows us to manage invalid inputs effectively and respond with user-friendly prompts or alternative recommendations.

3. **Dynamic Knowledge Base Expansion**
   - **What We’ll Learn**: Modifying the knowledge base dynamically to accommodate user feedback or new data.
   - **Application**: Enabling the system to learn from user preferences by dynamically adding new facts based on user input.

4. **Higher-Order Predicates**
   - **What We’ll Learn**: Utilizing Prolog’s higher-order predicates to generalize operations on gifts or occasions.
   - **Application**: Higher-order predicates could allow us to filter gifts by specific attributes, such as type, cost, or popularity, making recommendations more tailored to the user’s needs.

## Proof of Concept

Our proof of concept showcases an application prototype that accepts user input and recommends gifts by searching through a knowledge base matching occasions with relationships between a gifter and the recipient.

The core functionality involves defining a set of occasions (like birthdays and anniversaries) and relationships (such as friend and family), along with a corresponding list of potential gifts.
The user inputs their occasion and relationship, and the system searches for a suitable gift recommendation.

This element is critical because it demonstrates the simplest yet most foundational logic and decision-making process that can be expanded upon in a more comprehensive gift recommendation application.
By establishing a structured way to categorize occasions and relationships with associated gifts, we lay the groundwork for more complex features, such as user preferences.

### Application Workflow
- We provide facts for a pre-defined set of occasions and relationships.
https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/595be13cfcccfd4c6c5c4d26d4748da857d1dbbd/prolog/gift_recommender.pl#L3-L13

- We then ask the user to input an occasion and relationship.
https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/595be13cfcccfd4c6c5c4d26d4748da857d1dbbd/prolog/gift_recommender.pl#L43-L53

- Variables `O` and `R` are then unified with the user inputs.
https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/595be13cfcccfd4c6c5c4d26d4748da857d1dbbd/prolog/gift_recommender.pl#L45
https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/595be13cfcccfd4c6c5c4d26d4748da857d1dbbd/prolog/gift_recommender.pl#L47

- We use an if statement to handle invalid occasion-relationship pairs.
https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/595be13cfcccfd4c6c5c4d26d4748da857d1dbbd/prolog/gift_recommender.pl#L48-L52

  - If a valid gift is found (i.e. `Gift` is unified with a value), it will result in a recommendation.
https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/595be13cfcccfd4c6c5c4d26d4748da857d1dbbd/prolog/gift_recommender.pl#L49

  - If no valid gift is found, an error message will be printed.
https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/595be13cfcccfd4c6c5c4d26d4748da857d1dbbd/prolog/gift_recommender.pl#L51

#### Rules for gift recommendation
`recommend_gift/3` establishes the logical relationships among occasions, relationships, and gifts.
https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/595be13cfcccfd4c6c5c4d26d4748da857d1dbbd/prolog/gift_recommender.pl#L36-L40

- `occasion(O)` checks if `O` matches one of the occasions in the knowledge base.
https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/595be13cfcccfd4c6c5c4d26d4748da857d1dbbd/prolog/gift_recommender.pl#L38

- `relationship(R)` checks if `R` matches one of the relationships in the knowledge base.
https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/595be13cfcccfd4c6c5c4d26d4748da857d1dbbd/prolog/gift_recommender.pl#L39

- If both checks succeed, the predicate `gift/3` will search for a corresponding gift with the given occasion and relationship.
https://github.students.cs.ubc.ca/yassersa/cpsc312-prolog/blob/595be13cfcccfd4c6c5c4d26d4748da857d1dbbd/prolog/gift_recommender.pl#L40

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
Enter the relationship (friend, family, colleague, partner): |: friend.
Recommendation: a box of cereal
true.
```
If the occasion and relationship inputted do not match with each other or are invalid, you will be prompted with an error message.
```
?- recommend.
Enter the occasion (birthday, anniversary, new_year, christmas): easter.
Enter the relationship (friend, family, colleague, partner): |: enemy.
No gift found, please enter valid occasion and relationship.
true.
```

