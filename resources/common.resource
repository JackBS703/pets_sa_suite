*** Settings ***
Library    SeleniumLibrary
Library    ScreenCapLibrary
Library    OperatingSystem
Library    String
Library    Collections

*** Variables ***
${BASE_URL}         https://EyderAlexis26.pythonanywhere.com
${BROWSER}          chrome
${IMPLICIT_WAIT}    10s
${LOGIN_URL}        ${BASE_URL}/login/
${LOGOUT_URL}       ${BASE_URL}/logout/

${DELAY_ACCION}     0.5s
${DELAY_FIN}        0.5s

${LOC_USER}         id:id_username
${LOC_PASS}         id:id_password
${LOC_SUBMIT}       css:button[type='submit']

${MSG_LOGIN_ERROR}   Por favor, introduzca un nombre de usuario y clave correctos. Observe que ambos campos pueden ser sensibles a mayúsculas.
${MSG_BLOQUEADO}     Tu usuario fue bloqueado por 3 intentos fallidos. Contacta al administrador.

${LOC_ERROR_BOX}     css:div.error-box
${LOC_ALERT}         css:div.alert
${LOC_FIELD_ERROR}   css:p.field-error
${LOC_NAV_LEFT}      css:div.nav-left

${LOC_BTN_GREEN}     css:button.btn-green
${LOC_BTN_RED}       css:button.btn-red
${LOC_TABLE_ROWS}    css:table tbody tr
${LOC_BTN_EDIT}      css:a.btn-yellow
${LOC_BTN_DEL}       css:a.btn-red

${VIDEO_DIR}         ${CURDIR}${/}..${/}results

*** Keywords ***
Abrir Navegador PETS
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Implicit Wait    ${IMPLICIT_WAIT}

Cerrar Navegador PETS
    Close Browser

Hacer Login
    [Arguments]    ${username}    ${password}
    Go To    ${LOGIN_URL}
    Wait Until Element Is Visible    ${LOC_USER}
    Input Text    ${LOC_USER}    ${username}
    Sleep    ${DELAY_ACCION}
    Input Password    ${LOC_PASS}    ${password}
    Sleep    ${DELAY_ACCION}
    Click Button    ${LOC_SUBMIT}
    Sleep    ${DELAY_ACCION}

Hacer Logout
    Go To    ${LOGOUT_URL}
    Sleep    ${DELAY_ACCION}
    Wait Until Element Is Visible    ${LOC_USER}

Verificar Login Exitoso
    Wait Until Element Is Visible    ${LOC_NAV_LEFT}    timeout=10s
    Sleep    ${DELAY_ACCION}

Navegar A Modulo
    [Arguments]    ${ruta}
    Go To    ${BASE_URL}${ruta}
    Sleep    ${DELAY_ACCION}

Iniciar Grabacion De Video
    [Arguments]    ${nombre_archivo}
    Start Video Recording    name=${nombre_archivo}    fps=5    size_percentage=0.75

Detener Y Guardar Video
    Run Keyword And Ignore Error    Stop Video Recording

Limpiar Y Escribir
    [Arguments]    ${locator}    ${valor}
    ${valor_str}=    Convert To String    ${valor}
    ${valor_str}=    Evaluate    $valor_str.replace('.0', '') if $valor_str.endswith('.0') else $valor_str
    Wait Until Element Is Visible    ${locator}    timeout=10s
    Clear Element Text    ${locator}
    Input Text    ${locator}    ${valor_str}
    Sleep    ${DELAY_ACCION}

Seleccionar Opcion Por Texto
    [Arguments]    ${locator}    ${texto}
    Wait Until Element Is Visible    ${locator}    timeout=10s
    Select From List By Label    ${locator}    ${texto}
    Sleep    ${DELAY_ACCION}

Hacer Clic En Accion De Fila
    [Arguments]    ${texto_busqueda}    ${clase_boton}
    ${locator}=    Set Variable
    ...    xpath://table/tbody/tr[td[normalize-space(text())='${texto_busqueda}']]/td//a[contains(@class,'${clase_boton}')]
    Wait Until Element Is Visible    ${locator}    timeout=10s
    Click Element    ${locator}
    Sleep    ${DELAY_ACCION}

Verificar Mensaje En Elemento
    [Arguments]    ${locator}    ${texto_esperado}
    Wait Until Element Is Visible    ${locator}    timeout=10s
    ${texto_real}=    Get Text    ${locator}
    Should Contain    ${texto_real}    ${texto_esperado}
    Sleep    ${DELAY_ACCION}

Verificar URL Contiene
    [Arguments]    ${fragmento}
    ${url_actual}=    Get Location
    Should Contain    ${url_actual}    ${fragmento}
    Sleep    ${DELAY_ACCION}

Test Setup Con Video
    Iniciar Grabacion De Video    ${TEST NAME}

Test Teardown Con Video
    Run Keyword And Ignore Error    Hacer Logout
    Detener Y Guardar Video
    Run Keyword If    '${TEST STATUS}' == 'FAIL'    Capture Page Screenshot

Setup Suite Con Video
    Abrir Navegador PETS

Teardown Suite Con Video
    Cerrar Navegador PETS