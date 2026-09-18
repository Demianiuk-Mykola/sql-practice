USE MyDatabase

Drop table if exists #ExclLst       -- Select * from #ExclLst
Select * into #ExclLst
    from ( values ('%AMOUNT%'), ('%COUNT%'), ('%DATE%'), ('%SOCIAL%') ) as A (exclNm)
    Select a.name, c.*
        from tempdb.sys.all_columns c
        join tempdb.sys.all_objects A on c.object_id = a.object_id
        where a.name like '%ExclLst%'

create table #Excl (eNm varchar (999))
Insert into #Excl values ('%AMOUNT%'), ('%COUNT%'), ('%DATE%'), ('%SOCIAL%')

Select exclNm = '%AMOUNT%' union
Select '%COUNT%' union
Select '%DATE%' union
Select '%SOCIAL%'

--------------------------------------------

Drop table if exists #ExclLst       -- Select * from #ExclLst
Select * into #ExclLst
    from ( values ('AMOUNT'), ('COUNT') ) as A (Nm)

Drop table if exists #Lst       -- Select * from #Lst
Select * into #Lst
    from ( values ('aaaAMOUNTaaa'), ('AMOUNTkkk'),('sssAMOUNTsss'), ('bbbCOUNTbbb'), ('aaa'), ('bbb') ) as A (Nm)

Select l.*, '|||' , e.*
    from #Lst L
    Join #ExclLst E on 1 = 1


Select * from #Lst
Select * from #ExclLst
Select l.*, '|||', e.*
    from #Lst L
    Join #ExclLst E on l.Nm not like '%' + e.Nm + '%'
------------------------------
--step1
Drop table if exists #Deletable
Select l.Nm AS lstNm, e.Nm AS exclNm INTO #Deletable -- SELECt * FROM #Deletable
    from #Lst L
    Join #ExclLst E on l.Nm like '%' + e.Nm + '%'
--step2
DELETE FROM #Lst
WHERE Nm IN (
    SELECT D.lstNm
    FROM #Deletable AS D
);
--step3
Select * from #Lst


----------------------------------

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

--step3
Select * from #Lst
Select * from #Deletable


----------------------------------
Select * from #Lst
    where Nm not like '%AMOUNT%' and Nm not like '%COUNT%'
