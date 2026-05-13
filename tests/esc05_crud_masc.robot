*** Settings ***
Resource        ${CURDIR}/../resources/common.resource
Library         DataDriver
...             file=${CURDIR}/../Dataset-Escenarios-PETS-SA.xlsx
...             sheet_name=ESC05_CRUD_MASC
...             encoding=utf_8

Suite Setup     Setup Suite Con Video
Suite Teardown  Teardown Suite Con Video
Test Template   Ejecutar Prueba CRUD Mascota
Test Setup      Test Setup Con Video
Test Teardown   Test Teardown Con Video

*** Test Cases ***
Verificar CRUD de mascota ${dataset_id}    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE

*** Keywords ***
Ejecutar Prueba CRUD Mascota
    [Arguments]
    ...    ${module}    ${dataset_id}    ${pet_id}    ${nombre}    ${raza}    ${edad}    ${peso}
    ...    ${medicamento_id}    ${cliente_id}    ${tipo}    ${expected_result}    ${RF}
    ...    ${accion}    ${nota_defecto}    ${estado_bug}
    ...    ${campo_id_locator}    ${campo_nombre_locator}    ${campo_raza_locator}
    ...    ${campo_edad_locator}    ${campo_peso_locator}    ${campo_medicamento_locator}
    ...    ${campo_cliente_locator}    ${campo_submit_locator}    ${campo_edit_btn_locator}
    ...    ${campo_del_btn_locator}    ${campo_confirm_del_locator}    ${campo_listado_locator}
    ...    ${campo_row_search_text}    ${username}    ${password}
    Hacer Login    ${username}    ${password}
    Verificar Login Exitoso
    IF    '${accion}' == 'crear'
        Navegar A Modulo    /mascotas/nueva/
        Wait Until Element Is Visible    ${campo_id_locator}    timeout=10s
        Limpiar Y Escribir    ${campo_id_locator}    ${pet_id}
        Limpiar Y Escribir    ${campo_nombre_locator}    ${nombre}
        Limpiar Y Escribir    ${campo_raza_locator}    ${raza}
        Limpiar Y Escribir    ${campo_edad_locator}    ${edad}
        Limpiar Y Escribir    ${campo_peso_locator}    ${peso}
        Seleccionar Opcion Por Texto    ${campo_medicamento_locator}    ${medicamento_id}
        Seleccionar Opcion Por Texto    ${campo_cliente_locator}    ${cliente_id}
        Click Element    ${campo_submit_locator}
        Sleep    ${DELAY_ACCION}
        Wait Until Page Contains    ${pet_id}    timeout=10s
    ELSE IF    '${accion}' == 'editar'
        Navegar A Modulo    /mascotas/
        Hacer Clic En Accion De Fila    ${campo_row_search_text}    btn-yellow
        Wait Until Element Is Visible    ${campo_nombre_locator}    timeout=10s
        Clear Element Text    ${campo_nombre_locator}
        Input Text    ${campo_nombre_locator}    ${nombre}
        Clear Element Text    ${campo_raza_locator}
        Input Text    ${campo_raza_locator}    ${raza}
        Clear Element Text    ${campo_edad_locator}
        Input Text    ${campo_edad_locator}    ${edad}
        Clear Element Text    ${campo_peso_locator}
        Input Text    ${campo_peso_locator}    ${peso}
        Seleccionar Opcion Por Texto    ${campo_medicamento_locator}    ${medicamento_id}
        Seleccionar Opcion Por Texto    ${campo_cliente_locator}    ${cliente_id}
        Click Element    ${campo_submit_locator}
        Sleep    ${DELAY_ACCION}
        Wait Until Page Contains    ${pet_id}    timeout=10s
    ELSE IF    '${accion}' == 'eliminar'
        Navegar A Modulo    /mascotas/
        Hacer Clic En Accion De Fila    ${campo_row_search_text}    btn-red
        Wait Until Element Is Visible    ${campo_confirm_del_locator}    timeout=10s
        Click Element    ${campo_confirm_del_locator}
        Sleep    ${DELAY_ACCION}
        Wait Until Page Does Not Contain    ${campo_row_search_text}    timeout=10s
    END
    Hacer Logout