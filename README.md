# PETS S.A. — Suite de Automatización de Pruebas

Suite de pruebas automatizadas para el sistema PETS S.A., desarrollada con Robot Framework y SeleniumLibrary. Cubre 5 escenarios críticos de calidad: seguridad, control de acceso, unicidad, bloqueo de cuenta y CRUD de mascotas.

---

## Stack Tecnológico

| Herramienta | Versión |
|---|---|
| Python | 3.14 |
| robotframework | 7.4.2 |
| robotframework-seleniumlibrary | 6.8.0 |
| robotframework-datadriver | 1.11.2 |
| robotframework-screencaplibrary | 1.6.0 |
| Navegador | Google Chrome (última versión) |
| OS | Windows |

---

## Estructura del Proyecto
```text
pets_sa_suite/
├── results/ # Resultados de ejecución (ignorado por git)
├── tests/
│ ├── esc01_xss_sqli.robot
│ ├── esc02_acceso.robot
│ ├── esc03_unicidad.robot
│ ├── esc04_bloqueo.robot
│ └── esc05_crud_masc.robot
├── resources/
│ └── common.resource
├── Dataset-Escenarios-PETS-SA.xlsx
└── README.md
```
---

## Escenarios Automatizados

| # | Archivo | Escenario | RF/RNF | Dataset IDs |
|---|---------|-----------|--------|-------------|
| 1 | esc01_xss_sqli.robot | Inyección XSS y SQLi | RNF04 | C-I-05, MED-I-03 |
| 2 | esc02_acceso.robot | Control de acceso por rol cruzado | RF04, RNF02 | ACC-VET-CLI, ACC-REC-MED, ACC-REC-USR, ACC-VET-USR |
| 3 | esc03_unicidad.robot | Validación de unicidad | RF24, RF25 | C-I-01, M-I-01 |
| 4 | esc04_bloqueo.robot | Bloqueo por 3 intentos fallidos | RF03, RNF03 | BLOQUEO-INTENTO-1, 2, 3, BLOQUEO-VERIFY |
| 5 | esc05_crud_masc.robot | CRUD completo de Mascota | RF09, RF11, RF12 | M-V-01, M-EDIT-01, M-DEL-01 |

---

## Instalación

```bash
pip install robotframework==7.4.2
pip install robotframework-seleniumlibrary==6.8.0
pip install robotframework-datadriver==1.11.2
pip install robotframework-screencaplibrary==1.6.0
pip install opencv-python-headless
```

Asegurate de tener ChromeDriver instalado y compatible con tu versión de Chrome.

---

## Ejecución

### Un escenario individual

```bash
python -m robot --outputdir results/esc01 tests/esc01_xss_sqli.robot

python -m robot --outputdir results/esc02 tests/esc02_acceso.robot

python -m robot --outputdir results/esc03 tests/esc03_unicidad.robot

python -m robot --outputdir results/esc04 tests/esc04_bloqueo.robot

python -m robot --outputdir results/esc05 tests/esc05_crud_masc.robot
```

### Suite completa

```bash
python -m robot --outputdir results/full tests/
```

### Orden recomendado de ejecución

```bash
python -m robot --outputdir results/esc01 tests/esc01_xss_sqli.robot
python -m robot --outputdir results/esc02 tests/esc02_acceso.robot
python -m robot --outputdir results/esc05 tests/esc05_crud_masc.robot
python -m robot --outputdir results/esc03 tests/esc03_unicidad.robot
python -m robot --outputdir results/esc04 tests/esc04_bloqueo.robot
```

> **Nota:** ESC05 debe ejecutarse antes que ESC03 para que `MASC-001` exista en BD al momento de validar unicidad.

---

## Precondiciones de Datos

| Escenario | Precondición |
|-----------|-------------|
| ESC03 — Unicidad | Ejecutar ESC05 primero para que `MASC-001` exista en BD |
| ESC04 — Bloqueo | `qa_bloqueo` debe estar desbloqueado antes de cada ejecución |
| ESC05 — CRUD | `MASC-003` debe existir en BD para el caso de eliminación |

---

## Restauración de BD Post-Ejecución

Después de correr la suite completa, el SUT queda con datos modificados. Ejecutá estos pasos manualmente para dejarlo en el estado original.

### ESC01 — XSS / SQLi
- Ir a **Clientes** → eliminar el cliente con cédula `1067890123` (creado por C-I-05, si el sistema lo aceptó).
- Ir a **Medicamentos** → eliminar el medicamento con nombre `<script>alert(1)</script>` (creado por MED-I-03, si el sistema lo aceptó).

### ESC05 — CRUD Mascota
El escenario crea `MASC-001` (M-V-01), lo edita (M-EDIT-01) y elimina `MASC-003` (M-DEL-01).

1. Ir a **Mascotas** → eliminar `MASC-001` si aún existe.
2. Recrear `MASC-003` con estos datos:

| Campo | Valor |
|---|---|
| ID | MASC-003 |
| Nombre | Max |
| Raza | Bulldog |
| Edad | 5 |
| Peso | 18.00 |
| Medicamento | (ninguno) |
| Cliente | Carlos Pérez |

### ESC04 — Bloqueo
- Ir a **Usuarios** → buscar `qa_bloqueo` → **Editar** → desbloquear la cuenta antes de la próxima ejecución.

### Orden recomendado de restauración
1. Desbloquear `qa_bloqueo` (ESC04)
2. Eliminar registros maliciosos de Clientes y Medicamentos (ESC01)
3. Eliminar `MASC-001` (ESC05)
4. Recrear `MASC-003` (ESC05)

## Cuentas de Prueba

---

| Usuario | Contraseña | Rol |
|---------|-----------|-----|
| qa_admin | Admin@2026! | Admin |
| qa_vet | Vet@2026! | Veterinario |
| qa_recep | Recep@2026! | Recepcionista |
| qa_bloqueo | Bloq@2026! | Exclusivo para ESC04 |

---

## Resultados

Cada ejecución genera en su carpeta `results/escXX/`:
- `output.xml` — datos completos de la ejecución
- `log.html` — log detallado navegable
- `report.html` — reporte resumen
- Videos `.webm` por test case grabados con ScreenCapLibrary

---

## URL Base del SUT

https://EyderAlexis26.pythonanywhere.com

