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
    from ( values ('aaaAMOUNTaaa'), ('bbbCOUNTbbb'), ('aaa'), ('bbb') ) as A (Nm)

Select l.*, '|||' , e.*
    from #Lst L
    Join #ExclLst E on 1 = 1

Select l.*, '|||', e.*
    from #Lst L
    Join #ExclLst E on l.Nm not like '%' + e.Nm + '%'

Select * from #Lst
    where Nm not like '%AMOUNT%' and Nm not like '%COUNT%'
