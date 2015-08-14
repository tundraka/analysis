#Overview and History of R#

###What is S###

- John Chambers, Bell labs
- Initiated in 1976 (ForTran language)
- 1988 rewritten in C, V3. The white book
- 1998 V4. The green book. Basics fundamentals are based on this version.

###R###
- Created in New Zealand Ross Ihaka and Robert Gentleman
- 1993: R public
- 1995: By influence of Martin Mächler, R becomes GPL

###Drawback###
- 40 year old tech.
- Little support for dyn 3D graphics
- Consumer demanr and user contributions.
- Objects need to be store in physical memory.

###Design###
- Base R system
- everything else (recommended...)
- 4K CRAN packages.
- CRAN has standards to be there
 - Documentation
 - Test

#Getting Help#
- Email
- Forums
- Internet
- Experiment
- Read source code
- R help: `? read.table`

###No luck###
- Specify what you did
- Steps to repro
- Expected output
- What do you see?
- Software version, OS, R
- Other useful stuff

#R Console Input and Evaluation#
- Assignment `<-`
```R
x <- 1
print(x)
[1] 1
x
[1] 1
```

#Data Types - R Objects and Attributes#
- Everything in R is an object
- Atomic classes
 - chars
 - numerics
 - integer
 - complex
 - logical (true/false)
- Vector
 - Objects of the same class
 - Except list
 - Can be created with vector()
 - c() concatenate, creates vectors
 - vector("numeric", length = 0); default value 0
- Mixing objects. Coercion happens behind the scenes so every element is of the
  same class.
 - least common denominator?
```R
c(1.7, "a") # character
c(T, 2) # numeric T=1, F=0
c(T, "a") # character
c("a", T) # character
```
- Coercion can be explicit
```R
as.numeric(x)
as.logical(x)
as.character(x)
```
- Coercion can make no sense (non sensical coercion)
```R
x <- c("a", "b", "c")
as.numeric(x)
# returns NA NA NA and a warning message.
```

- List
```R
x <-list(1, "a", T, 1 + 4i)
# FWIW: list elemen will have double brackets.
```

- Number
 - Double precission real number
 - L suffix to force an integer
 - Inf represents infinity
 - NaN (not a number) 0/0 -> NaN

- Attributes: R objects can have attrs
 - name, dimnames (dimension names)
 - dimensions (matrix, arrays)
 - class
 - length
 - Other user defined attributes/metadata
 - attributes() -> sets/modifies atts in an object.

- Matrices
 - has a `dimension` attribute
```R
x <- matrix(nrow = 2, ncol = 3)
dim(x) # [1] 2 3
```
 - cbind(), rbind()
 - column binding, row binding
 - bind them by column, bind them by row, for example, 2 vectors can be bind as
   rows ending with a matrix of 2 by the length of the vector.

- Factors, vector of numerics but where each integer has a label
 - Male, Female
 - Senior, Junior, Freshman, etc.
```R
x <- factor(c("yes", "yes", "no", "no", "yes"))
x #will print the values, plus 'levels' with the different options (yes, no)
table(x)
# will print the freq of each value in the factor, yes 3, no 2.
unclass(x)
```
 - Levels, no = 1, yes = 2, because n is before y
 - We can define the levels like
```R
x <- factor(c("yes", "no", "no"), levels = c("yes", "no))
```

- Missing values
 - NA: Everything else
 - NaN: Mathematical values
 - is.na()
 - is.nan()
 - NaN ontainedC NA. is.na(NaN) == true
 - NA not contained in NaN. is.nan(NA) == false

- Data frame
 - store tabular data
 - Attributes: `row.names`
 - Generally created by calling `read.table()`, `read.csv()`
 - Can be converted to matrix: `data.matrix()`
```R
x <- data.frame(foo = 1:4, bar = c(T, T, F, F))
```

- Names attributes: names the columns in a vector?
```R
x <- 1:3
names(x) # null
names(x) <- c("a", "b", "c")
x # will display the vector with each columns as especified above.
```
 - Lists can have names
```R
x <- list(a = 1, b= 2, c=3)
```
 - Matrices can have names using `dimnames()`
```R
x <- matrix(1:4, nrow=2, ncol=2)
dimnames(x) <- list(c("a", "b"), c("c", "d"))
# row names: a b
# col names: c d
```

#Read tabular data#
- read.table
- read.csv
- readLines - Lines of text files.
- source
- dget: dparse?
- load/unserialize: binary objects into R

```R
tabular <- read.table("tabular.txt")
nrows(tabular) # number of rows
names(tabular) # get the column names of the data frame.
tail(tabular) # The last elements of an R object
tail(tabular, 10) # The last 10 elements of an R object
```

#Read Large tables#
If there are no comments set `comment.char=""`

The `colClasses` argument is useful when reading data so R is not trying to
figure out what type of data there is in every col. This will make the reading
twice as fast.

It's also useful to specify how many rows R will read, it doesn't makes things
faster, but helps with memory usage.

```R
comment.char="" # is this how this is used?
initial <- read.table("database.txt", nrows=100)
classes <- sapply(initial, class)
tabAll <- read.table("database.txt", colClasses = clases)
```

A set of 1.5M row with 20 cols, being all numeric data we will calculate the
size like:

- 1500000 x 20 x 8 (bytes/numeric)
- 144,000,000
- 144,000,000/2^20 (bytes/MB)
- 1,373.26 MB
- 1.34 G

Things to know about the system you're running R
- What apps are used
- Amount of RAM
- Other users using resources
- OS, 32/64 (able to access more mem, provided there's memory) , etc.

There's also a little bit of overhead, the rule of thumb is that we will need
double the amount of the data set size.

#Textual data formats#
`dump`, `dput` useful because out info in textual format. They also output the
metadata of the data set, so it doesn't need to be constructed from scratch.

Advantages:
- They can be edited
 - for those needed case, not for a day to day activity
 - In case of corruption for example.
- Work better with VCS (git)
- Adhere to the Unix phiilosophy
- Negative: not very space efficient.

```R
y <- data.frame(a = 1, b = "a")
dput(y)
# will output the actual text to console
dput(y, file="y.R")
# mm not sure about the R extension could this be confused with R source code?
new.y <- dget("y.R")
new.y # like the y above
```

`dump` is similar to `dput` the difference is that `dput` is used for a single
R object

```R
x <- "something"
y <- data.frame(a = 1, b = "a")
dump(c("x", "y"), file = "data.R")
# dumping the object x and y into data.R
rm(x, y)
source("data.R")
# reading everyting back into x and y
```

#Interfaces to the outside world#
Most of this happen automatically when calling `read.table("file.R")` we are for example
making a `file` connection. Reading a compressed file calling either `gzfile`,
`bzfile`

- file
- bzfile
- gzfile
- url

`str(file)` it's important to know the initial params, the file name and then
the open mode (r, w, a).

####Connections####

```R
con <- file("file.csv" ,"r")
data <- read.csv(con)
close(con) # just an example of how connection work.
# A connection was not necessary to read the CSV file.
# This is equivalent to say:
data <- read.csv("file.csv")
```

#Subsetting#
Keys to keep in mind: `[`, `[[`, `$`
`[` objects of the same class.

##Vectors##

```R
x <- c("a", "b", "c", "d", "a")
x[1] # a
x[2] # b
x[1:3] # a b c
x[x > "a"] # b c d, extracing using a numeric index
u <- x > "a" # F, T, T, T, F
x[u] # b c d, extracting using a logical index
```

##Lists##
```R
x <- list(foo = 1:4, bar = 0.6)
x[1] # $foo and 1 2 3 4
x[[1]] # 1 2 3 4
x$bar # 0.6
x[["bar"]] # 0.6
x["bar"] # $bar 0.6
######
x <- list(a = 1:3, b=0.5, c="Hello")
x[c(1, 3)] # will extract the elements 1, 3
# $a 1 2 3, $c "hello"

# computing the index.
name <- "a"
x[[name]] #  we can use the variable in the bracket notation: 1 2 3
x$name # doesn't work, name doesn't exists in x
x$a # as expected 1 2 3
```

##Matrices##
```R
x <- matrix(1:6, 2, 3)
x[1, 1] # el 1,1: 1
x[1,] # row 1
x[,1] # col 1
```

The behavior of `x[1,1]` is to return a vector as opposed to a 1x1 martix, in
order to have a 1x1 matrix we'll need to add the attribute `drop=FALSE` which
means that it won't drop the dimension. The same can be done for the cases when
we get either the column or row `x[1,,drop = F]` will return col 1 in the form
of a matrix.

#Partial Matching#
For the command like with typing, work with `[` and `[[`.

```R
x <- list(something = 1:3)
x$s # will output 1 2 3, because s matches the _s_omething
x[["s"]] # NULL, because s is not a recognized name, the bracket is expecting
an exact match.
x[["s", exact = F]] # same as above.
```

This is cool, but I don't know what's the advantage, using `x$a` could introduce
issues when accessing values, whoever is reading the code will need to know
which `a` name is first.

##Removing NA values##
```R
x <- c(1, 2, NA, 3, NA, 4)
bad <- is.na(x)
x[!bad] # 1 2 3 4
```

What about for multiple elements? Both element should have the same length. The
`NA` positions don't need to match, but having an `NA` in one position of an element and not in the other would cause the position to be marked as `NA` in both.
```R
x <- c(1, 2, NA, 3, NA, 4, 5)
y <- c("a", "b", NA, "d", NA, NA, "g")
good <- complete.cases(x, y) #
x[good] # 1 2 3 5 <- the 4 is missing because y[6] is NA
y[good] # a b d g
```

How about a data set with missing values in different columns. This is an
example taken from the class.
```R
airquality[1:6,]
good <- complete.cases(airquality)
airquality[good,][1:6,] # will remove the rows that don't have the complete
values. About the [1:6], I don't know what it's about.
```

#Vectorized operations#
Many R operations are vectorized
```R
x <- 1:6, y <- 7:12
x + y # 8 10 12 14 16 18
x > 2 # F F T T T T
x >= 2 # F T T T T T
y == 8 # F T F F F F
x * y # 7 16...
x / y # yes, what you imagine.
```

With matrices is similar
```R
x <- matrix(1:4, 2, 2), y <- (rep(10, 4), 2, 2)
# x 1, 3    y 10 10
#   2, 4      10 10
x * y # This is an element to element multiplication.
# Output
# 10, 30
# 20, 40
x / y # is the same
x %*% y # This a matrix multiplication
# 40 40
# 60 60
```

#SWIRL#
Statistics with interative R Learning (swirlstats.com)

#Resources#
- http://datasciencespecialization.github.io/
- https://leanpub.com/rprogramming
- https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet
- http://catb.org/~esr/faqs/smart-questions.html
