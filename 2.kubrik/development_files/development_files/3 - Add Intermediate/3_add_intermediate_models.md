Add Intermediate Models

### Summary
Add `intermediate` models to simplify `marts` logic

### Details
Added 2 `intermediate` models:
* `int_customers_and_locations_joined` - Consolidate location data for `city`, `state` and `zip` to avoid excess joins in `marts`
* `int_order_amounts_aggregated_by_customer` - Get total sales and quantities returned on the `customer` level to be joined back to `customer` model

Updated `dbt_project.yml`
* Added new model config for `intermediate` directory
   * Set `materialized` to `ephemeral` - Results do not need to be deployed to the database server
   
### Checks
- [x] Follows style guide
- [x] Tested changes

### References
[Intermediate Models](https://docs.getdbt.com/guides/best-practices/how-we-structure/3-intermediate)
