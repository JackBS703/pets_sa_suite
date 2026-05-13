*** Settings ***
Resource        ${CURDIR}/../resources/common.resource
Library         DataDriver
...             file=${CURDIR}/../Dataset-Escenarios-PETS-SA.xlsx
...             sheet_name=ESC01_XSS_SQLI
...             encoding=utf_8

Suite Setup     Setup Suite Con Video
Suite Teardown  Teardown Suite Con Video
Test Template   Ejecutar Prueba XSS SQLi
Test Setup      Test Setup Con Video
Test Teardown   Test Teardown Con Video

*** Variables ***
${URL_CLIENTES}         /clientes/nuevo/
${URL_MEDICAMENTOS}     /medicamentos/nuevo/

*** Test Cases ***
Verificar sanitizacion en ${dataset_id}    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE

*** Keywords ***
Ejecutar Prueba XSS SQLi
    [Arguments]
    ...    ${module}    ${dataset_id}    ${modulo}
    ...    ${cedula}    ${nombres}    ${apellidos}    ${telefono}    ${direccion}
    ...    ${med_nombre}    ${med_descripcion}    ${med_dosis}
    ...    ${tipo}    ${expected_result}    ${RF}    ${accion}    ${nota_defecto}    ${estado_bug}
    ...    ${campo_f1_locator}    ${campo_f2_locator}    ${campo_f3_locator}
    ...    ${campo_f4_locator}    ${campo_f5_locator}
    ...    ${campo_submit_locator}    ${campo_listado_locator}    ${campo_error_locator}
    ...    ${username}    ${password}
    Hacer Login    ${username}    ${password}
    Verificar Login Exitoso
    IF    '${module}' == 'CLI'
        Navegar A Modulo    ${URL_CLIENTES}
        Wait Until Element Is Visible    ${campo_f1_locator}    timeout=10s
        Limpiar Y Escribir    ${campo_f1_locator}    ${cedula}
        Limpiar Y Escribir    ${campo_f2_locator}    ${nombres}
        Limpiar Y Escribir    ${campo_f3_locator}    ${apellidos}
        Limpiar Y Escribir    ${campo_f4_locator}    ${telefono}
        Limpiar Y Escribir    ${campo_f5_locator}    ${direccion}
        Click Element    ${campo_submit_locator}
        Sleep    ${DELAY_ACCION}
    ELSE IF    '${module}' == 'MED'
        Navegar A Modulo    ${URL_MEDICAMENTOS}
        Wait Until Element Is Visible    ${campo_f1_locator}    timeout=10s
        Limpiar Y Escribir    ${campo_f1_locator}    ${med_nombre}
        Limpiar Y Escribir    ${campo_f2_locator}    ${med_descripcion}
        Limpiar Y Escribir    ${campo_f3_locator}    ${med_dosis}
        Click Element    ${campo_submit_locator}
        Sleep    ${DELAY_ACCION}
    END
    Verificar Que No Hay XSS Ejecutado    ${dataset_id}
    Verificar Que No Hay SQLi Ejecutado    ${dataset_id}
    Hacer Logout

Verificar Que No Hay XSS Ejecutado
    [Arguments]    ${dataset_id}
    ${alert_presente}=    Run Keyword And Return Status    Alert Should Be Present    timeout=2s
    Run Keyword If    ${alert_presente}    Handle Alert    action=DISMISS
    Should Not Be True    ${alert_presente}
    ...    msg=VULNERABILIDAD XSS DETECTADA — alert(1) ejecutado. Bug confirmado: ${dataset_id}.

Verificar Que No Hay SQLi Ejecutado
    [Arguments]    ${dataset_id}
    ${status500}=    Run Keyword And Return Status
    ...    Page Should Not Contain    Internal Server Error
    Should Be True    ${status500}
    ...    msg=POSIBLE SQLi — página retornó 500 en ${dataset_id}.
    ${statusDB}=    Run Keyword And Return Status
    ...    Page Should Not Contain    ProgrammingError
    Should Be True    ${statusDB}
    ...    msg=POSIBLE SQLi — ProgrammingError detectado en ${dataset_id}.