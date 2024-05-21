### Summary
Add 2 new `marts` models for `customers` and `orders`

### Details
Creating more detailed `marts` models for end user Analytics.
* `customers` - Provide a full view of all `customer`-level information
* `orders` - Provide a full view of `order`-level information along with `product,` `customer` and `transaction` data

Set `+materialized: table` in `dbt_project.yml` for `marts`

### Checks
- [x] Follows style guide
- [x] Tested changes

### References
* [dbt Best Practices - Marts](https://docs.getdbt.com/guides/best-practices/how-we-structure/4-marts)