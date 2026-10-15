-- ==================================================
-- RetailChain - UNION y UNION ALL
-- Autor: Rodrigo Lanza
-- Fecha: 15/10/2026
-- ==================================================

-- CONSULTA 1: UNION
-- Catálogo unificado de productos.
-- Se excluye stock porque puede variar entre sucursales.
-- UNION elimina filas completamente duplicadas en las columnas seleccionadas.

SELECT
    id_producto,
    nombre_producto,
    categoria
FROM inventario_sucursal_norte

UNION

SELECT
    id_producto,
    nombre_producto,
    categoria
FROM inventario_sucursal_sur

ORDER BY id_producto;


-- CONSULTA 2: UNION ALL
-- Auditoría de inventario: conserva todos los registros,
-- incluyendo productos presentes en ambas sucursales.

SELECT
    id_producto,
    nombre_producto,
    categoria,
    stock
FROM inventario_sucursal_norte

UNION ALL

SELECT
    id_producto,
    nombre_producto,
    categoria,
    stock
FROM inventario_sucursal_sur

ORDER BY id_producto;


-- CONSULTA 3: COMPARACIÓN DE RESULTADOS

SELECT COUNT(*) AS filas_union
FROM (
    SELECT id_producto, nombre_producto, categoria
    FROM inventario_sucursal_norte

    UNION

    SELECT id_producto, nombre_producto, categoria
    FROM inventario_sucursal_sur
) AS resultado_union;


SELECT COUNT(*) AS filas_union_all
FROM (
    SELECT id_producto, nombre_producto, categoria, stock
    FROM inventario_sucursal_norte

    UNION ALL

    SELECT id_producto, nombre_producto, categoria, stock
    FROM inventario_sucursal_sur
) AS resultado_union_all;
