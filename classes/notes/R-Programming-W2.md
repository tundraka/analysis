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
1. Search in the namespaces of each of the packages listed in `search`

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
Let's look at the following example. We are declaring a function that will
return another function. The parent functions received a parameter which is
used in the function defined inside.

We can see that from the `pow` function, the variable `n` is a free variable,
`pow` doesn't know where it's defined.

When `square` 
```R
make.power <- function(n) {
    pow <- function(x) {
        x^n
    }

    # we return the function.
    pow
}

square <- make.power(2)
cube <- make.power(3)

square(3) # returns 9
cube(3) # returns 27
```

The function `pow` has the free variable `n`, in order to find the values of
`n`, since `make.power` is the environment in which `pow` is defined, we will
look for the symbol `n` there first and then go to the parent and so on.

##Exploring a function closure##
What's in a function's environment? We can use the function `ls` to list all
the objects in the current environment.

In the following example we use the `ls` function passing as an argument the
result of calling the function `environment` with function `cube` or `square`.
The function `environemnt` returns an integer indicating the position of the
environment specified, in this case the function `cube` or `square`. This
position value is consumed by the `ls` function to determine the objects
present in that environment.

Notice how, when we list the objects in the `square` and `cube` function we get
the same list of objects; the difference lies in the values that `n` takes in
the different *closures*. For `cube` we get the value 3, and for `square` we
get the value 2. In order to get the value for `n` in the two function is with
the function `get`.

```R
ls()
ls(environment("cube")) # will return "n", "pow"
ls(environment("square")) # will also return "n", "pow"
get("n", environment("cube")) # returns 3
get("n", environment("square")) # returns 2
```

##Lexical vs dynamic scoping##
As mentioned before lexical scoping is what R does. Dynamic scoping is what
other programming languages do. Let's look at the example.
```R
y <- 10

f <- function(x) {
    y <- 2
    y^2 + g(x)
}

g <- function(x) {
    x + y
}

f(2) # prints 16
```

The function `f` defines the variable `y` as 2, which has nothing to do with
the global variable `y <- 10`. The function `g` is a free variable, since
`f` doesn't know anything about it.

When calling `f(2)` we are setting `x <- 2` which is passed to `g(x)`, `y`
inside `f` is set to 2 and elevated to the square 4, the we call the function
`g` which is defined in the global environment; the function `g` uses the free
varuable `y` which is found in the global environment with the value 10, this
is how *lexical scoping* works. 10 is added to the 2 in `x`, total 12; going
back to `f`, we add 4 to 12 and get the 16 which is displayed.

In *dynamic scoping* the value of `y` is looked up in the environment from
which the function `g` was called, the *calling environment*. In R the calling
environment is known as the *parent frame*. With *dynamic scoping* `y` would
have the value 2.

*Lexical scoping* is comon in other programming languages like scheme, python,
lisp, etc.

##Consequences of lexical scoping##
- In R, all objects must be stored in memory.
- All function must carry a pointer to their respective defining environment.

#Coding Standars#
- Use a text editor
- Indent the code. Minimum 4 spaces (my preference)
- Limit the width of the code (80 columns, f.ex)
- limit the length of functions.

#Dates and Time in R#
- Dates are represented by the `Date` class
- Time is represented by the `POSIXct` or `POSIXlt` class.
- Dates are internally stored as the number of days since 1970-01-01
- Times are stored internally  as the number of seconds since 1970-01-01

Dates represented in a character form can be coerced to Date with the `as.Date`
function. The `unclass` function will return the actual number of days.

```R
x <- as.Date('1970-01-01')
y <- as.Date('01-01-1970')
x
unclass(x) # print 0
y # this will print something weird.
```

Times are stored in the following ways
- POSIXct: the time will be stored as a very large number, this is useful when
  we want to store the time in a data frame
- POSIXlt: is a list underneath and stores a bunch of useful information like
  the day of the week, year, month, etc
- Times can be coerced between types with the functions `as.POSIXlt` and
  `as.POSIXct`

There are functions that work on dates and times
- `weekdays`: gives the day of the week
- `months`: give the month name
- `quarters`: give the quarter number.

```R
x <- Sys.time()
unclass(x) # should be an very large number (POSIXct)
# We can coerce to 
p <- as.POSIXlt(x)
names(unclass(p))
```

Now for the case were dates are in different format we have the function
`strptime`

```R
x <- c("January 10, 2015 10:40", "February 1, 1980 10:30")
d <- strptime(x, "%B %d, %Y %H:%M")
d # as above.
```

To see the list of formatting strings we can look in the help page `?strptime`

Once we have a Date object, we can perform like `+`, `-`, `>`, `<=`, etc. The
Date object keeps track of leap years, leap seconds, daylight savings and time
zones. the plotting function will recognized Dates and modify the x, y axis to
a way that accomodates functions.

#Resources#
- https://github.com/rdpeng/practice_assignment/blob/master/practice_assignment.rmd
