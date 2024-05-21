Add Tests

### Summary
Add test to enhance data quality of the project.

### Details
- Added `not null` and `unique` tests to primary keys
- Added `accepted_values` test to `stg_tech_store__products`
- Created a new singular test to validate no-negative quantity values
- Created a custom generic test to validate non-negative values

### Checks
- [x] Follows style guide
- [x] Tested changes

### References
[Tests](https://docs.getdbt.com/docs/building-a-dbt-project/tests)