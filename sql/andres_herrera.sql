/* ============================================================
Laboratorio: Almacenamiento y validación de ficheros XML
Autor: Andres Herrera
Base de datos: Oracle Database XE
Esquema utilizado: HR
============================================================ */


/* ============================================================
1. Consulta de prueba sobre la tabla EMPLOYEES
============================================================ */

SELECT *
FROM employees;


/* ============================================================
2. Consulta de prueba sobre la tabla DEPARTMENTS
============================================================ */

SELECT *
FROM departments;


/* ============================================================
3. Generación de XML simple desde la tabla EMPLOYEES
Uso de XMLELEMENT y XMLFOREST
============================================================ */

SELECT xmlelement(
    "Empleado",
    xmlforest(
        employee_id AS "ID",
        first_name AS "Nombre",
        last_name AS "Apellido",
        salary AS "Salario"
    )
) AS resultado_xml
FROM employees;


/* ============================================================
4. Generación de XML combinando EMPLOYEES y DEPARTMENTS
Uso de XMLELEMENT, XMLATTRIBUTES y XMLFOREST
   ============================================================ */

SELECT xmlelement(
    "Empleado",
    xmlattributes(e.employee_id AS "id"),
    xmlforest(
        e.first_name AS "Nombre",
        e.last_name AS "Apellido",
        e.email AS "Correo",
        e.salary AS "Salario",
        d.department_name AS "Departamento"
    )
) AS resultado_xml
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;


/* ============================================================
5. Generación de documento XML completo
Uso de XMLELEMENT, XMLATTRIBUTES, XMLFOREST, XMLAGG
y XMLSERIALIZE para obtener salida XML legible
============================================================ */

SELECT XMLSERIALIZE(
    DOCUMENT
    xmlelement(
        "Empleados",
        xmlagg(
            xmlelement(
                "Empleado",
                xmlattributes(e.employee_id AS "id"),
                xmlforest(
                    e.first_name AS "Nombre",
                    e.last_name AS "Apellido",
                    e.email AS "Correo",
                    e.salary AS "Salario",
                    d.department_name AS "Departamento"
                )
            )
        )
    )
    AS CLOB INDENT SIZE = 2
) AS resultado_xml
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;


/* ============================================================
6. Eliminación opcional de la tabla si ya existe
Ejecutar solo si se desea reiniciar la prueba.
============================================================ */

-- DROP TABLE empleados_xml;


/* ============================================================
7. Creación de tabla para almacenar documentos XML
============================================================ */

CREATE TABLE empleados_xml (
    id NUMBER,
    documento XMLTYPE
);


/* ============================================================
8. Inserción válida de un documento XML individual
============================================================ */

INSERT INTO empleados_xml
VALUES (
    1,
    XMLTYPE(
'
<Empleado id="999">
    <Nombre>Andres</Nombre>
    <Apellido>Herrera</Apellido>
    <Correo>AHERRERA</Correo>
    <Salario>5000</Salario>
    <Departamento>IT</Departamento>
</Empleado>
'
    )
);


/* ============================================================
9. Inserción inválida de prueba
Documento incompleto según la estructura definida en el XSD
============================================================ */

INSERT INTO empleados_xml
VALUES (
    3,
    XMLTYPE(
'
<Empleado id="1000">
    <Nombre>Andres</Nombre>
</Empleado>
'
    )
);


/* ============================================================
10. Inserción del documento XML completo generado desde HR
============================================================ */

INSERT INTO empleados_xml
VALUES (
    2,
    XMLTYPE(
'
<Empleados>
    <Empleado id="200">
        <Nombre>Jennifer</Nombre>
        <Apellido>Whalen</Apellido>
        <Correo>JWHALEN</Correo>
        <Salario>4400</Salario>
        <Departamento>Administration</Departamento>
    </Empleado>
</Empleados>
'
    )
);


/* ============================================================
11. Consulta de documentos almacenados
============================================================ */

SELECT *
FROM empleados_xml;


/* ============================================================
12. Consulta del contenido XML como texto
============================================================ */

SELECT id,
    XMLSERIALIZE(CONTENT documento AS CLOB INDENT SIZE = 2) AS documento_xml
FROM empleados_xml;


/* ============================================================
13. Consulta XPath sobre documentos XML almacenados
Extrae el nombre del empleado desde el XML
   ============================================================ */

SELECT id,
    XMLCAST(
        XMLQUERY(
            '/Empleado/Nombre/text()'
            PASSING documento
            RETURNING CONTENT
        ) AS VARCHAR2(100)
    ) AS nombre_empleado
FROM empleados_xml
WHERE id = 1;


/* ============================================================
14. Confirmar cambios
============================================================ */

COMMIT;