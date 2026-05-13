*** Settings ***
Resource        ${CURDIR}/../resources/common.resource
Library         DataDriver
...             file=${CURDIR}/../Dataset-Escenarios-PETS-SA.xlsx
...             sheet_name=ESC03_UNICIDAD
...             encoding=utf_8

Suite Setup     Setup Suite Con Video
Suite Teardown  Teardown Suite Con Video
Test Template   Ejecutar Prueba Unicidad
Test Setup      Test Setup Con Video
Test Teardown   Test Teardown Con Video

*** Test Cases ***
Verificar unicidad en ${dataset_id}    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE

*** Keywords ***
Ejecutar Prueba Unicidad
    [Arguments]
    ...    ${module}    ${dataset_id}    ${modulo}    ${username}    ${password}
    ...    ${cedula}    ${nombres}    ${apellidos}    ${telefono}    ${direccion}
    ...    ${pet_id}    ${nombre_mascota}    ${raza}    ${edad}    ${peso}    ${cliente_id}
    ...    ${tipo}    ${expected_result}    ${RF}    ${accion}    ${nota_defecto}    ${estado_bug}
    ...    ${campo_f1_locator}    ${campo_f2_locator}    ${campo_f3_locator}
    ...    ${campo_f4_locator}    ${campo_f5_locator}    ${campo_cliente_locator}
    ...    ${campo_submit_locator}    ${campo_listado_locator}
    ...    ${campo_error_locator}    ${expected_error_text}
    Hacer Login    ${username}    ${password}
    Verificar Login Exitoso
    IF    '${module}' == 'CLI'
        Navegar A Modulo    /clientes/nuevo/
        Wait Until Element Is Visible    ${campo_f1_locator}    timeout=10s
        Limpiar Y Escribir    ${campo_f1_locator}    ${cedula}
        Limpiar Y Escribir    ${campo_f2_locator}    ${nombres}
        Limpiar Y Escribir    ${campo_f3_locator}    ${apellidos}
        Limpiar Y Escribir    ${campo_f4_locator}    ${telefono}
        Limpiar Y Escribir    ${campo_f5_locator}    ${direccion}
        Click Element    ${campo_submit_locator}
        Sleep    ${DELAY_ACCION}
        Verificar Error Unicidad    ${campo_error_locator}    ${expected_error_text}    ${dataset_id}
    ELSE IF    '${module}' == 'MASC'
        Navegar A Modulo    /mascotas/nueva/
        Wait Until Element Is Visible    ${campo_f1_locator}    timeout=10s
        Limpiar Y Escribir    ${campo_f1_locator}    ${pet_id}
        Limpiar Y Escribir    ${campo_f2_locator}    ${nombre_mascota}
        Limpiar Y Escribir    ${campo_f3_locator}    ${raza}
        Limpiar Y Escribir    ${campo_f4_locator}    ${edad}
        Limpiar Y Escribir    ${campo_f5_locator}    ${peso}
        Seleccionar Opcion Por Texto    ${campo_cliente_locator}    Carlos Pérez García
        Click Element    ${campo_submit_locator}
        Sleep    ${DELAY_ACCION}
        Verificar Error Unicidad    ${campo_error_locator}    ${expected_error_text}    ${dataset_id}
    END
    Hacer Logout

Verificar Error Unicidad
    [Arguments]    ${locator}    ${expected_error_text}    ${dataset_id}
    Wait Until Element Is Visible    ${locator}    timeout=10s
    ${texto_real}=    Get Text    ${locator}
    Should Contain    ${texto_real}    ${expected_error_text}
    ...    msg=El sistema NO rechazó el duplicado en ${dataset_id}. Texto real: ${texto_real}