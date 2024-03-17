/* 
    This schema aims to create four tables to manage sales, 
    inventory, and employees of 32 Flavors. Each table holds 
    a specific purpose, and the three separate tables are all
    related by the sales table.
*/
BEGIN;

DROP TABLE IF EXISTS flavor_of_ice_cream CASCADE;
DROP TABLE IF EXISTS type_of_cone CASCADE;
DROP TABLE IF EXISTS employee CASCADE;
DROP TABLE IF EXISTS employee_timesheet CASCADE;
DROP TABLE IF EXISTS sale CASCADE;


/*
    Table which holds the different flavors of ice cream all with:
    - A primary key ID for each flavor
    - The name of the flavor (unique so no repeats)
    - The quantity in stock of that flavor
    - A true/false value if the flavor is dairy free or not
*/

CREATE TABLE flavor_of_ice_cream (
    flavor_id SERIAL PRIMARY KEY,
    flavor VARCHAR(20) 
        UNIQUE 
        NOT NULL
        CHECK (flavor IN (
            'Vanilla',
            'Chocolate',
            'Strawberry',
            'Black Cherry',
            'Pistachio',
            'Mint Chocolate Chip',
            'Orange Sorbet',
            'Raspberry Cheescake'
            )),
    quantity INT 
        NOT NULL
        CHECK (quantity >= 1 AND quantity <= 20),
    dairy_free BOOLEAN 
        NOT NULL,
    cost_per_bucket DECIMAL(4,2) 
        NOT NULL
        CHECK (cost_per_bucket >= 15.00 AND cost_per_bucket <= 30.00),
    price_per_scoop DECIMAL(3,2) 
        NOT NULL
        CHECK (price_per_scoop >= 1.50 AND price_per_scoop <= 3.00)
);

/*
    Table which holds the different types of cones all with:
    - A primary key ID for each type
    - The name of the type of cone (not unique for gluten-free variants)
    - The quantity in stock of that type
    - A true/false value if the flavor is gluten-free or not
*/

CREATE TABLE type_of_cone (
    cone_id SERIAL PRIMARY KEY,
    cone VARCHAR(20) 
        NOT NULL
        CHECK (cone IN (
            'Waffle',
            'Sugar',
            'Cake'
        )),
    quantity INT 
        NOT NULL
        CHECK (quantity >= 1 AND quantity <= 15),
    gluten_free BOOLEAN 
        NOT NULL,
    cost_per_box DECIMAL(4,2)
        NOT NULL
        CHECK (cost_per_box >= 20.00 AND cost_per_box <= 40.00),
    price_per_cone DECIMAL(3,2)
        NOT NULL
        CHECK (price_per_cone >= 2.00 AND price_per_cone <= 4.00)
);


/*
    Table which holds the data for all employees of 32 flavors with:
    - A primary key ID for each employee
    - The name of each employee, unique so no employee is doubly-entered
    - The position in the shop that they serve in
    - The amount of hours they have worked
*/

CREATE TABLE employee (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(30) 
        UNIQUE 
        NOT NULL
        CHECK (name ~ '^[A-Z][A-Za-z \-]'),
    position VARCHAR(50) 
        NOT NULL
        CHECK (position IN (
            'Server',
            'Manager'
        ))
);


CREATE TABLE employee_timesheet (
    employee_id INT,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,

    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);


/*
    Table which holds the data for each sale that occurs in the shop with:
    - A primary key ID for the individual sale
    - The ID of the flavor that was purchased
    - The quantity of the flavors sold
    - The ID of the cone that was purchased
    - The quantity of the cones sold of that flavor
    - The ID of the employee that served the transaction
*/


CREATE TABLE sale (
    sale_id SERIAL PRIMARY KEY,
    flavor_id INT 
        NOT NULL,
    scoop_quantity INT 
        NOT NULL
        CHECK (scoop_quantity >= 1 AND scoop_quantity <= 3),
    cone_id INT 
        NOT NULL,
    cone_quantity INT
        NOT NULL
        CHECK (cone_quantity = 1),
    employee_id INT 
        NOT NULL,
    time_of_sale TIMESTAMP 
        NOT NULL,
    cost_of_sale DECIMAL(4,2) 
        NOT NULL,

    FOREIGN KEY (flavor_id) REFERENCES flavor_of_ice_cream(flavor_id),
    FOREIGN KEY (cone_id) REFERENCES type_of_cone(cone_id),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);


\COPY flavor_of_ice_cream FROM './data/buckets_of_ice_cream.csv' CSV HEADER;
\COPY type_of_cone FROM './data/boxes_of_cones.csv' CSV HEADER;
\COPY employee FROM './data/employees.csv' CSV HEADER;
\COPY employee_timesheet FROM './data/timesheets.csv' CSV HEADER;
\COPY sale FROM './data/sales.csv' CSV HEADER;


COMMIT;