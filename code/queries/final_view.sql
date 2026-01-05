
create or replace view fmcg.gold.vw_fact_orders_enriched as
(
  select 
  fo.date,
  fo.product_code,
  fo.customer_code,

  --date attributes
  dd.date_key,
  dd.year,
  dd.month_name,
  dd.month_short_name,
  dd.quarter,
  dd.year_quarter,

  --customer attributes
  dc.customer,
  dc.market,
  dc.platform,
  dc.channel,

  --product attributes
  dp.division,
  dp.category,
  dp.product,
  dp.variant,

  --metrics
  fo.sold_quantity,
  gp.price_inr,

  --derived metric: Amount
  (fo.sold_quantity * gp.price_inr) as total_amount_inr

  from fmcg.gold.fact_orders fo
  LEFT JOIN fmcg.gold.dim_date dd ON fo.date = dd.month_start_date
  LEFT JOIN fmcg.gold.dim_customers dc ON dc.customer_code = fo.customer_code
  LEFT JOIN fmcg.gold.dim_products dp ON dp.product_code = fo.product_code

  LEFT JOIN fmcg.gold.dim_gross_price gp 
  ON gp.product_code = fo.product_code AND YEAR(fo.date) = gp.year
);

select * from fmcg.gold.vw_fact_orders_enriched;


