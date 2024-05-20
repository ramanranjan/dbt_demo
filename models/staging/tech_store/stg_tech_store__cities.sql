with cities as (
    select * from {{source('tech_store','city')}}
),

cities_renamed as (
    select id as City_Id,
    name as City_Name,
    stateid as State_Id,
    zipid as Zip_Code_Id
    from cities
)

select * from cities_renamed