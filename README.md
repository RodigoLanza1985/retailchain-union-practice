# RetailChain — Práctica de UNION y UNION ALL

**Autor:** Rodrigo Lanza  
**Fecha:** 15/10/2026

## Objetivo

Combinar el inventario de dos sucursales utilizando `UNION` y `UNION ALL`, y comparar los resultados según la necesidad del negocio: generar un catálogo unificado o conservar todos los registros para una auditoría de stock.

## Archivos

- `schema.sql`: crea las tablas y carga los datos de ambas sucursales.
- `soluciones.sql`: contiene las consultas con `UNION`, `UNION ALL` y los conteos comparativos.

## Cómo ejecutar

Ejecutá primero `schema.sql` para crear las tablas y cargar los datos. Después ejecutá `soluciones.sql`.

El script utiliza sintaxis compatible con motores SQL habituales como SQLite y PostgreSQL. Si utilizás otro motor, puede ser necesario adaptar algún detalle de sintaxis.

## 1. ¿Cuántas filas devuelve cada consulta y por qué?

La consulta de catálogo con `UNION` devuelve **11 filas**, mientras que la consulta de inventario con `UNION ALL` devuelve **14 filas**.

Para el catálogo seleccioné `id_producto`, `nombre_producto` y `categoria`, porque el stock puede variar entre sucursales y no es necesario para identificar el producto en este reporte.

Por ejemplo, el Monitor 4K de 27 pulgadas (ID 103) aparece en ambas sucursales. En Norte tiene 5 unidades y en Sur tiene 3. Si incluyera el stock, las filas serían distintas y `UNION` no las eliminaría. Al excluirlo de la consulta de catálogo, ambas filas coinciden y se conserva una sola.

Lo mismo ocurre con el Teclado Mecánico (ID 104) y el SSD Externo de 1 TB (ID 106). Estos tres productos explican la diferencia entre 14 registros de inventario y 11 filas del catálogo.

Las webcams tienen IDs diferentes (107 y 111). Aunque comparten nombre y categoría, se mantienen como dos filas porque sus identificadores no coinciden.

**Importante:** `UNION` elimina filas idénticas según todas las columnas seleccionadas; no identifica automáticamente productos por nombre.

## 2. ¿Por qué `UNION ALL` es más eficiente que `UNION`?

`UNION ALL` suele ser más eficiente porque concatena los resultados sin buscar ni eliminar duplicados.

`UNION`, en cambio, necesita una operación adicional para detectar filas repetidas. Según el motor de base de datos y el plan de ejecución, puede utilizar ordenamiento o estructuras de hash, lo que consume tiempo y memoria.

Por eso, elegiría `UNION ALL` cuando necesito conservar todos los registros y `UNION` cuando el objetivo requiere eliminar filas completamente duplicadas.

## 3. ¿En qué casos de negocio utilizaría cada operador?

Usaría `UNION` para:

- **Consolidar catálogos de servicios:** combinar los servicios informados por distintas áreas y quitar filas idénticas.
- **Unificar archivos de referencia:** reunir listas de códigos o categorías provenientes de distintos sistemas, eliminando registros completamente repetidos.

Usaría `UNION ALL` para:

- **Auditar transacciones:** reunir operaciones registradas por distintas cajas o canales, sin descartar movimientos.
- **Analizar ventas por sucursal:** combinar todos los registros de ventas para calcular volúmenes y estudiar el desempeño de cada local.

La elección depende de la pregunta de negocio. Un catálogo busca evitar filas duplicadas; una auditoría necesita conservar los registros para no alterar el análisis.

## 4. ¿Qué pasa si las columnas no coinciden en número o tipo?

Las consultas combinadas deben devolver la misma cantidad de columnas y respetar el orden correspondiente. Si una consulta devuelve cuatro columnas y la otra devuelve tres, el motor SQL genera un error porque las estructuras no son compatibles.

Si los tipos de datos son incompatibles, también puede producirse un error de tipos. El mensaje exacto depende del motor de base de datos. Algunos motores convierten automáticamente tipos compatibles; en otros casos, puede ser necesario utilizar `CAST`.

Por ejemplo, no corresponde combinar una columna numérica de identificadores con una columna de texto que contiene nombres de productos si ambas representan datos distintos. Antes de usar `UNION` o `UNION ALL`, hay que comprobar la estructura y el significado de las columnas.

## Conclusión

La práctica muestra que combinar tablas no consiste solamente en unir resultados, sino en decidir qué información se necesita conservar. `UNION` permite eliminar filas idénticas, mientras que `UNION ALL` conserva todos los registros y suele requerir menos procesamiento.

La decisión debe responder al objetivo del reporte y a la forma en que se define cada registro. Esta distinción es importante para obtener resultados confiables y evitar conclusiones incorrectas.
