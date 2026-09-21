USE MyDatabase

--There are many ways to add 'values' to (temporary/database) tables.
--#1st way to add records
Drop table if exists #Excl      -- Select * from #Excl
Select * into #Excl
    from ( values ('%AMOUNT%'), ('%COUNT%'), ('%DATE%'), ('%SOCIAL%') ) as A (exclNm)
    Select a.name, c.*
        from tempdb.sys.all_columns c
        join tempdb.sys.all_objects A on c.object_id = a.object_id
        where a.name like '%ExclLst%'

--#2nd way to add records
create table #Excl (eNm varchar (999))
Insert into #Excl values ('%AMOUNT%'), ('%COUNT%'), ('%DATE%'), ('%SOCIAL%')

--#3rd way to add records. It places result set returned by SELECT into #temp_tbl
Drop table if exists #Excl
Select exclNm = '%AMOUNT%' -- SELECT * FROM #Excl
INTO #Excl 
union
Select '%COUNT%' 
union
Select '%DATE%' 
union
Select '%SOCIAL%'

--------------------------------------------

Drop table if exists #ExclLst       -- Select * from #ExclLst
Select * into #ExclLst
    from ( values ('AMOUNT'), ('COUNT') ) as A (Nm)

Drop table if exists #Lst       -- Select * from #Lst
Select * into #Lst
    from ( values ('aaaAMOUNTaaa'), ('AMOUNTkkk'),('sssAMOUNTsss'), ('bbbCOUNTbbb'), ('aaa'), ('bbb'),('AMOUNT'),('AMOUNT') ) as A (Nm)

-- ANOTHER METHOD (#4th way) of putting string values in table usng SPLIT_STRING
DECLARE @strList VARCHAR(99) = 'aaaAMOUNTaaa,AMOUNTkkk,sssAMOUNTsss,bbbCOUNTbbb,aaa,bbb,AMOUNT,AMOUNT'
SELECT value INTO #words
FROM STRING_SPLIT(@strList, ',');
SELECT * FROM #words

--real Cartesian prod 8 x 2 = 16 rows
Select l.*, '|||' , e.*
    from #Lst L
    Join #ExclLst E on 1 = 1

--FULL JOIN
--Matching rows from L and E
--Unmatched rows from L, with NULL values for E
--Unmatched rows from E, with NULL values for L
SELECT l.*, '|||' , e.*
from #Lst L
    FULL Join #ExclLst E on e.Nm = l.Nm

Select * from #Lst
Select * from #ExclLst
Select l.*, '|||', e.*
    from #Lst L
    Join #ExclLst E on l.Nm  like '%' + e.Nm + '%'

--##############################
--Comparing records in main table with records in lookup table (if match-> delete)
--##############################
--USING DELETE/IN  - good for med-small record sets
--step1
Drop table if exists #Deletable
Select l.Nm AS lstNm, e.Nm AS exclNm INTO #Deletable -- SELECt * FROM #Deletable
    from #Lst L
    Join #ExclLst E on l.Nm like '%' + e.Nm + '%'
--step2
DELETE FROM #Lst    --Select * from #Lst
WHERE Nm IN (
    SELECT D.lstNm
    FROM #Deletable AS D
);
----------------------------------
-- USING DELETE/JOIN -> good for environment with a lot of records, find and exclude a lot of records. 
-- Requires extra 1 step to create index in the exclude table to speed up DELETE
--step1
Drop table if exists #Deletable
Select l.Nm AS lstNm, e.Nm AS exclNm INTO #Deletable -- SELECt * FROM #Deletable
    from #Lst L
    Join #ExclLst E on l.Nm like '%' + e.Nm + '%'
--step2
DELETE #Lst WHERE Nm IN ( SELECT lstNm FROM #Deletable); -- uses Scan tables -> very slow

DELETE L 
    -- SELECT l.*
  FROM #Lst L
  JOIN #Deletable D ON l.Nm = d.lstNm -- much faster  way -> Join

--VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
--works fast in small/mid size environment
DELETE L 
    -- SELECT l.*
  FROM #Lst L
  JOIN #ExclLst E ON l.Nm like '%' + e.Nm + '%'
SELECT * FROM #Lst
--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

--step3
Select * from #Lst
Select * from #Deletable


----------------------------------
--USING Excluding FULL JOIN
Drop table if exists #Final
Select l.Nm AS lstNm INTO #Final -- SELECt * FROM #Final
    from #Lst L
    Full Join #ExclLst E on l.Nm  like '%' + e.Nm + '%'
    where e.Nm IS NULL

---------------------------------------
--USING JOIN
Drop table if exists #Deletable
Select l.Nm AS lstNm, e.Nm AS exclNm INTO #Deletable -- SELECt * FROM #Deletable
    from #Lst L
    Join #ExclLst E on l.Nm like '%' + e.Nm + '%'

UPDATE L
   SET l.nm = 'bla'
--SELECT l.Nm
  FROM #Lst L
  Join #ExclLst E on l.Nm like '%' + e.Nm + '%'

  SELECT * FROM #Lst
  WHERE Nm != 'bla'
---------------------------------------


---------------------------------------

Select * from #Lst
    where Nm not like '%AMOUNT%' and Nm not like '%COUNT%'

SELECT value 
FROM STRING_SPLIT('apple,banana,cherry', ',');
-----------------------------------------------------------------------------
--TEST AREA
-----------------------------------------------------------------------------


Drop table if exists #Test
Select l.Nm AS lstNm  INTO #Test -- SELECt * FROM #Test Select * from #Lst
    from #Lst L
    Join #ExclLst E on l.Nm like '%' + e.Nm + '%'
    --where e.Nm IS NULL

DECLARE @x int
SELECT @x = COUNT(Nm) FROM #Lst
SELECT @x



 --COUNT(Nm) INTO ;
SELECT COUNT(lstNm) FROM #Test;
SELECT TOP ((SELECT COUNT(Nm) FROM #Lst) - (SELECT COUNT(lstNm) FROM #Test) ) FROM #Lst;

SELECT l.Nm, '|||', t.lstNm FROM #Lst L
JOIN #Test T ON l.Nm = t.lstNm
