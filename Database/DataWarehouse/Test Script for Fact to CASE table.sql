SET sqlformat ansiconsole;

select * from dw_dimtblCustomer 
fetch first 5 row only;


    SELECT 
        c.Phone_Number,
        p.name,
        p.id,
        s.social_class,
        trunc(months_between(TRUNC(sysdate), to_date(c.dob))/12) as age,
        CASE WHEN (c.contract_end_date is null) THEN 'N' ELSE 'Y' END as In_Contract
    
    FROM    TBLCUSTOMERS     c, 
            TBLCONTRACTPLANS p,
            TBLSOCIALGRADE   s
    
    WHERE   c.plan_id   = p.id
    AND     c.nrs       = s.grade
    fetch first 3 row only;



select count(*) from TBLCUSTOMERS c
WHERE c.contract_end_date is not null;


select count(*) from dw_dimtblCustomer  
WHERE Out_of_Contract = 'Y';