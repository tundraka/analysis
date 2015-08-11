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
for (i in 1:10) print(x[i])
for (letter in x) print letter
for (i in 1:4) print(x[i]) # I need to know the length
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
