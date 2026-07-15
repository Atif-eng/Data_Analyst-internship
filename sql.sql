SELECT 
    OrderID, 
    Date, 
    Product, 
    TotalPrice 
FROM orders 
WHERE OrderStatus = 'Delivered' 
ORDER BY TotalPrice DESC 
LIMIT 5;


SELECT 
    Product, 
    COUNT(OrderID) AS Total_Orders, 
    ROUND(SUM(TotalPrice), 2) AS Total_Revenue 
FROM orders 
GROUP BY Product 
ORDER BY Total_Revenue DESC;

SELECT 
    ReferralSource, 
    COUNT(OrderID) AS Total_Successful_Orders,
    ROUND(AVG(TotalPrice), 2) AS Avg_Order_Value, 
    ROUND(AVG(Quantity), 2) AS Avg_Items_Purchased
FROM orders 
WHERE OrderStatus NOT IN ('Cancelled', 'Returned')
GROUP BY ReferralSource 
ORDER BY Avg_Order_Value DESC;

SELECT 
    PaymentMethod, 
    COUNT(OrderID) AS Total_Orders,
    SUM(CASE WHEN OrderStatus IN ('Cancelled', 'Returned') THEN 1 ELSE 0 END) AS Failed_Orders,
    ROUND(CAST(SUM(CASE WHEN OrderStatus IN ('Cancelled', 'Returned') THEN 1 ELSE 0 END) AS FLOAT) / COUNT(OrderID) * 100, 2) AS Failure_Rate_Pct
FROM orders 
GROUP BY PaymentMethod
ORDER BY Failure_Rate_Pct DESC;