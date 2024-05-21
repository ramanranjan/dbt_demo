Add Sources and Staging Models

### Summary
Add initial `sources` and `staging` models 

### Details
* Added the following `staging/` models based on the source system
   * **payment_app**
      * `stg_payment_app__transactions`
   * **tech_store**
      * `stg_tech_store__cities`
      * `stg_tech_store__customers`
      * `stg_tech_store__employees`
      * `stg_tech_store__orders`
      * `stg_tech_store__products`
      * `stg_tech_store__states`
      * `stg_tech_store__zip_codes`

### Checks
- [x] Follows style guide
- [x] Tested changes

### References
* [Source Properties](https://docs.getdbt.com/reference/source-properties)
* [Model Properties](https://docs.getdbt.com/reference/model-properties)
