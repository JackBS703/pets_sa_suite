*** Settings ***
Resource        ${CURDIR}/../resources/common.resource
Library         DataDriver
...             file=${CURDIR}/../Dataset-Escenarios-PETS-SA.xlsx
...             sheet_name=ESC02_ACCESO
...             encoding=utf_8

Suite Setup     Setup Suite Con Video
Suite Teardown  Teardown Suite Con Video
Test Template   Ejecutar Prueba Acceso Denegado
Test Setup      Test Setup Con Video
Test Teardown   Test Teardown Con Video

*** Variables ***
# No se requieren variables adicionales; locators vienen del dataset

*** Test Cases ***
Verificar acceso denegado para ${dataset_id}    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE

*** Keywords ***
Ejecutar Prueba Acceso Denegado
    [Arguments]
    ...    ${module}    ${dataset_id}    ${username}    ${password}    ${role}
    ...    ${tipo}    ${expected_result}    ${RF}    ${accion}
    ...    ${campo_url_login}    ${campo_url_target}    ${campo_url_denied}
    ...    ${campo_user_locator}    ${campo_pass_locator}    ${campo_submit_locator}
    ...    ${campo_dashboard_locator}    ${campo_logout_locator}
    ...    ${campo_error_locator}    ${expected_error_text}    ${estado_bug}
    Hacer Login    ${username}    ${password}
    Verificar Login Exitoso
    Go To    ${BASE_URL}${campo_url_target}
    Sleep    ${DELAY_ACCION}
    Verificar Redireccion A Acceso Denegado    ${campo_url_denied}
    Verificar Mensaje Acceso Denegado
    Hacer Logout

Verificar Redireccion A Acceso Denegado
    [Arguments]    ${campo_url_denied}
    ${url_actual}=    Get Location
    Should Contain    ${url_actual}    ${campo_url_denied}
    ...    msg=El sistema NO redirigió a la pantalla de acceso denegado. URL actual: ${url_actual}

Verificar Mensaje Acceso Denegado
    Wait Until Element Is Visible    ${LOC_ALERT}    timeout=10s
    ${texto_alert}=    Get Text    ${LOC_ALERT}
    Should Contain    ${texto_alert}    No tienes permisos para acceder a este módulo.
    ...    msg=Mensaje de acceso denegado no encontrado en div.alert. Texto real: ${texto_alert}