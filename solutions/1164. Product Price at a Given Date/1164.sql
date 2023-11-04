WITH
  ProductToNewPrice AS (
    SELECT
      product_id,
      new_price,
      ROW_NUMBER() OVER(
        PARTITION BY product_id
        ORDER BY change_date DESC
      ) AS `row_number`
    FROM Products
    WHERE change_date <= '2019-08-16'
  ),
  ProductToLatestPrice AS (
    SELECT product_id, new_price
    FROM ProductToNewPrice
    WHERE `row_number` = 1
  )
SELECT
  Products.product_id,
  IFNULL(ProductToLatestPrice.new_price, 10) AS price
FROM Products
LEFT JOIN ProductToLatestPrice
  USING (product_id)
GROUP BY 1;
