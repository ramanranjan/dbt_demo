Add Seeds

### Summary
Add `sales_dates.csv` as a `seed` to better track orders during sales.

### Details
Added `sales_dates.csv` to `/seeds` directory
* Use as a `ref` in `orders` `mart` 

Updated `dbt_project.yml`
* Added new config section for `seeds`

Added `created_at_dt` to `stg_tech_store__orders`
   
### Checks
- [x] Follows style guide
- [x] Tested changes

### References
[dbt Seeds](https://docs.getdbt.com/docs/build/seeds)
