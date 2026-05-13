*** Settings ***
Resource        ${CURDIR}/../resources/common.resource
Library         DataDriver
...             file=${CURDIR}/../Dataset-Escenarios-PETS-SA.xlsx
...             sheet_name=ESC04_BLOQUEO
...             encoding=utf_8

Suite Setup     Abrir Navegador PETS
Suite Teardown  Cerrar Navegador PETS
Test Template   Ejecutar Prueba Bloqueo
Test Setup      Test Setup Con Video
Test Teardown   Test Teardown Con Video

*** Test Cases ***
Verificar bloqueo por intentos fallidos ${dataset_id}    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE    NONE

*** Keywords ***
Ejecutar Prueba Bloqueo
    [Arguments]
    ...    ${module}    ${dataset_id}    ${username}    ${password}    ${role}
    ...    ${tipo}    ${expected_result}    ${RF}    ${accion}
    ...    ${campo_url_login}    ${campo_url_target}
    ...    ${campo_user_locator}    ${campo_pass_locator}    ${campo_submit_locator}
    ...    ${campo_dashboard_locator}    ${campo_logout_locator}
    ...    ${campo_error_locator}    ${expected_error_text}
    ...    ${campo_bloqueo_locator}    ${expected_bloqueo_text}    ${estado_bug}
    Go To    ${LOGIN_URL}
    Wait Until Element Is Visible    ${campo_user_locator}    timeout=10s
    Input Text    ${campo_user_locator}    ${username}
    Sleep    ${DELAY_ACCION}
    Input Password    ${campo_pass_locator}    ${password}
    Sleep    ${DELAY_ACCION}
    Click Button    ${campo_submit_locator}
    Sleep    ${DELAY_ACCION}
    IF    '${accion}' == 'login'
        Verificar Error Login    ${campo_error_locator}    ${expected_error_text}    ${dataset_id}
        Verificar Bloqueo Si Aplica    ${dataset_id}    ${campo_bloqueo_locator}    ${expected_bloqueo_text}
    ELSE IF    '${accion}' == 'verificar_bloqueo'
        Verificar Cuenta Bloqueada    ${campo_bloqueo_locator}    ${expected_bloqueo_text}    ${dataset_id}
    END

Verificar Error Login
    [Arguments]    ${campo_error_locator}    ${expected_error_text}    ${dataset_id}
    ${tiene_error}=    Run Keyword And Return Status
    ...    Element Should Be Visible    ${campo_error_locator}
    Run Keyword If    ${tiene_error}
    ...    Verificar Mensaje En Elemento    ${campo_error_locator}    ${expected_error_text}
    Run Keyword If    not ${tiene_error}
    ...    Fail    msg=Se esperaba error de login en ${dataset_id} pero el sistema permitió el acceso.

Verificar Bloqueo Si Aplica
    [Arguments]    ${dataset_id}    ${campo_bloqueo_locator}    ${expected_bloqueo_text}
    ${bloqueo_esperado}=    Run Keyword And Return Status
    ...    Should Not Be Empty    ${expected_bloqueo_text}
    Run Keyword If    ${bloqueo_esperado} and '${expected_bloqueo_text}' != 'NONE'
    ...    Verificar Mensaje En Elemento    ${campo_bloqueo_locator}    ${expected_bloqueo_text}

Verificar Cuenta Bloqueada
    [Arguments]    ${campo_bloqueo_locator}    ${expected_bloqueo_text}    ${dataset_id}
    Wait Until Element Is Visible    ${campo_bloqueo_locator}    timeout=10s
    ${texto_real}=    Get Text    ${campo_bloqueo_locator}
    Should Contain    ${texto_real}    ${expected_bloqueo_text}
    ...    msg=El sistema NO bloqueó la cuenta tras 3 intentos fallidos en ${dataset_id}. Texto real: ${texto_real}