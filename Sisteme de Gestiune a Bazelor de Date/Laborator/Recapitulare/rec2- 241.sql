select * from member; --101 -> 109

select * from title; --92 -> 98

select * from title_copy; 

2	92	AVAILABLE
1	93	AVAILABLE
2	93	AVAILABLE
1	94	AVAILABLE
1	95	AVAILABLE
2	95	RENTED
3	95	RENTED

select * from rental
order by 3,4,2;

--Câte filme (titluri, respectiv exemplare) au fost împrumutate din cea mai cerutã categorie?


select t.category, r.copy_id, r.title_id
from rental r, title t
where r.title_id = t. title_id
order by r.title_id, r.copy_id;


--cate exemplare au fost imprumutate din fiecare categorie

select t.category "Categorie", count(*) "Numar"
from rental r, title t
where r.title_id = t. title_id
group by t.category
order by 2 desc;

select t.category, count(*)
from rental r, title t
where r.title_id = t. title_id
group by t.CATEGORY;

--cea mai ceruta categorie( in functie de numarul de exemplare imprumutate)
select t.category "Categorie", count(*) "Numar de exemplare", count( unique r.title_id) Numar_de_titluri
from rental r, title t
where r.title_id = t. title_id
group by t.category
having count(*) = (select max( count(*) )
                  from rental r, title t
                  where r.title_id = t. title_id
                  group by t.category);

select t.category, count(*) nr_total_exemplare, count(distinct r.title_id) nr_titluri
from rental r, title t
where r.title_id = t. title_id
group by t.CATEGORY
having count(*) = (select max(count(*))
                    from rental r, title t
                    where r.title_id = t. title_id
                    group by t.CATEGORY);
                    
                    
 5. Câte exemplare din fiecare film sunt disponibile în prezent 
 (considera?i cã statusul unui exemplar nu este setat, deci nu poate fi utilizat)?                   
/
select * from title_copy order by 2, 1;

select * from rental;

--care sunt exemplarele imprumutate pentru fiecare film

select title_id,copy_id
from rental
where act_ret_date is null;

--exemplarele inchiriate si deja returnate
select title_id,copy_id
from rental
where act_ret_date is not null;

select title_id
from title_copy
minus
select title_id
from rental
where act_ret_date is null;  -- filmele pentru care  s-au returnat  toate exemplarele

--care sunt exemplarele disponibile pentru fiecare film

select title_id,copy_id
from title_copy
minus
select title_id,copy_id
from rental
where act_ret_date is null;--6

select title_id,copy_id
from title_copy
where (title_id,copy_id) not in (select title_id,copy_id
                                  from rental
                                  where act_ret_date is null);

--rezolvare:
select aux.title_id, count(aux.copy_id) Nr_exemplare_disponibile
from (select title_id,copy_id
      from title_copy
      minus
      select title_id,copy_id
      from rental
      where act_ret_date is null) aux
group by aux.title_id;


SELECT TITLE_ID, count(COPY_ID)
FROM TITLE_COPY
WHERE (TITLE_ID,COPY_ID) NOT IN (SELECT TITLE_ID, COPY_ID
                                FROM RENTAL
                                WHERE ACT_RET_DATE IS NULL)
group by TITLE_ID;

6. Afi?a?i urmãtoarele informa?ii: titlul filmului, numãrul exemplarului, 
statusul setat ?i statusul corect.
--daca un film nu este imprumutatt, atunci consideram ca el este disponibil

select * from title_copy order by 2, 1; -- 12

select * from rental;--14 rez
--PB: acelasi exemplar cu doua statusuri diferite  ---nu
SELECT title_id, TITLE, COPY_ID, STATUS,
CASE
WHEN ACT_RET_DATE IS NULL THEN 'RENTED'
WHEN ACT_RET_DATE IS NOT NULL THEN 'AVAILABLE'
END "STATUS CORECT"
FROM TITLE_COPY JOIN RENTAL USING (COPY_ID, TITLE_ID) JOIN TITLE USING (TITLE_ID); 


--nu join incomplet
select t.title,tc.copy_id,tc.status,r.copy_id,
case when
(r.act_ret_date is null) then 'rented'
else 'available'
end as "Correct status"
from title t join title_copy tc on (t.title_id=tc.title_id)
join rental r on (tc.title_id=r.title_id);

--nu
SELECT UNIQUE title, copy_id, status, avabilitate_reala
              FROM (SELECT *
              FROM RENTAL r JOIN (SELECT 'AVAILABLE' AS avabilitate_reala FROM DUAL)
              ON r.act_ret_date IS NOT NULL 
              AND (r.title_id, r.copy_id) NOT IN(SELECT title_id, copy_id
                                                FROM RENTAL
                                                WHERE r.act_ret_date IS NULL)
              
              UNION
              SELECT *
              FROM RENTAL ar JOIN (SELECT 'RENTED' AS avabilitate_reala FROM DUAL) 
              ON ar.act_ret_date IS NULL
              ) af
JOIN (SELECT tb.title_id, tb.title, status
FROM TITLE tb JOIN (SELECT title_id, status FROM TITLE_COPY) tc 
ON tb.title_id = tc.title_id
) te ON te.title_id = af.title_id;


--da
select t.title, c.copy_id,status status_setat,
CASE
    WHEN (t.title_id, c.copy_id) IN (select r.title_id, r.copy_id
                                from rental r
                                where r.act_ret_date is NULL)
    THEN 'RENTED'
    ELSE 'AVAILABLE'
  END AS STATUS_corect
from title_copy c, title t
where c.title_id = t.title_id;

--nu
select distinct t.title,tc.copy_id,tc.status, r.copy_id, tc.copy_id,
        CASE WHEN r.act_ret_date is NULL THEN 'RENTED'
        ELSE 'AVAILABLE' END AS "REAL STATUS"
from title t join title_copy tc on (t.title_id=tc.title_id)
join rental r on (tc.title_id=r.title_id)
where r.copy_id = tc.copy_id;

--da
select t.title,t.title_id, tc.copy_id,tc.status  status_setat,
        case when (t.title_id, tc.copy_id ) not in (select title_id,copy_id
                                                from rental
                                                where act_ret_date is null)
        then 'Available'
        else 'Rented'
        end status_corect
from title t join title_copy tc on (t.title_id=tc.title_id)
order by 1,2;

select * from rental
where TITLE_ID=93 and copy_id =1;

--9. De câte ori a împrumutat un membru (nume ?i prenume) fiecare film (titlu)?
--R:
select * from(
select m.first_name||' '||m.last_name"Name",m.title,count(r.title_id)
from  rental r, (select member_id, last_name, first_name, title_id, title
                  from member, title) m
where (m.member_id=r.member_id(+))  --iau in calcul si membrii care nu au imprumutat niciun film
and  (r.title_id(+)=m.title_id)  --iau in calcul si faptul ca filmul nu a fost imprumutatt de o anumita persana
group by m.first_name||' '||m.last_name,m.title)
order by 1;

tema ext 7+8+10

--verificare
select * from rental r, member m
where upper(last_name) =upper('Velasquez')
and m.member_id = r.member_id;


--SELECT last_name, first_name, t.title, COUNT(r.copy_id) nr_imprumutari
--FROM member m JOIN rental r ON (m.member_id=r.member_id)
--JOIN title_copy tc ON (r.title_id=tc.title_id)
--JOIN title t ON (t.title_id=tc.title_id)
--WHERE r.copy_id=tc.copy_id
--GROUP BY m.last_name, m.first_name, t.title;

9'       