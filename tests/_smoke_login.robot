*** Settings ***
Resource    ${CURDIR}/../resources/common.resource

*** Test Cases ***
Smoke Login Admin
    Abrir Navegador PETS
    Hacer Login    qa_admin    Admin@2026!
    Verificar Login Exitoso
    Hacer Logout
    Cerrar Navegador PETS