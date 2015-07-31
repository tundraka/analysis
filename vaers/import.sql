-- IMPORTING
LOAD DATA INFILE '/full/path/to/20xxVAERSDATA.csv' IGNORE
    INTO TABLE VAERSDATA FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES
    (
        VAERS_ID,
        @RECVDATE,
        STATE,
        AGE_YRS,
        CAGE_YR,
        CAGE_MO,
        SEX,
        @RPT_DATE,
        SYMPTOM_TEXT,
        DIED,
        @DATEDIED,
        L_THREAT,
        ER_VISIT,
        HOSPITAL,
        HOSPDAYS,
        X_STAY,
        DISABLE,
        RECOVD,
        @VAX_DATE,
        @ONSET_DATE,
        NUMDAYS,
        LAB_DATA,
        V_ADMINBY,
        V_FUNDBY,
        OTHER_MEDS,
        CUR_ILL,
        HISTORY,
        PRIOR_VAX,
        SPLTTYPE
    )
    SET
        RECVDATE = str_to_date(@RECVDATE, '%m/%d/%Y'),
        RPT_DATE = str_to_date(@RPT_DATE, '%m/%d/%Y'),
        VAX_DATE = str_to_date(@VAX_DATE, '%m/%d/%Y'),
        ONSET_DATE = str_to_date(@ONSET_DATE, '%m/%d/%Y');

LOAD DATA INFILE '/full/path/to/20xxVAERSVAX.csv' IGNORE
    INTO TABLE VAERSVAX FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

LOAD DATA INFILE '/full/path/to/20xxVAERSSYMPTOMS.csv' IGNORE
    INTO TABLE VAERSSYMPTOMS FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

