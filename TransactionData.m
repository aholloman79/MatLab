% Step 1: Define the Product Class
% I created a class to represent a product being sold on Amazon.
% This structure helps in managing product details like name, category, price, and stock.

classdef Product
    properties
        ProductID % A unique identifier for each product.
        Name % The name of the product for clear identification.
        Category % Product category like 'Electronics' or 'Accessories'.
        Price % The price of the product.
        Stock % The available stock for the product.
    end

    methods
        function obj = Product(productID, name, category, price, stock)
            % I used this constructor to initialize product details.
            obj.ProductID = productID;
            obj.Name = name;
            obj.Category = category;
            obj.Price = price;
            obj.Stock = stock;
        end
    end
end

% Step 2: Define the Order Class
% This class handles customer orders and calculates the total amount for each order.

classdef Order
    properties
        OrderID % Unique identifier for the order.
        CustomerID % Links the order to a specific customer.
        ProductID % Identifies the product purchased in the order.
        Quantity % Number of units purchased.
        TotalAmount % The calculated total cost of the order.
    end

    methods
        function obj = Order(orderID, customerID, productID, quantity, price)
            % I used this constructor to initialize order details.
            obj.OrderID = orderID;
            obj.CustomerID = customerID;
            obj.ProductID = productID;
            obj.Quantity = quantity;
            obj.TotalAmount = quantity * price; % Calculate the total cost.
        end
    end
end

% Step 3: Define the Inventory Management Class
% This class handles inventory operations like adding products, checking stock, and updating stock.

classdef Inventory < handle
    properties
        Products % A cell array to store the list of products in the inventory.
    end

    methods
        function obj = Inventory()
            % I initialized an empty inventory to start with.
            obj.Products = {};
        end

        function addProduct(obj, product)
            % I used this method to add a new product to the inventory.
            obj.Products{end + 1} = product;
        end

        function stock = checkStock(obj, productID)
            % This method checks the stock for a specific product.
            for i = 1:length(obj.Products)
                if obj.Products{i}.ProductID == productID
                    stock = obj.Products{i}.Stock;
                    return;
                end
            end
            error('Product not found.'); % Throws an error if the product isn't in the inventory.
        end

        function updateStock(obj, productID, quantitySold)
            % This method updates the stock after a product is sold.
            for i = 1:length(obj.Products)
                if obj.Products{i}.ProductID == productID
                    obj.Products{i}.Stock = obj.Products{i}.Stock - quantitySold;
                    return;
                end
            end
            error('Product not found.'); % Throws an error if the product isn't in the inventory.
        end
    end
end

% Step 4: Create Inventory and Add Products
% I simulated an inventory with sample products to represent an Amazon seller's catalog.

% Create an instance of the Inventory class
myInventory = Inventory();

% Add products to the inventory
myInventory.addProduct(Product(1, 'Wireless Mouse', 'Electronics', 25.99, 100));
myInventory.addProduct(Product(2, 'Gaming Keyboard', 'Electronics', 75.49, 50));
myInventory.addProduct(Product(3, 'Noise Cancelling Headphones', 'Electronics', 125.00, 30));
myInventory.addProduct(Product(4, 'Portable Charger', 'Accessories', 19.99, 200));
myInventory.addProduct(Product(5, 'Smartphone Tripod', 'Accessories', 15.99, 150));

% Step 5: Create and Process Orders
% I simulated customer orders and updated the inventory based on the purchases.

% Create sample orders
order1 = Order(101, 1001, 1, 2, 25.99); % Order for 2 Wireless Mice
order2 = Order(102, 1002, 3, 1, 125.00); % Order for 1 Headphone
order3 = Order(103, 1003, 4, 5, 19.99); % Order for 5 Portable Chargers

% Process the orders and update inventory
myInventory.updateStock(order1.ProductID, order1.Quantity);
myInventory.updateStock(order2.ProductID, order2.Quantity);
myInventory.updateStock(order3.ProductID, order3.Quantity);

% Step 6: Display Updated Inventory
% I displayed the updated inventory to verify the stock changes after processing the orders.

disp('Updated Inventory:');
for i = 1:length(myInventory.Products)
    product = myInventory.Products{i};
    fprintf('Product: %s, Stock Remaining: %d\n', product.Name, product.Stock);
end
