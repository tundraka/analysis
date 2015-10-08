#VAERS (Vaccine Adverser Event Reporting System) Data
The VAERS data can be downloaded from [here][1]. The VAERS website has some
diclaimers about the data, where it's coming from, and to be careful what you
deduce from it. I'd recommend to read those pages. [Here's][3] video about VAERS.

I think the VAERS data doesn't offer the whole picture since this represent the
report from the pacient, but we never know what the VAERS did with that report,
what investigation was performed, outcome, etc.

The VAERS data is divided in several files, 1 for each year and can normally be
found under the [data page][2]. In order to download the files, we will be
challenged by a captcha. The data URL follow a pattern like:

```
https://vaers.hhs.gov/eSubDownload/index.jsp?fn={xxxx}VAERSData.zip
# Where xxxx is the year 1990 - present
```

So far, in the script `vaers/vaers.R` I have read the 2014 data to get to know
the data. The script can't download the data since it'll be challenged by
a captcha, the data file will need to be downloaded, unzipped and placed under
the directory structure `data/VAERS/2014`, I'll simplify this in a later
version.

##Open questions to the VAERS staff
- What percentage of the reports are investigated by VAERS?
- Is there an initial vetting mechanism to determine if VAERS gets involved and
  request more information about a specific event?
- Is it possible to access the outcome of the investigation that VAERS did after
  a report has been investigated?
- Is it possible to get more information about the event, specifically about the
  demographics? Like ethnicity, income, practice, etc.

##About the data
- How is the 

####VAERS Contact info.
For more information, please call the VAERS Information Line toll-free at
(800) 822-7967 or e-mail to info@vaers.org.

#Glossary
vax: vaccination

[1]: https://vaers.hhs.gov/data/index
[2]: https://vaers.hhs.gov/data/data
[3]: https://www.youtube.com/watch?v=a9bXB3R2qP8
