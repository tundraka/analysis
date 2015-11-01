#Bank
Will allow me to analyse my bank transactions. I have three statements that
I look into, that's why the `statement.R` script loads three files.

##Items
The items CSV file will contain a 'table' that allows the classification of the
items in the statements.

####Databook
1. `itemid`: the id for the company
2. `description`: a string that matches a part of the description that I see in
   the statement.
3. `regexp`: Initially I thought that some of the description would be regular
   expression and other would be the text, but right not everything is a regexp
   so probably I'll remove this flag in a future version.
4. `category`: The transaction will be classified in buckets like groceries,
   utilities, etc.
5. `name`: The actual name of the company.


#tesseract
I'm trying to keep track of the tickets from my purchases. For that I take
a picture of the receipt and then use tesseract to extract the text, I'm
working on a script to transform the output from tesseract into a CSV or some
other output.

###Installation
Steps to install `tesserac` in my mac. I tried to just call [brew][2] but
failed with:

```
Error: The `brew link` step did not complete successfully
The formula built, but is not symlinked into /usr/local
Could not symlink share/man/man5/unicharambigs.5
/usr/local/share/man/man5 is not writable.

You can try again using:
  brew link tesseract
```

Looks like there were some issue with permission, this can be solved with the
`fix_homebrew.rb` [script][1].

```bash
ruby fix_homebrew.rb
brew install tesseract
```

[1]: https://gist.github.com/rpavlik/768518
[2]: http://brew.sh/
