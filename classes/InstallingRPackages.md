#Installing R packages#
See a list of the available packages: `availabe.packages()`
To install a package: `install.packages("slidify")`. Any dependency will also be
installed. Multiple packages `install.packages(c("package1", "package2", ...)`

###Installing from Bioconductor###
Maybe this are instructions to install packages that are offered outside of
CRAN?
```R
source('http://bioconductor.org/biocLite.R')
biocLite() # install the basic version, loads a lot of packages.
biocLite('package1', "package2") # Install the packages1, 2, etc.
```

After installing we need to load the package. `library(package2)` the package
name doesn't use quotes. After it's loaded, the functions exported by the
package can be seen with `search()`
