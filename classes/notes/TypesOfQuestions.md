#Types of Data Science Questions#
In approximate order of difficulty
- Descriptive
- Exploratory
- Inferential
- Predictive
- Causal
- Mechanistic

###Descritive analysis###
Just try to describe the data. No decisions will be made after describing the
data.
- First kind of data analysis  performed.
- Describe the data, and interpret what you've seen
- Describe data but not saying what that might be for the next person.
The US census is an example of descriptive analysis. Nothing to apply to other
countries or some other type of inferences.

###Exploratory analysis###
Find relationships you didn't know about the data.
- New connection can be discovered with exploratory models.
- Useful for defining future studies
- Not the final say
- Exploratory analysis alone shouldn't be used for generalization/prediction.
- Correlation doesn't imply causation.

###Inferential analysis###
Use a small sample of data to say something about a bigger population.
- Inference is commonly the goal of statistical models
- Inference involves estimating both the quantity you care about and
  uncertainty about your estimate
- Inference depends heavily on both the population and the sampling scheme

Examples:
- Air quality and life expectancy in counties of the US.

###Predictive analysis###
More challenging that inferential analysis. The goal is to use data collected
on some object to predict the values for another object.
- if x predicts y  it doesn't mean x causes y
- accurate prediction depends heavily on measuring the right values.
- more data and a simple model works well.
- prediction is very hard, specially about the future.

Example:
- Presidential candiates changes to win.
- How Target figured out that someone was pregnant.

###Causal analysis###
Find out what happens to a variable when you change the value of another
variable.
- Randomized studies are required to identify causation.
- It's possible to not use randomized studies, but they're complicated and
  sensitive to assumptions.
- Causal relationships are usually identified as average effects, but may not
  apply to every individual.
- Causal model are usually the *"gold standard"* for data analysis

###Mechanistic analysis###
Understand the exact changes in variables that lead to changes in variables for
indivial objects. More on engineering, physics.
- Hard to infer, except in simple situations.
- Usually modeled by a deterministic set of equations 
- Generally the random component of the data is measurement error.
- if the equations are know but the variables are not, they may be inferfed
  with data analysis.

#What is data#
- A set of items: The population, the set of objects you're interested in.
- Variables: A measurements or characteristic of an item.
 - The height of a person, time spent in a website, what topics are more
   visited, man or woman.
- Qualitative: Country of origin, sex, treatment, blood type.
- Quantitative: Height, weight, blood pressure.

The data is the second most important thing, the question is number 1. Data
will often limit or enable the question. Without a question data won't do much.

#What about big data#
Big or small data, you need the right data.

> The data may not contain the answer. The combination of some data and an
> aching desire for an answer does not ensure that a reasonable answer can be
> extracted from a given body of data - *John Tukey*

> ... not matter how big the data are. - *Jeff Leek*

#Experimental design
- Formulate your question in advance
- Confounding, what variables create a correlation to other variables.

###Prediction key quantities###
|   .  | . | Disease| . | 
|   .  | . | +  | -  |
| Test | + | TP | FP | 
|   .  | - | FN | TN | 

- Sensitivity: Probability(positive test | disease)
- Specificity: Probability(negative test | no disease)
- Positive predictive value: Probability(disease | positive test)
- Negative predictive value: Probability(no disease | negative test)
- Accuracy: Probability(correct outcome) 

Good experiments
- Have replication
- Measure variability
- Generalize to the problem you care about
- Are transparent: code/data
Prediction is not inference
- Both can be important: depend on the app.
Beware data dredging:

> is the use of data mining to uncover patterns in data that can be presented as statistically significant, without first devising a specific hypothesis as to the underlying causality. - wikipedia.

#Resources#
- figshare.com
- https://en.wikipedia.org/wiki/Data_dredging
