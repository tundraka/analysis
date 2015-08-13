#Control Structures#
Not used frequently when interacting with the console, but rather in an
R program or function.
- if, else
- for
- while
- repeat
- break
- next
- return

##if##
Very similar to the C syntax
```R
if (<expression>) {
} else {
}

if (<expression>) {
} else if (<expression>) {
} else {
}
```

There a small differences though
```R
if (x > 3) {
    y <- 0
} else {
    y <- 1
}

# This is equivalent.
y <- if (x > 3) {
    0
} else {
    1
}
```

##for##
```R
for (i in 1:10) {
    print(i)
}

x <- c("a", "b", "c", "d")
for (i in 1:4) print(x[i]) # I need to know the length
for (letter in x) print letter
for (i in seq_along(x)) print(x[i]) # this generates a vector from 1 to length
```

We can also iterate over a matrix. This will require to use nested loops,
nesting for loops can become hard to understand/maintain, it's recommended to
have a small number of nested loops.

The `seq_len` function used in the following example, takes an integer and will
create a sequence that starts in 1 and end in the number specified. In this
case `nrow` will return 2, `seq_len` will produce the vector: 1 2.

```R
y <- matrix(1:6, 2, 3)
for(i in seq_len(nrow(y))) {
    for (j in seq_len(ncol(y))) {
        print(y[i, j])
    }
}
```

##while##
Similar to C syntax
```R
count <- 1
stop <- F
while (count < 10 && !stop) {
    print(count)
    count <- count + 1
    if (count == 7) {
        stop <- T
    }
}
```

##repeat, next, break##
`repeat` initiates an infinite loop, `break` will need to be called to end the
`repeat`
```R
# this is a silly example, I'd rather use a for loop.
count <- 0
repeat {
    count <- count + 1
    if (count == 7) {
        break
    }
}
```

`next` is used in the loops to skip an iteration, it's similar to C. `return`
works the way you are thinking.

#Functions#
Functions are stored as R objects, their class is `function`. Functions are
*first class objects*, they can be treated like any other R object,
- Functions can be passed as arguments
- Functions can be nested
- Can functions be returned? Yes
```R
myFunc <- function(param) {
    x <- param + 10
    f <- function(y) {
        print("We have")
        y + x
    }
}

intF <- myFunc(2)
intF(3) # return 15
```

In this example, we are creating a function that adds 2 numbers, one thing
that is interesting here is that there's no return statement, the last
expression is the element to be returned.
```R
add2 <- function(x, y) {
    x + y
}
add2(3, 4) # returns 7
```

The following example specified a default value for one of the parameters.
```R
above <- function(x, n = 10) {
    use <- x > n
    x[use]
}
x <- 1:12
above(x) # outputs 11 12
above(x, 9) # output 10 11 12
```

The following example, doesn't offer anything new about functions, I'm adding
it because there are a couple of things that are interesting and I believe can
be useful.

The first thing to notice is how an empty vector is created with
`numeric(length)` this will create a vector of two elements initialized to 0.

The other intersting thing is the use of the mean function and how NA values
were removed, in one of the previous exercises I used to call `is.na` or
`complete.cases`

Notice that the for loop iterated from `1:colsCount` we didn't need to use the
function `seq_len(colsCount)`
```R
columnmean <- function(x, removeNA = T) {
    colsCount <- ncol(x)
    means <- numeric(colsCount)
    for(col in 1:colsCount) {
        means[col] = mean(x[,col], na.rm = removeNA)
    }

    # This is the last expression, this is what we return.
    means
}
```

##Argument matching##
Function can have default attributes and required attributes, the default
attributes can be left out when calling the function, the required ones would
need to be part of the call. We can change the order of the arguments when
calling the function and R will match them.

The following example call the function in 2 different but equivalent way.
This is good to know, but this is not a good practice (at least in this
example).

There are function that have a big number of attributes and with defaults, in
order to access one of those attributes it'd be easier to match the argument
with *positional name* as oppose to *positional match* (know what position the
attribute we are setting is)

```R
myFunc <- function(x, y, z=1, t=13) {
    # something.
}
myFunct(1, 2, 2)
myFunct(z=2, 1, 2)
myFunc(y = 2, 1, 2)
# since y is out of the list, then the next attribute would be for x, 2
# for z and t will use the default 13.
myFunc(y = 2, 1, 2)

```

##Lazy evaluation##
Elements are evaluated (used) as required; for example, the following function
has two params but the function only makes use of `a`, when calling the
function we are only passing one param and this is fine, since `b` was never
used we won't get any error. **Note**: Why would we do that? 

```R
myFunc <- function(a, b) {
    a^2
}

myFunc(2) # returns 4
```
The following example will cause an error because the param `b` is used in the
body of the function, notice that the function will execute up to the point
where the error occurs.
```R
myFunc <- function(a, b) {
    print(a)
    print(b)
}
myFunc(23)
# prints 23
# displays an error
```

##The ... element##
This is similar to Java `...` param that will allow you to pass an undetermine
number of params. An example of this would be the `paste` and `cat` functions.
Any attribute after the `...` argument, shoud be names so R know what that
attributes is refering to.
```R
args(paste)
args(cat)

cat("a", "b", sep = ":"); # print a:b
```

The following example uses the `...` element to extend an
R function. It will set a default to one of the params, the extended function
however has more attributes than the ones specified in the sinature of the
extending function, since we don't want to limit this we let the user pass
those extra attributes to the extended function with the `...` element.
```R
myPlot <- function(x, y, type = "1", ...) {
    plot(x, y, type = type, ...)
}
```

#Symbol binding#
This deals with how R finds symbols. For example, the `lm` function is
already defined in the *environment* `namespace:stats` we can see this
information by executing `lm` in the R console.

What is an environment? A list of symbols and values.

How does R locates that function? R looks through different *environments*
trying to find such symbol. We can see the list of environments with the
function `search` which list all the packages that are currently loaded into R. The order that R follow to search for symbols is:

1. Search in the global environment.
2. Search in the namespaces of each of the packages listed in `search`

- The global environment is always the first environment in the search list.
- The last environment is always the base.
- Users can define which packages get loaded an in what order.
- When a user loads a package with `library` it'll be in position 2 and then
  shift the other.
- R has a separate namespace for function and non-functions. This makes me
  think why R does that distinction given that functions are first class
objects. But in the case where a function `c` exists and a vector `c` exists,
R will now what object we are referring.

##Scoping rules##
- Determines how a *free variable* gets a value assigned to it.
- R uses *lexical scoping* or *static scoping*. A common alternative to
  *dynamic scoping*. What are these? *I don't know*.
- *lexical scoping* is useful for statistical computation. I'm going to believe
  that.

The following example defines a function using 2 formal arguments `x` and `y`,
the *free variable* `z` however is not an arguments and it definition it's not
clear, `z` is a *free variable*, where is it defined? 

```R
myFunc <- function(x, y) {
    x * y * z
}
```

###Lexical scoping###
Lexical scopingin R means: *the values of free variables are searched for in
the environment in which the function was defined*
- As mentioned above an environment is a collection of symbol/values.
- Every environment has a parent, and an environment can have multiple
  *"children"*
- The only environment without a parent is the *empty environment*
- A function + environment = *closure* or *function closure*

Going back to the example above, the free variable `z` would be search in the
global environment, if I have an object called `z` it will be used. 
In case there's no object called `z` in the global environment, we will
continue the search in the parent environment. When we call `search()` we can
see a list of parent environments of `.GlobalEnv`, the search will continue
through those environment until we hit the *top level environment*, usually the
global environment, ending in the empty environment.

- **This needs review**. Specially the part of `search()`.
- **Note**. Think about the case where a function is defined in another function.

##Scoping rules##
