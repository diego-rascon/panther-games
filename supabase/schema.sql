
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE EXTENSION IF NOT EXISTS "pgsodium" WITH SCHEMA "pgsodium";

CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";

CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";

CREATE FUNCTION "public"."generalreportaccesoriosdate"("start_date" "date", "end_date" "date") RETURNS TABLE("venta_id" integer, "producto_id" integer, "producto_nombre" character varying, "producto_stock" integer, "producto_precio" double precision, "cantidad_vendida" integer, "total_producto" double precision)
    LANGUAGE "sql"
    AS $$
   SELECT 
    venta.venta_id,
    p.producto_id, 
    p.producto_nombre, 
    p.producto_stock, 
    venta_detalle.venta_detalle_precio/SUM(venta_detalle.venta_detalle_cantidad) AS venta_detalle_precio,
    SUM(venta_detalle.venta_detalle_cantidad) AS cantidad_vendida,
     venta_detalle.venta_detalle_precio/SUM(venta_detalle.venta_detalle_cantidad) * SUM(venta_detalle.venta_detalle_cantidad) AS total_producto
    FROM 
      producto AS p 
    INNER JOIN venta_detalle ON p.producto_id = venta_detalle.producto_id 
    INNER JOIN venta ON venta_detalle.venta_id = venta.venta_id
    WHERE p.categoria_id = 3 AND venta.venta_fecha BETWEEN start_date AND end_date AND venta.venta_activa = TRUE
    GROUP BY
      p.producto_id,
      p.producto_nombre,
      p.producto_stock,
      venta_detalle.venta_detalle_precio,
      venta.venta_id
  ORDER BY p.producto_id;
$$;

ALTER FUNCTION "public"."generalreportaccesoriosdate"("start_date" "date", "end_date" "date") OWNER TO "postgres";

CREATE FUNCTION "public"."generalreportaccesoriosonedate"("start_date" "date") RETURNS TABLE("venta_id" integer, "producto_id" integer, "producto_nombre" character varying, "producto_stock" integer, "producto_precio" double precision, "cantidad_vendida" integer, "total_producto" double precision)
    LANGUAGE "sql"
    AS $$
   SELECT 
    venta.venta_id,
    p.producto_id, 
    p.producto_nombre, 
    p.producto_stock, 
    venta_detalle.venta_detalle_precio/SUM(venta_detalle.venta_detalle_cantidad) AS venta_detalle_precio,
    SUM(venta_detalle.venta_detalle_cantidad) AS cantidad_vendida,
     venta_detalle.venta_detalle_precio/SUM(venta_detalle.venta_detalle_cantidad) * SUM(venta_detalle.venta_detalle_cantidad) AS total_producto
    FROM 
      producto AS p 
    INNER JOIN venta_detalle ON p.producto_id = venta_detalle.producto_id 
    INNER JOIN venta ON venta_detalle.venta_id = venta.venta_id
    WHERE p.categoria_id = 3 AND venta.venta_fecha = start_date AND venta.venta_activa = TRUE
    GROUP BY
      p.producto_id,
      p.producto_nombre,
      p.producto_stock,
      venta_detalle.venta_detalle_precio,
      venta.venta_id
  ORDER BY p.producto_id;
$$;

ALTER FUNCTION "public"."generalreportaccesoriosonedate"("start_date" "date") OWNER TO "postgres";

CREATE FUNCTION "public"."generalreportconsolasdate"("start_date" "date", "end_date" "date") RETURNS TABLE("venta_id" integer, "producto_id" integer, "producto_nombre" character varying, "producto_stock" integer, "producto_precio" double precision, "cantidad_vendida" integer, "total_producto" double precision)
    LANGUAGE "sql"
    AS $$
 SELECT 
    venta.venta_id,
    p.producto_id, 
    p.producto_nombre, 
    p.producto_stock, 
    venta_detalle.venta_detalle_precio AS venta_detalle_precio,
    SUM(venta_detalle.venta_detalle_cantidad) AS cantidad_vendida,
    venta_detalle.venta_detalle_precio *  SUM(venta_detalle.venta_detalle_cantidad) AS total_producto
  FROM 
    producto AS p 
  INNER JOIN venta_detalle ON p.producto_id = venta_detalle.producto_id 
  INNER JOIN venta ON venta_detalle.venta_id = venta.venta_id
  WHERE p.categoria_id = 2 AND venta.venta_fecha BETWEEN start_date AND end_date AND venta.venta_activa = TRUE
  GROUP BY
    p.producto_id,
    p.producto_nombre,
    p.producto_stock,
    venta_detalle.venta_detalle_precio,
    venta.venta_id 
ORDER BY p.producto_id;
$$;

ALTER FUNCTION "public"."generalreportconsolasdate"("start_date" "date", "end_date" "date") OWNER TO "postgres";

CREATE FUNCTION "public"."generalreportconsolasonedate"("start_date" "date") RETURNS TABLE("venta_id" integer, "producto_id" integer, "producto_nombre" character varying, "producto_stock" integer, "producto_precio" double precision, "cantidad_vendida" integer, "total_producto" double precision)
    LANGUAGE "sql"
    AS $$
 SELECT 
   venta.venta_id,
    p.producto_id, 
    p.producto_nombre, 
    p.producto_stock, 
    venta_detalle.venta_detalle_precio AS venta_detalle_precio,
    SUM(venta_detalle.venta_detalle_cantidad) AS cantidad_vendida,
    venta_detalle.venta_detalle_precio *  SUM(venta_detalle.venta_detalle_cantidad) AS total_producto
  FROM 
    producto AS p 
  INNER JOIN venta_detalle ON p.producto_id = venta_detalle.producto_id 
  INNER JOIN venta ON venta_detalle.venta_id = venta.venta_id
  WHERE p.categoria_id = 2 AND venta.venta_fecha = start_date AND venta.venta_activa = TRUE
  GROUP BY
    p.producto_id,
    p.producto_nombre,
    p.producto_stock,
    venta_detalle.venta_detalle_precio,
    venta.venta_id
ORDER BY p.producto_id;
$$;

ALTER FUNCTION "public"."generalreportconsolasonedate"("start_date" "date") OWNER TO "postgres";

CREATE FUNCTION "public"."generalreportgamesdate"("start_date" "date", "end_date" "date") RETURNS TABLE("venta_id" integer, "producto_id" integer, "producto_nombre" character varying, "plataforma_nombre" character varying, "producto_stock" integer, "producto_precio" double precision, "cantidad_vendida" integer, "total_producto" double precision, "plataforma_id" integer)
    LANGUAGE "sql"
    AS $$
SELECT 
    venta.venta_id,
    p.producto_id, 
    p.producto_nombre, 
    plataforma.plataforma_nombre,
    p.producto_stock, 
    venta_detalle.venta_detalle_precio/SUM(venta_detalle.venta_detalle_cantidad) AS venta_detalle_precio,
    SUM(venta_detalle.venta_detalle_cantidad) AS cantidad_vendida,
     venta_detalle.venta_detalle_precio/SUM(venta_detalle.venta_detalle_cantidad) * SUM(venta_detalle.venta_detalle_cantidad) AS total_producto,
    producto_plataforma.plataforma_id
  FROM 
    producto AS p 
INNER JOIN venta_detalle ON p.producto_id = venta_detalle.producto_id 
INNER JOIN venta ON venta_detalle.venta_id = venta.venta_id
INNER JOIN producto_plataforma ON p.producto_id = producto_plataforma.producto_id
INNER JOIN plataforma ON  producto_plataforma.plataforma_id = plataforma.plataforma_id
WHERE venta.venta_fecha BETWEEN start_date AND end_date AND venta.venta_activa = TRUE
GROUP BY 
    p.producto_id, 
    p.producto_nombre, 
    p.producto_stock, 
    venta_detalle.venta_detalle_precio,
    producto_plataforma.plataforma_id,
    venta.venta_id,
    plataforma.plataforma_nombre
ORDER BY producto_plataforma.plataforma_id, p.producto_id;
$$;

ALTER FUNCTION "public"."generalreportgamesdate"("start_date" "date", "end_date" "date") OWNER TO "postgres";

CREATE FUNCTION "public"."generalreportgamesonedate"("start_date" "date") RETURNS TABLE("venta_id" integer, "producto_id" integer, "producto_nombre" character varying, "plataforma_nombre" character varying, "producto_stock" integer, "producto_precio" double precision, "cantidad_vendida" integer, "total_producto" double precision, "plataforma_id" integer)
    LANGUAGE "sql"
    AS $$
   SELECT 
    venta.venta_id,
    p.producto_id, 
    p.producto_nombre, 
    plataforma.plataforma_nombre,
    p.producto_stock, 
    venta_detalle.venta_detalle_precio/SUM(venta_detalle.venta_detalle_cantidad) AS venta_detalle_precio,
    SUM(venta_detalle.venta_detalle_cantidad) AS cantidad_vendida,
     venta_detalle.venta_detalle_precio/SUM(venta_detalle.venta_detalle_cantidad) * SUM(venta_detalle.venta_detalle_cantidad) AS total_producto,
    producto_plataforma.plataforma_id
  FROM 
    producto AS p
INNER JOIN venta_detalle ON p.producto_id = venta_detalle.producto_id 
INNER JOIN venta ON venta_detalle.venta_id = venta.venta_id
INNER JOIN producto_plataforma ON p.producto_id = producto_plataforma.producto_id
INNER JOIN plataforma ON  producto_plataforma.plataforma_id = plataforma.plataforma_id
WHERE venta.venta_fecha = start_date AND venta.venta_activa = TRUE
GROUP BY 
    p.producto_id, 
    p.producto_nombre, 
    p.producto_stock, 
    venta_detalle.venta_detalle_precio,
    producto_plataforma.plataforma_id,
    venta.venta_id,
    plataforma.plataforma_nombre
ORDER BY producto_plataforma.plataforma_id, p.producto_id;
$$;

ALTER FUNCTION "public"."generalreportgamesonedate"("start_date" "date") OWNER TO "postgres";

CREATE FUNCTION "public"."generalreportrentscarddate"("start_date" "date", "end_date" "date") RETURNS TABLE("cantidad_rentas" integer, "total_rentas" double precision)
    LANGUAGE "sql"
    AS $$
  SELECT 
    COUNT(renta_id) AS cantidad_rentas,
    COALESCE(SUM(renta_monto), 0) AS total_rentas
  FROM 
    renta
  WHERE renta_fecha_inicio BETWEEN start_date AND end_date AND renta_activa=true  AND renta_tarjeta = true;
$$;

ALTER FUNCTION "public"."generalreportrentscarddate"("start_date" "date", "end_date" "date") OWNER TO "postgres";

CREATE FUNCTION "public"."generalreportrentscardonedate"("start_date" "date") RETURNS TABLE("cantidad_rentas" integer, "total_rentas" double precision)
    LANGUAGE "sql"
    AS $$
SELECT 
    COUNT(renta_id) AS cantidad_rentas,
    COALESCE(SUM(renta_monto), 0) AS total_rentas
  FROM 
    renta
  WHERE renta_fecha_inicio = start_date AND renta_activa=true AND renta_tarjeta = true ;
$$;

ALTER FUNCTION "public"."generalreportrentscardonedate"("start_date" "date") OWNER TO "postgres";

CREATE FUNCTION "public"."generalreportrentsdate"("start_date" "date", "end_date" "date") RETURNS TABLE("cantidad_rentas" integer, "total_rentas" double precision)
    LANGUAGE "sql"
    AS $$
  SELECT 
    COUNT(renta_id) AS cantidad_rentas,
    COALESCE(SUM(renta_monto),0) AS total_rentas
  FROM 
    renta
  WHERE renta_fecha_inicio BETWEEN start_date AND end_date AND renta_activa=true;
$$;

ALTER FUNCTION "public"."generalreportrentsdate"("start_date" "date", "end_date" "date") OWNER TO "postgres";

CREATE FUNCTION "public"."generalreportrentsonedate"("start_date" "date") RETURNS TABLE("cantidad_rentas" integer, "total_rentas" double precision)
    LANGUAGE "sql"
    AS $$
  SELECT 
    COUNT(renta_id) AS cantidad_rentas,
    COALESCE(SUM(renta_monto),0) AS total_rentas
  FROM 
    renta
  WHERE renta_fecha_inicio = start_date AND renta_activa=true;
$$;

ALTER FUNCTION "public"."generalreportrentsonedate"("start_date" "date") OWNER TO "postgres";

CREATE FUNCTION "public"."generalreportventadate"("start_date" "date", "end_date" "date") RETURNS TABLE("cantidad_ventas" integer, "total_ventas" double precision)
    LANGUAGE "sql"
    AS $$
  SELECT 
    COUNT(venta_id) AS cantidad_ventas,
    COALESCE(SUM(venta_monto),0) AS total_ventas
  FROM 
    venta
  WHERE venta_fecha BETWEEN start_date AND end_date AND venta_activa =TRUE
$$;

ALTER FUNCTION "public"."generalreportventadate"("start_date" "date", "end_date" "date") OWNER TO "postgres";

CREATE FUNCTION "public"."generalreportventaonedate"("start_date" "date") RETURNS TABLE("cantidad_ventas" integer, "total_ventas" double precision)
    LANGUAGE "sql"
    AS $$
  SELECT 
    COUNT(venta_id) AS cantidad_ventas,
    COALESCE(SUM(venta_monto),0) AS total_ventas
  FROM 
    venta
  WHERE venta_fecha = start_date AND venta_activa = TRUE
$$;

ALTER FUNCTION "public"."generalreportventaonedate"("start_date" "date") OWNER TO "postgres";

CREATE FUNCTION "public"."get_clients"() RETURNS TABLE("cliente_id" integer, "cliente_nombre" character varying, "cliente_email" character varying, "cliente_telefono" character varying, "cliente_activo" boolean, "cliente_miembro" boolean)
    LANGUAGE "sql"
    AS $$
SELECT
  cliente.cliente_id,
  cliente.cliente_nombre,
  cliente.cliente_email,
  cliente.cliente_telefono,
  cliente.cliente_activo,
  CASE WHEN miembro.cliente_id IS NULL THEN FALSE ELSE TRUE END AS cliente_miembro
FROM
  cliente
  LEFT JOIN miembro ON cliente.cliente_id = miembro.cliente_id;
$$;

ALTER FUNCTION "public"."get_clients"() OWNER TO "postgres";

CREATE FUNCTION "public"."get_clients_members"() RETURNS TABLE("miembro_id" integer, "cliente_id" integer, "cliente_nombre" character varying, "cliente_email" character varying, "cliente_telefono" character varying, "miembro_fecha_inicio" "date", "miembro_fecha_final" "date", "miembro_compras" integer, "miembro_rentas" integer, "cliente_activo" boolean, "miembro_activo" boolean)
    LANGUAGE "sql"
    AS $$
  select miembro.miembro_id, cliente.cliente_id, cliente.cliente_nombre, cliente.cliente_email, cliente.cliente_telefono, miembro.miembro_fecha_inicio, miembro.miembro_fecha_final, miembro.miembro_compras, miembro.miembro_rentas, cliente.cliente_activo, miembro.miembro_activo from miembro, cliente
  where cliente.cliente_id = miembro.cliente_id;
$$;

ALTER FUNCTION "public"."get_clients_members"() OWNER TO "postgres";

CREATE FUNCTION "public"."get_rent_details"("input_id" integer) RETURNS TABLE("producto_nombre" character varying)
    LANGUAGE "sql"
    AS $$
  SELECT producto_nombre
  FROM producto AS p
  JOIN renta_detalle rd ON rd.producto_id = p.producto_id
  JOIN renta r ON r.renta_id = rd.renta_id
  WHERE r.renta_id = input_id;
$$;

ALTER FUNCTION "public"."get_rent_details"("input_id" integer) OWNER TO "postgres";

CREATE FUNCTION "public"."get_sale_details"("input_id" integer) RETURNS TABLE("producto_nombre" character varying, "categoria_nombre" character varying, "plataforma_nombre" character varying, "venta_detalle_cantidad" integer, "producto_precio" integer)
    LANGUAGE "sql"
    AS $$
  SELECT p.producto_nombre, c.categoria_nombre, pl.plataforma_nombre, vd.venta_detalle_cantidad, p.producto_precio
  FROM venta_detalle vd
  INNER JOIN producto p ON vd.producto_id = p.producto_id
  INNER JOIN categoria c ON c.categoria_id = p.categoria_id
  LEFT JOIN producto_plataforma pp ON pp.producto_id = p.producto_id
  LEFT JOIN plataforma pl ON pl.plataforma_id = pp.plataforma_id
  WHERE vd.venta_id = input_id;
$$;

ALTER FUNCTION "public"."get_sale_details"("input_id" integer) OWNER TO "postgres";

CREATE FUNCTION "public"."get_total"() RETURNS TABLE("total" double precision, "quantity" integer)
    LANGUAGE "sql"
    AS $$
  select sum(producto.producto_precio*carrito.producto_cantidad) as total, sum(carrito.producto_cantidad) as quantity
  from producto
  join carrito on producto.producto_id = carrito.producto_id;
$$;

ALTER FUNCTION "public"."get_total"() OWNER TO "postgres";

CREATE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
begin
  insert into public.profiles (id, full_name, avatar_url)
  values (new.id, new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'avatar_url');
  return new;
end;
$$;

ALTER FUNCTION "public"."handle_new_user"() OWNER TO "postgres";

CREATE FUNCTION "public"."products_cart"() RETURNS TABLE("carrito_id" integer, "producto_id" integer, "categoria_id" integer, "plataforma_id" integer, "categoria_nombre" character varying, "producto_nombre" character varying, "plataforma_nombre" character varying, "producto_nuevo" boolean, "producto_precio" double precision, "producto_stock" integer, "producto_minimo" integer, "producto_cantidad" integer)
    LANGUAGE "sql"
    AS $$
  select carrito.carrito_id, producto.producto_id, producto.categoria_id, plataforma.plataforma_id, categoria.categoria_nombre, producto.producto_nombre, plataforma.plataforma_nombre, producto.producto_nuevo, producto.producto_precio, producto.producto_stock, producto.producto_minimo, carrito.producto_cantidad
  from producto
  join carrito on producto.producto_id = carrito.producto_id
  join categoria on producto.categoria_id = categoria.categoria_id
  left join producto_plataforma ON producto.producto_id = producto_plataforma.producto_id
  left join plataforma ON producto_plataforma.plataforma_id = plataforma.plataforma_id
  order by carrito_id desc;
$$;

ALTER FUNCTION "public"."products_cart"() OWNER TO "postgres";

CREATE FUNCTION "public"."products_platforms"() RETURNS TABLE("producto_id" integer, "categoria_id" integer, "producto_activo" boolean, "producto_nombre" character varying, "producto_nuevo" boolean, "producto_precio" double precision, "producto_stock" integer, "producto_minimo" integer, "plataforma_id" integer, "plataforma_nombre" character varying, "on_cart" boolean)
    LANGUAGE "sql"
    AS $$
  SELECT producto.producto_id, producto.categoria_id, producto.producto_activo, producto.producto_nombre, producto.producto_nuevo, producto.producto_precio, producto.producto_stock, producto.producto_minimo, plataforma.plataforma_id, plataforma_nombre, carrito.carrito_id IS NOT NULL AS on_cart
  FROM producto
  LEFT JOIN producto_plataforma ON producto.producto_id = producto_plataforma.producto_id
  LEFT JOIN plataforma ON producto_plataforma.plataforma_id = plataforma.plataforma_id
  LEFT JOIN carrito ON carrito.producto_id = producto.producto_id;
$$;

ALTER FUNCTION "public"."products_platforms"() OWNER TO "postgres";

CREATE FUNCTION "public"."register_sale"("input_cliente_id" integer, "input_descuento" integer, "input_venta_tarjeta" boolean) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    venta_id int;
    cart_item RECORD;
    producto_precio float;
BEGIN
    -- Insert new record into venta table, with total from shopping cart
    INSERT INTO venta (venta_monto, venta_cantidad, venta_descuento, venta_tarjeta, venta_fecha, cliente_id)
    VALUES ((SELECT total FROM get_total()), (SELECT quantity FROM get_total()), input_descuento, input_venta_tarjeta, now() AT TIME ZONE 'America/Hermosillo', input_cliente_id)
    RETURNING venta.venta_id INTO venta_id;

    -- Insert all records from carrito table into venta_detalle table, and update stock of each product
    FOR cart_item IN SELECT producto_id, producto_cantidad FROM carrito
    LOOP
        INSERT INTO venta_detalle (venta_id, producto_id, venta_detalle_cantidad, venta_detalle_precio)
        SELECT venta_id, cart_item.producto_id, cart_item.producto_cantidad, producto.producto_precio * cart_item.producto_cantidad
        FROM producto
        JOIN carrito ON producto.producto_id = carrito.producto_id
        WHERE producto.producto_id = cart_item.producto_id;

        UPDATE producto SET producto_stock = producto_stock - cart_item.producto_cantidad WHERE producto_id = cart_item.producto_id;
    END LOOP;
END;
$$;

ALTER FUNCTION "public"."register_sale"("input_cliente_id" integer, "input_descuento" integer, "input_venta_tarjeta" boolean) OWNER TO "postgres";

CREATE FUNCTION "public"."ventatarjetadate"("start_date" "date", "end_date" "date") RETURNS TABLE("cantidad_ventas" integer, "total_ventas" double precision)
    LANGUAGE "sql"
    AS $$
  SELECT 
    COUNT(venta_id) AS cantidad_ventas,
    COALESCE(SUM(venta_monto),0) AS total_ventas
  FROM 
    venta
  WHERE venta_fecha BETWEEN start_date AND end_date AND venta_tarjeta = true AND venta_activa = true;
$$;

ALTER FUNCTION "public"."ventatarjetadate"("start_date" "date", "end_date" "date") OWNER TO "postgres";

CREATE FUNCTION "public"."ventatarjetaonedate"("start_date" "date") RETURNS TABLE("cantidad_ventas" integer, "total_ventas" double precision)
    LANGUAGE "sql"
    AS $$
  SELECT 
    COUNT(venta_id) AS cantidad_ventas,
    COALESCE(SUM(venta_monto),0) AS total_ventas
  FROM 
    venta
  WHERE venta_fecha = start_date AND venta_tarjeta = true AND venta_activa = true;
$$;

ALTER FUNCTION "public"."ventatarjetaonedate"("start_date" "date") OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";

CREATE TABLE "public"."apartado" (
    "apartado_id" bigint NOT NULL,
    "cliente_id" bigint NOT NULL,
    "apartado_monto_actual" double precision NOT NULL,
    "apartado_monto_final" double precision NOT NULL,
    "apartado_fecha_inicio" "date" NOT NULL,
    "apartado_fecha_final" "date" NOT NULL,
    "usuario_id" bigint NOT NULL
);

ALTER TABLE "public"."apartado" OWNER TO "postgres";

ALTER TABLE "public"."apartado" ALTER COLUMN "apartado_id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."Apartado_apartado_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE "public"."caja" (
    "caja_id" bigint NOT NULL,
    "caja_total" double precision NOT NULL,
    "caja_fondo_inicio" double precision NOT NULL,
    "caja_fecha" "date" NOT NULL,
    "caja_activo" boolean DEFAULT true NOT NULL
);

ALTER TABLE "public"."caja" OWNER TO "postgres";

ALTER TABLE "public"."caja" ALTER COLUMN "caja_id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."caja_caja_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE "public"."carrito" (
    "carrito_id" bigint NOT NULL,
    "producto_id" bigint NOT NULL,
    "producto_cantidad" smallint DEFAULT '1'::smallint NOT NULL
);

ALTER TABLE "public"."carrito" OWNER TO "postgres";

ALTER TABLE "public"."carrito" ALTER COLUMN "carrito_id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."carrito_id_carrito_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE "public"."categoria" (
    "categoria_id" bigint NOT NULL,
    "categoria_nombre" character varying NOT NULL
);

ALTER TABLE "public"."categoria" OWNER TO "postgres";

ALTER TABLE "public"."categoria" ALTER COLUMN "categoria_id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."categoria_categoria_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE "public"."cliente" (
    "cliente_id" bigint NOT NULL,
    "cliente_nombre" character varying NOT NULL,
    "cliente_email" character varying NOT NULL,
    "cliente_telefono" character varying NOT NULL,
    "cliente_activo" boolean DEFAULT true NOT NULL
);

ALTER TABLE "public"."cliente" OWNER TO "postgres";

ALTER TABLE "public"."cliente" ALTER COLUMN "cliente_id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."cliente_cliente_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE "public"."usuario" (
    "usuario_id" bigint NOT NULL,
    "usuario_nombre" character varying NOT NULL,
    "usuario_email" character varying NOT NULL,
    "usuario_telefono" character varying NOT NULL,
    "usuario_username" character varying NOT NULL,
    "usuario_password" character varying NOT NULL,
    "sucursal_id" bigint NOT NULL,
    "usuario_admin" boolean DEFAULT false,
    "usuario_leer" boolean DEFAULT false NOT NULL,
    "usuario_activo" boolean DEFAULT true NOT NULL
);

ALTER TABLE "public"."usuario" OWNER TO "postgres";

ALTER TABLE "public"."usuario" ALTER COLUMN "usuario_id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."empleado_usuario_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE "public"."ingresos_detalle" (
    "ingreso_id" bigint NOT NULL,
    "ingreso_cantidad" numeric NOT NULL,
    "ingreso_motivo" "text" DEFAULT ''::"text" NOT NULL,
    "caja_id" bigint
);

ALTER TABLE "public"."ingresos_detalle" OWNER TO "postgres";

ALTER TABLE "public"."ingresos_detalle" ALTER COLUMN "ingreso_id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."ingresos_detalle_ingreso_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE "public"."miembro" (
    "miembro_id" bigint NOT NULL,
    "miembro_fecha_inicio" "date" NOT NULL,
    "miembro_fecha_final" "date" NOT NULL,
    "miembro_compras" integer DEFAULT 0 NOT NULL,
    "miembro_rentas" integer DEFAULT 0 NOT NULL,
    "miembro_activo" boolean DEFAULT true NOT NULL,
    "cliente_id" bigint NOT NULL,
    "miembro_fecha_original" "date" DEFAULT '2023-05-14'::"date" NOT NULL
);

ALTER TABLE "public"."miembro" OWNER TO "postgres";

ALTER TABLE "public"."miembro" ALTER COLUMN "miembro_id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."miembro_miembro_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE "public"."plataforma" (
    "plataforma_id" bigint NOT NULL,
    "plataforma_nombre" character varying NOT NULL
);

ALTER TABLE "public"."plataforma" OWNER TO "postgres";

ALTER TABLE "public"."plataforma" ALTER COLUMN "plataforma_id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."plataforma_plataforma_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE "public"."producto" (
    "producto_id" bigint NOT NULL,
    "producto_nombre" character varying NOT NULL,
    "producto_nuevo" boolean DEFAULT true NOT NULL,
    "producto_precio" double precision NOT NULL,
    "producto_stock" bigint NOT NULL,
    "categoria_id" bigint NOT NULL,
    "producto_minimo" smallint NOT NULL,
    "producto_activo" boolean DEFAULT true NOT NULL
);

ALTER TABLE "public"."producto" OWNER TO "postgres";

CREATE TABLE "public"."producto_plataforma" (
    "producto_id" bigint NOT NULL,
    "plataforma_id" bigint NOT NULL
);

ALTER TABLE "public"."producto_plataforma" OWNER TO "postgres";

ALTER TABLE "public"."producto" ALTER COLUMN "producto_id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."producto_producto_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE "public"."renta" (
    "renta_id" bigint NOT NULL,
    "miembro_id" bigint NOT NULL,
    "renta_monto" double precision NOT NULL,
    "renta_fecha_inicio" "date" NOT NULL,
    "renta_fecha_final" "date" NOT NULL,
    "renta_cantidad" smallint NOT NULL,
    "renta_descuento" smallint NOT NULL,
    "renta_activa" boolean DEFAULT true NOT NULL,
    "renta_tarjeta" boolean NOT NULL,
    "renta_duracion" smallint NOT NULL,
    "renta_completada" boolean DEFAULT false NOT NULL
);

ALTER TABLE "public"."renta" OWNER TO "postgres";

CREATE TABLE "public"."renta_detalle" (
    "renta_detalle_id" bigint NOT NULL,
    "renta_id" bigint NOT NULL,
    "producto_id" bigint NOT NULL
);

ALTER TABLE "public"."renta_detalle" OWNER TO "postgres";

ALTER TABLE "public"."renta_detalle" ALTER COLUMN "renta_detalle_id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."renta_detalle_renta_detalle_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE "public"."renta" ALTER COLUMN "renta_id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."renta_renta_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE "public"."retiros_detalle" (
    "retiro_id" bigint NOT NULL,
    "retiro_cantidad" numeric NOT NULL,
    "retiro_motivo" "text" NOT NULL,
    "caja_id" bigint NOT NULL
);

ALTER TABLE "public"."retiros_detalle" OWNER TO "postgres";

ALTER TABLE "public"."retiros_detalle" ALTER COLUMN "retiro_id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."retirosCaja_retiro_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE "public"."sucursal" (
    "sucursal_id" bigint NOT NULL,
    "sucursal_nombre" character varying NOT NULL,
    "sucursal_direccion" character varying NOT NULL,
    "sucursal_cp" character varying NOT NULL,
    "sucursal_telefono" character varying
);

ALTER TABLE "public"."sucursal" OWNER TO "postgres";

ALTER TABLE "public"."sucursal" ALTER COLUMN "sucursal_id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."sucursal_sucursal_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE "public"."venta" (
    "venta_id" bigint NOT NULL,
    "venta_monto" double precision NOT NULL,
    "venta_descuento" smallint NOT NULL,
    "venta_fecha" "date" NOT NULL,
    "cliente_id" bigint NOT NULL,
    "venta_tarjeta" boolean DEFAULT false NOT NULL,
    "venta_activa" boolean DEFAULT true NOT NULL,
    "venta_cantidad" smallint
);

ALTER TABLE "public"."venta" OWNER TO "postgres";

CREATE TABLE "public"."venta_detalle" (
    "venta_detalle_id" bigint NOT NULL,
    "venta_id" bigint NOT NULL,
    "producto_id" bigint NOT NULL,
    "venta_detalle_cantidad" smallint NOT NULL,
    "venta_detalle_precio" double precision NOT NULL
);

ALTER TABLE "public"."venta_detalle" OWNER TO "postgres";

ALTER TABLE "public"."venta_detalle" ALTER COLUMN "venta_detalle_id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."venta_detalle_venta_detalle_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE "public"."venta" ALTER COLUMN "venta_id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."venta_venta_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY "public"."apartado"
    ADD CONSTRAINT "Apartado_apartado_id_key" UNIQUE ("apartado_id");

ALTER TABLE ONLY "public"."apartado"
    ADD CONSTRAINT "Apartado_pkey" PRIMARY KEY ("apartado_id");

ALTER TABLE ONLY "public"."caja"
    ADD CONSTRAINT "caja_caja_id_key" UNIQUE ("caja_id");

ALTER TABLE ONLY "public"."caja"
    ADD CONSTRAINT "caja_pkey" PRIMARY KEY ("caja_id");

ALTER TABLE ONLY "public"."carrito"
    ADD CONSTRAINT "carrito_id_carrito_id_key" UNIQUE ("carrito_id");

ALTER TABLE ONLY "public"."carrito"
    ADD CONSTRAINT "carrito_id_pkey" PRIMARY KEY ("carrito_id");

ALTER TABLE ONLY "public"."carrito"
    ADD CONSTRAINT "carrito_producto_id_key" UNIQUE ("producto_id");

ALTER TABLE ONLY "public"."categoria"
    ADD CONSTRAINT "categoria_categoria_id_key" UNIQUE ("categoria_id");

ALTER TABLE ONLY "public"."categoria"
    ADD CONSTRAINT "categoria_pkey" PRIMARY KEY ("categoria_id");

ALTER TABLE ONLY "public"."cliente"
    ADD CONSTRAINT "cliente_cliente_id_key" UNIQUE ("cliente_id");

ALTER TABLE ONLY "public"."cliente"
    ADD CONSTRAINT "cliente_pkey" PRIMARY KEY ("cliente_id");

ALTER TABLE ONLY "public"."usuario"
    ADD CONSTRAINT "empleado_pkey" PRIMARY KEY ("usuario_id");

ALTER TABLE ONLY "public"."usuario"
    ADD CONSTRAINT "empleado_usuario_id_key" UNIQUE ("usuario_id");

ALTER TABLE ONLY "public"."ingresos_detalle"
    ADD CONSTRAINT "ingresos_detalle_pkey" PRIMARY KEY ("ingreso_id");

ALTER TABLE ONLY "public"."miembro"
    ADD CONSTRAINT "miembro_miembro_id_key" UNIQUE ("miembro_id");

ALTER TABLE ONLY "public"."miembro"
    ADD CONSTRAINT "miembro_pkey" PRIMARY KEY ("miembro_id");

ALTER TABLE ONLY "public"."plataforma"
    ADD CONSTRAINT "plataforma_pkey" PRIMARY KEY ("plataforma_id");

ALTER TABLE ONLY "public"."plataforma"
    ADD CONSTRAINT "plataforma_plataforma_id_key" UNIQUE ("plataforma_id");

ALTER TABLE ONLY "public"."producto"
    ADD CONSTRAINT "producto_pkey" PRIMARY KEY ("producto_id");

ALTER TABLE ONLY "public"."producto_plataforma"
    ADD CONSTRAINT "producto_plataforma_pkey" PRIMARY KEY ("producto_id", "plataforma_id");

ALTER TABLE ONLY "public"."producto_plataforma"
    ADD CONSTRAINT "producto_plataforma_producto_id_key" UNIQUE ("producto_id");

ALTER TABLE ONLY "public"."producto"
    ADD CONSTRAINT "producto_producto_id_key" UNIQUE ("producto_id");

ALTER TABLE ONLY "public"."renta_detalle"
    ADD CONSTRAINT "renta_detalle_pkey" PRIMARY KEY ("renta_detalle_id");

ALTER TABLE ONLY "public"."renta"
    ADD CONSTRAINT "renta_pkey" PRIMARY KEY ("renta_id");

ALTER TABLE ONLY "public"."renta"
    ADD CONSTRAINT "renta_renta_id_key" UNIQUE ("renta_id");

ALTER TABLE ONLY "public"."retiros_detalle"
    ADD CONSTRAINT "retirosCaja_pkey" PRIMARY KEY ("retiro_id");

ALTER TABLE ONLY "public"."sucursal"
    ADD CONSTRAINT "sucursal_pkey" PRIMARY KEY ("sucursal_id");

ALTER TABLE ONLY "public"."sucursal"
    ADD CONSTRAINT "sucursal_sucursal_id_key" UNIQUE ("sucursal_id");

ALTER TABLE ONLY "public"."usuario"
    ADD CONSTRAINT "usuario_usuario_username_key" UNIQUE ("usuario_username");

ALTER TABLE ONLY "public"."venta_detalle"
    ADD CONSTRAINT "venta_detalle_pkey" PRIMARY KEY ("venta_detalle_id");

ALTER TABLE ONLY "public"."venta_detalle"
    ADD CONSTRAINT "venta_detalle_venta_detalle_id_key" UNIQUE ("venta_detalle_id");

ALTER TABLE ONLY "public"."venta"
    ADD CONSTRAINT "venta_pkey" PRIMARY KEY ("venta_id");

ALTER TABLE ONLY "public"."venta"
    ADD CONSTRAINT "venta_venta_id_key" UNIQUE ("venta_id");

ALTER TABLE ONLY "public"."apartado"
    ADD CONSTRAINT "apartado_cliente_id_fkey" FOREIGN KEY ("cliente_id") REFERENCES "public"."cliente"("cliente_id");

ALTER TABLE ONLY "public"."apartado"
    ADD CONSTRAINT "apartado_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "public"."usuario"("usuario_id");

ALTER TABLE ONLY "public"."carrito"
    ADD CONSTRAINT "carrito_producto_id_fkey" FOREIGN KEY ("producto_id") REFERENCES "public"."producto"("producto_id");

ALTER TABLE ONLY "public"."ingresos_detalle"
    ADD CONSTRAINT "ingresos_detalle_caja_id_fkey" FOREIGN KEY ("caja_id") REFERENCES "public"."caja"("caja_id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."miembro"
    ADD CONSTRAINT "miembro_cliente_id_fkey" FOREIGN KEY ("cliente_id") REFERENCES "public"."cliente"("cliente_id");

ALTER TABLE ONLY "public"."producto"
    ADD CONSTRAINT "producto_categoria_id_fkey" FOREIGN KEY ("categoria_id") REFERENCES "public"."categoria"("categoria_id");

ALTER TABLE ONLY "public"."producto_plataforma"
    ADD CONSTRAINT "producto_plataforma_plataforma_id_fkey" FOREIGN KEY ("plataforma_id") REFERENCES "public"."plataforma"("plataforma_id");

ALTER TABLE ONLY "public"."producto_plataforma"
    ADD CONSTRAINT "producto_plataforma_producto_id_fkey" FOREIGN KEY ("producto_id") REFERENCES "public"."producto"("producto_id");

ALTER TABLE ONLY "public"."renta_detalle"
    ADD CONSTRAINT "renta_detalle_producto_id_fkey" FOREIGN KEY ("producto_id") REFERENCES "public"."producto"("producto_id");

ALTER TABLE ONLY "public"."renta_detalle"
    ADD CONSTRAINT "renta_detalle_renta_id_fkey" FOREIGN KEY ("renta_id") REFERENCES "public"."renta"("renta_id");

ALTER TABLE ONLY "public"."renta"
    ADD CONSTRAINT "renta_miembro_id_fkey" FOREIGN KEY ("miembro_id") REFERENCES "public"."miembro"("miembro_id");

ALTER TABLE ONLY "public"."retiros_detalle"
    ADD CONSTRAINT "retiros_detalle_caja_id_fkey" FOREIGN KEY ("caja_id") REFERENCES "public"."caja"("caja_id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."usuario"
    ADD CONSTRAINT "usuario_sucursal_id_fkey" FOREIGN KEY ("sucursal_id") REFERENCES "public"."sucursal"("sucursal_id");

ALTER TABLE ONLY "public"."venta"
    ADD CONSTRAINT "venta_cliente_id_fkey" FOREIGN KEY ("cliente_id") REFERENCES "public"."cliente"("cliente_id");

ALTER TABLE ONLY "public"."venta_detalle"
    ADD CONSTRAINT "venta_detalle_producto_id_fkey" FOREIGN KEY ("producto_id") REFERENCES "public"."producto"("producto_id");

ALTER TABLE ONLY "public"."venta_detalle"
    ADD CONSTRAINT "venta_detalle_venta_id_fkey" FOREIGN KEY ("venta_id") REFERENCES "public"."venta"("venta_id");

ALTER TABLE "public"."apartado" ENABLE ROW LEVEL SECURITY;

GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";

GRANT ALL ON FUNCTION "public"."generalreportaccesoriosdate"("start_date" "date", "end_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."generalreportaccesoriosdate"("start_date" "date", "end_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."generalreportaccesoriosdate"("start_date" "date", "end_date" "date") TO "service_role";

GRANT ALL ON FUNCTION "public"."generalreportaccesoriosonedate"("start_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."generalreportaccesoriosonedate"("start_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."generalreportaccesoriosonedate"("start_date" "date") TO "service_role";

GRANT ALL ON FUNCTION "public"."generalreportconsolasdate"("start_date" "date", "end_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."generalreportconsolasdate"("start_date" "date", "end_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."generalreportconsolasdate"("start_date" "date", "end_date" "date") TO "service_role";

GRANT ALL ON FUNCTION "public"."generalreportconsolasonedate"("start_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."generalreportconsolasonedate"("start_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."generalreportconsolasonedate"("start_date" "date") TO "service_role";

GRANT ALL ON FUNCTION "public"."generalreportgamesdate"("start_date" "date", "end_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."generalreportgamesdate"("start_date" "date", "end_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."generalreportgamesdate"("start_date" "date", "end_date" "date") TO "service_role";

GRANT ALL ON FUNCTION "public"."generalreportgamesonedate"("start_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."generalreportgamesonedate"("start_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."generalreportgamesonedate"("start_date" "date") TO "service_role";

GRANT ALL ON FUNCTION "public"."generalreportrentscarddate"("start_date" "date", "end_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."generalreportrentscarddate"("start_date" "date", "end_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."generalreportrentscarddate"("start_date" "date", "end_date" "date") TO "service_role";

GRANT ALL ON FUNCTION "public"."generalreportrentscardonedate"("start_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."generalreportrentscardonedate"("start_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."generalreportrentscardonedate"("start_date" "date") TO "service_role";

GRANT ALL ON FUNCTION "public"."generalreportrentsdate"("start_date" "date", "end_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."generalreportrentsdate"("start_date" "date", "end_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."generalreportrentsdate"("start_date" "date", "end_date" "date") TO "service_role";

GRANT ALL ON FUNCTION "public"."generalreportrentsonedate"("start_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."generalreportrentsonedate"("start_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."generalreportrentsonedate"("start_date" "date") TO "service_role";

GRANT ALL ON FUNCTION "public"."generalreportventadate"("start_date" "date", "end_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."generalreportventadate"("start_date" "date", "end_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."generalreportventadate"("start_date" "date", "end_date" "date") TO "service_role";

GRANT ALL ON FUNCTION "public"."generalreportventaonedate"("start_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."generalreportventaonedate"("start_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."generalreportventaonedate"("start_date" "date") TO "service_role";

GRANT ALL ON FUNCTION "public"."get_clients"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_clients"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_clients"() TO "service_role";

GRANT ALL ON FUNCTION "public"."get_clients_members"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_clients_members"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_clients_members"() TO "service_role";

GRANT ALL ON FUNCTION "public"."get_rent_details"("input_id" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."get_rent_details"("input_id" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_rent_details"("input_id" integer) TO "service_role";

GRANT ALL ON FUNCTION "public"."get_sale_details"("input_id" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."get_sale_details"("input_id" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_sale_details"("input_id" integer) TO "service_role";

GRANT ALL ON FUNCTION "public"."get_total"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_total"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_total"() TO "service_role";

GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "service_role";

GRANT ALL ON FUNCTION "public"."products_cart"() TO "anon";
GRANT ALL ON FUNCTION "public"."products_cart"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."products_cart"() TO "service_role";

GRANT ALL ON FUNCTION "public"."products_platforms"() TO "anon";
GRANT ALL ON FUNCTION "public"."products_platforms"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."products_platforms"() TO "service_role";

GRANT ALL ON FUNCTION "public"."register_sale"("input_cliente_id" integer, "input_descuento" integer, "input_venta_tarjeta" boolean) TO "anon";
GRANT ALL ON FUNCTION "public"."register_sale"("input_cliente_id" integer, "input_descuento" integer, "input_venta_tarjeta" boolean) TO "authenticated";
GRANT ALL ON FUNCTION "public"."register_sale"("input_cliente_id" integer, "input_descuento" integer, "input_venta_tarjeta" boolean) TO "service_role";

GRANT ALL ON FUNCTION "public"."ventatarjetadate"("start_date" "date", "end_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."ventatarjetadate"("start_date" "date", "end_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."ventatarjetadate"("start_date" "date", "end_date" "date") TO "service_role";

GRANT ALL ON FUNCTION "public"."ventatarjetaonedate"("start_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."ventatarjetaonedate"("start_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."ventatarjetaonedate"("start_date" "date") TO "service_role";

GRANT ALL ON TABLE "public"."apartado" TO "anon";
GRANT ALL ON TABLE "public"."apartado" TO "authenticated";
GRANT ALL ON TABLE "public"."apartado" TO "service_role";

GRANT ALL ON SEQUENCE "public"."Apartado_apartado_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."Apartado_apartado_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."Apartado_apartado_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."caja" TO "anon";
GRANT ALL ON TABLE "public"."caja" TO "authenticated";
GRANT ALL ON TABLE "public"."caja" TO "service_role";

GRANT ALL ON SEQUENCE "public"."caja_caja_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."caja_caja_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."caja_caja_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."carrito" TO "anon";
GRANT ALL ON TABLE "public"."carrito" TO "authenticated";
GRANT ALL ON TABLE "public"."carrito" TO "service_role";

GRANT ALL ON SEQUENCE "public"."carrito_id_carrito_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."carrito_id_carrito_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."carrito_id_carrito_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."categoria" TO "anon";
GRANT ALL ON TABLE "public"."categoria" TO "authenticated";
GRANT ALL ON TABLE "public"."categoria" TO "service_role";

GRANT ALL ON SEQUENCE "public"."categoria_categoria_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."categoria_categoria_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."categoria_categoria_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."cliente" TO "anon";
GRANT ALL ON TABLE "public"."cliente" TO "authenticated";
GRANT ALL ON TABLE "public"."cliente" TO "service_role";

GRANT ALL ON SEQUENCE "public"."cliente_cliente_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."cliente_cliente_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."cliente_cliente_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."usuario" TO "anon";
GRANT ALL ON TABLE "public"."usuario" TO "authenticated";
GRANT ALL ON TABLE "public"."usuario" TO "service_role";

GRANT ALL ON SEQUENCE "public"."empleado_usuario_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."empleado_usuario_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."empleado_usuario_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."ingresos_detalle" TO "anon";
GRANT ALL ON TABLE "public"."ingresos_detalle" TO "authenticated";
GRANT ALL ON TABLE "public"."ingresos_detalle" TO "service_role";

GRANT ALL ON SEQUENCE "public"."ingresos_detalle_ingreso_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ingresos_detalle_ingreso_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ingresos_detalle_ingreso_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."miembro" TO "anon";
GRANT ALL ON TABLE "public"."miembro" TO "authenticated";
GRANT ALL ON TABLE "public"."miembro" TO "service_role";

GRANT ALL ON SEQUENCE "public"."miembro_miembro_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."miembro_miembro_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."miembro_miembro_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."plataforma" TO "anon";
GRANT ALL ON TABLE "public"."plataforma" TO "authenticated";
GRANT ALL ON TABLE "public"."plataforma" TO "service_role";

GRANT ALL ON SEQUENCE "public"."plataforma_plataforma_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."plataforma_plataforma_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."plataforma_plataforma_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."producto" TO "anon";
GRANT ALL ON TABLE "public"."producto" TO "authenticated";
GRANT ALL ON TABLE "public"."producto" TO "service_role";

GRANT ALL ON TABLE "public"."producto_plataforma" TO "anon";
GRANT ALL ON TABLE "public"."producto_plataforma" TO "authenticated";
GRANT ALL ON TABLE "public"."producto_plataforma" TO "service_role";

GRANT ALL ON SEQUENCE "public"."producto_producto_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."producto_producto_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."producto_producto_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."renta" TO "anon";
GRANT ALL ON TABLE "public"."renta" TO "authenticated";
GRANT ALL ON TABLE "public"."renta" TO "service_role";

GRANT ALL ON TABLE "public"."renta_detalle" TO "anon";
GRANT ALL ON TABLE "public"."renta_detalle" TO "authenticated";
GRANT ALL ON TABLE "public"."renta_detalle" TO "service_role";

GRANT ALL ON SEQUENCE "public"."renta_detalle_renta_detalle_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."renta_detalle_renta_detalle_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."renta_detalle_renta_detalle_id_seq" TO "service_role";

GRANT ALL ON SEQUENCE "public"."renta_renta_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."renta_renta_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."renta_renta_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."retiros_detalle" TO "anon";
GRANT ALL ON TABLE "public"."retiros_detalle" TO "authenticated";
GRANT ALL ON TABLE "public"."retiros_detalle" TO "service_role";

GRANT ALL ON SEQUENCE "public"."retirosCaja_retiro_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."retirosCaja_retiro_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."retirosCaja_retiro_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."sucursal" TO "anon";
GRANT ALL ON TABLE "public"."sucursal" TO "authenticated";
GRANT ALL ON TABLE "public"."sucursal" TO "service_role";

GRANT ALL ON SEQUENCE "public"."sucursal_sucursal_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."sucursal_sucursal_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."sucursal_sucursal_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."venta" TO "anon";
GRANT ALL ON TABLE "public"."venta" TO "authenticated";
GRANT ALL ON TABLE "public"."venta" TO "service_role";

GRANT ALL ON TABLE "public"."venta_detalle" TO "anon";
GRANT ALL ON TABLE "public"."venta_detalle" TO "authenticated";
GRANT ALL ON TABLE "public"."venta_detalle" TO "service_role";

GRANT ALL ON SEQUENCE "public"."venta_detalle_venta_detalle_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."venta_detalle_venta_detalle_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."venta_detalle_venta_detalle_id_seq" TO "service_role";

GRANT ALL ON SEQUENCE "public"."venta_venta_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."venta_venta_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."venta_venta_id_seq" TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";

RESET ALL;
