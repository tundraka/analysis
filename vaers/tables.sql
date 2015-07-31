-- VAERS Data can be found in: http://vaers.hhs.gov/data/index
-- Details about the VAERS CSV fields, can be found in this PDF
-- http://vaers.hhs.gov/data/READMEJanuary2015.pdf
-- Located in the page: http://vaers.hhs.gov/data/data
-- Of interest: http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3965435/

CREATE DATABASE IF NOT EXISTS VAERS;

-- This schema is based on the PDF above and the data from the 2014 data.

-- VAERSDATA.CSV
-- The following table provides a detailed description of the data provided in each
-- field of the VAERSDATA.CSV file. The first two fields in this table are the only
-- fields of the dataset not derived from the VAERS - 1 form.

-- * The variables CAGE_YR and CAGE_MO work in conjunction to specify the
-- calculated age of a person. For example, if CAGE_YR=1 and CAGE_MO=.5 then the
-- age of the individual is 1.5 years or 1 year 6 months. 

CREATE TABLE IF NOT EXISTS VAERSDATA
(
    VAERS_ID BIGINT NOT NULL UNIQUE PRIMARY KEY
        COMMENT 'VAERS Identification Number',
    RECVDATE DATE NOT NULL COMMENT 'Date report was received',
    STATE VARCHAR(10) NOT NULL DEFAULT 'UNK' COMMENT 'State',
    AGE_YRS FLOAT UNSIGNED NOT NULL COMMENT 'Age in Years',
    CAGE_YR TINYINT UNSIGNED NOT NULL
        COMMENT 'Age of patient in years calculated by (vax_date - birthdate)*',
    CAGE_MO FLOAT UNSIGNED NOT NULL DEFAULT 0.0
        COMMENT 'Age of patient in months calculated by (vax_date - birthdate). 
            * The values for this variable range from 0 to <1. ',
    SEX CHAR(1) NOT NULL DEFAULT 'U' COMMENT 'Sex',
    RPT_DATE DATE NOT NULL COMMENT 'Date Form Completed',
    SYMPTOM_TEXT TEXT COMMENT 'Reported symptom text',
    DIED CHAR(1) NOT NULL DEFAULT 'U' COMMENT ' Died (Y - Yes)',
    DATEDIED DATE COMMENT 'Date of Death',
    L_THREAT CHAR(1) DEFAULT 'U' COMMENT 'Life - Threatening Illness (Y - Yes)',
    ER_VISIT CHAR(1) DEFAULT 'U'
        COMMENT 'Emergency Room or Doctor Visit (Y - Yes)',
    HOSPITAL CHAR(1) NOT NULL DEFAULT 'U' COMMENT 'Hospitalized (Y - Yes)',
    HOSPDAYS SMALLINT UNSIGNED NOT NULL DEFAULT 0
        COMMENT 'Number of days Hospitalized',
    X_STAY CHAR(1) NOT NULL DEFAULT 'U'
        COMMENT 'Prolonged Hospitalization (Y - Yes)',
    DISABLE CHAR (1) NOT NULL DEFAULT 'U' COMMENT 'Disability (Y - Yes)',
    RECOVD CHAR (1) NOT NULL DEFAULT 'U'
        COMMENT 'Recovered (Y - Yes, N - No, U - Unknown',
    VAX_DATE DATE COMMENT 'Vaccination Date',
    ONSET_DATE DATE COMMENT 'Adverse Event Onset Date',
    NUMDAYS SMALLINT NOT NULL DEFAULT 0
        COMMENT 'Number of days (Onset date - Vax. Date)',
    LAB_DATA TEXT COMMENT 'Diagnostic laboratory data',
    V_ADMINBY ENUM('PUB', 'PVT', 'OTH', 'MIL', 'UNK') DEFAULT 'UNK'
        COMMENT 'Vaccines Administered at (PUB=Public, PVT=Private,OTH=Other, 
            MIL=Military)',
    V_FUNDBY ENUM('PUB', 'PVT', 'OTH', 'MIL', 'UNK') DEFAULT 'UNK'
        COMMENT 'Vaccines purchased with (PUB=Public, PVT=Private, OTH=Other, 
            MIL=Military) funds',
    OTHER_MEDS TEXT COMMENT 'Other Medications',
    CUR_ILL TEXT COMMENT 'Current Illnesses',
    HISTORY TEXT COMMENT 'Pre-existing physician diagnosed allergies, birth 
        defects, medical conditions',
    PRIOR_VAX TEXT COMMENT 'Prior Vaccination Event information',
    SPLTTYPE TINYTEXT COMMENT 'Manufacturer Number'
);


-- VAERSVAX.CSV
-- The fields described in this table provide the remaining vaccine information 
-- (e.g., vaccine name, manufacturer, lot number, route, site, and number of
-- previous doses administered), for each of the vaccines listed in Box 13 of the 
-- VAERS form. There is a matching record in this file with the VAERSDATA file
-- identified by VAERS_ID

CREATE TABLE IF NOT EXISTS VAERSVAX
(
    VAERS_ID BIGINT NOT NULL UNIQUE PRIMARY KEY
        COMMENT 'VAERS Identification Number',
    VAX_TYPE TINYTEXT COMMENT 'Administered Vaccine Type',
    VAX_MANU TINYTEXT COMMENT 'Vaccine Manufacturer',
    VAX_LOT TINYTEXT COMMENT 'Manufacturers Vaccine Lot',
    VAX_DOSE TINYTEXT COMMENT 'Number of previous doses administered',
    VAX_ROUTE TINYTEXT COMMENT 'Vaccination Route',
    VAX_SITE TINYTEXT COMMENT 'Vaccination Site',
    VAX_NAME TINYTEXT COMMENT 'Vaccination Name'
);

-- VAERSSYMPTOMS.CSV
-- The fields described in this table provide the adverse event coded terms
-- utilizing the MedDRA dictionary. Coders will search for specific terms in boxes
-- 7 and 12 and code them to a searchable and consistent MedDRA term; note that
-- terms are included in the .csv file in alphabetical order. There can be an
-- unlimited amount of coded terms for a given event. Each row in the .csv will
-- contain up to 5 MedDRA terms per VAERS ID; thus, there could be multiple rows
-- per VAERS ID.
-- For each of the VAERS_ID’s listed in the VAERSDATA.CSV table, there is a
-- matching record in this file, identified by VAERS_ID

CREATE TABLE IF NOT EXISTS VAERSSYMPTOMS
(
    VAERS_ID BIGINT NOT NULL COMMENT 'VAERS Identification Number',
    SYMPTOM1 TINYTEXT COMMENT 'Adverse Event MedDRA Term 1',
    SYMPTOMVERSION1 FLOAT NOT NULL DEFAULT 0.0
        COMMENT 'MedDRA dictionary version number 1',
    SYMPTOM2 TINYTEXT COMMENT 'Adverse Event MedDRA Term 2',
    SYMPTOMVERSION2 FLOAT NOT NULL DEFAULT 0.0
        COMMENT 'MedDRA dictionary version number 2',
    SYMPTOM3 TINYTEXT COMMENT 'Adverse Event MedDRA Term 3',
    SYMPTOMVERSION3 FLOAT NOT NULL DEFAULT 0.0
        COMMENT 'MedDRA dictionary version number 3',
    SYMPTOM4 TINYTEXT COMMENT 'Adverse Event MedDRA Term 4',
    SYMPTOMVERSION4 FLOAT NOT NULL DEFAULT 0.0
        COMMENT 'MedDRA dictionary version number 4',
    SYMPTOM5 TINYTEXT COMMENT 'Adverse Event MedDRA Term 5',
    SYMPTOMVERSION5 FLOAT NOT NULL DEFAULT 0.0
        COMMENT 'MedDRA dictionary version number 5'
);
