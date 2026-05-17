(: ===================================================== :)
(: CONSULTA 1 - EMPLEADOS CON SALARIO MAYOR A 10000 :)
(: ===================================================== :)

for $e in doc("andres_herrera.xml")/Empleados/Empleado
where xs:decimal($e/Salario) > 10000
return
<EmpleadoAltoSalario>
    <ID>{ $e/@id }</ID>
    <Nombre>{ $e/Nombre/text() }</Nombre>
    <Apellido>{ $e/Apellido/text() }</Apellido>
    <Salario>{ $e/Salario/text() }</Salario>
</EmpleadoAltoSalario>


(: ===================================================== :)
(: CONSULTA 2 - EMPLEADOS DEL DEPARTAMENTO SALES :)
(: ===================================================== :)

for $e in doc("andres_herrera.xml")/Empleados/Empleado
where $e/Departamento = "Sales"
return
<EmpleadoSales>
    <Nombre>{ $e/Nombre/text() }</Nombre>
    <Apellido>{ $e/Apellido/text() }</Apellido>
    <Departamento>{ $e/Departamento/text() }</Departamento>
</EmpleadoSales>


(: ===================================================== :)
(: CONSULTA 3 - MOSTRAR NOMBRE Y CORREO :)
(: ===================================================== :)

for $e in doc("andres_herrera.xml")/Empleados/Empleado
return
<InformacionEmpleado>
    <Nombre>{ $e/Nombre/text() }</Nombre>
    <Correo>{ $e/Correo/text() }</Correo>
</InformacionEmpleado>


(: ===================================================== :)
(: CONSULTA 4 - EMPLEADOS DEL DEPARTAMENTO IT :)
(: ===================================================== :)

for $e in doc("andres_herrera.xml")/Empleados/Empleado
where $e/Departamento = "IT"
return
<EmpleadoIT>
    <ID>{ $e/@id }</ID>
    <Nombre>{ $e/Nombre/text() }</Nombre>
    <Apellido>{ $e/Apellido/text() }</Apellido>
</EmpleadoIT>


(: ===================================================== :)
(: CONSULTA 5 - EMPLEADOS CON SALARIO ENTRE 5000 Y 10000 :)
(: ===================================================== :)

for $e in doc("andres_herrera.xml")/Empleados/Empleado
where xs:decimal($e/Salario) >= 5000
and xs:decimal($e/Salario) <= 10000
return
<EmpleadoSalarioMedio>
    <Nombre>{ $e/Nombre/text() }</Nombre>
    <Salario>{ $e/Salario/text() }</Salario>
</EmpleadoSalarioMedio>