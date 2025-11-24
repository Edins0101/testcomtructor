-- ============================================
-- Pregunta 2
-- ============================================

-- Tabla: product
CREATE TABLE product (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    category VARCHAR(100)
);


-- Tabla: product_detail
CREATE TABLE product_detail (
    id SERIAL PRIMARY KEY,
    product_id INT NOT NULL,
    description TEXT,
    specs JSONB,
    CONSTRAINT fk_product_detail_product
        FOREIGN KEY (product_id)
        REFERENCES product (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Tabla: quotes
CREATE TABLE quotes (
    id SERIAL PRIMARY KEY,
    items INT NOT NULL DEFAULT 0,
    total NUMERIC(10,2) NOT NULL DEFAULT 0,
    status VARCHAR(50) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Trigger pa' actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_quotes_updated_at
BEFORE UPDATE ON quotes
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Tabla: quote_items
CREATE TABLE quote_items (
    id SERIAL PRIMARY KEY,
    quote_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,
    CONSTRAINT fk_quote_items_quote
        FOREIGN KEY (quote_id)
        REFERENCES quotes (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_quote_items_product
        FOREIGN KEY (product_id)
        REFERENCES product (id)
        ON UPDATE CASCADE
);

-- Insert products

INSERT INTO product (id, name, price, stock, category) VALUES
(1, 'Cemento X', 8.50, 5, 'Construcción'),
(2, 'Pintura Blanca 20L', 35.00, 0, 'Pinturas'),
(3, 'Bloque de Hormigón', 0.80, 200, 'Construcción');


-- ============================================
-- Pregunta 4
-- ============================================

CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

ALTER TABLE quotes
ADD COLUMN project_id INT NULL,
ADD COLUMN customer_impact VARCHAR(20) NOT NULL DEFAULT 'standard', -- vip, standard, internal, etc.
ADD COLUMN expires_at TIMESTAMP NOT NULL DEFAULT (NOW() + INTERVAL '7 days'); -- por defecto 7 días

ALTER TABLE quotes
ADD CONSTRAINT fk_quotes_project
FOREIGN KEY (project_id)
REFERENCES projects (id)
ON UPDATE CASCADE
ON DELETE SET NULL;
