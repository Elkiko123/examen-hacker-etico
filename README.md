# Examen Final · Hacker Ético

Examen final del curso **Ethical Hacker (Course Final Exam — Self-Paced)** con **50 preguntas**, presentación en **orden aleatorio**, puntaje, aprobado/reprobado (70 %) y retroalimentación con la respuesta correcta y su explicación.

📄 Contenido textual original de [ITExamAnswers.net](https://itexamanswers.net/ethical-hacker-course-final-exam-answers-self-paced.html) · **EN original + ES traducción** (texto en español idéntico al PDF del curso).

## Cómo usarlo

Abre `index.html` en cualquier navegador (no requiere servidor ni dependencias):

```
doble clic en index.html
```

O si prefieres servirlo localmente:

```bash
npx serve .
```

## Características

- **50 preguntas** (4 de opción múltiple con exhibit/imagen, 7 de relación)
- **Orden aleatorio** de preguntas y de opciones (configurable al iniciar)
- **Tres modos de idioma**: English · Español · EN + ES a la vez
- **Retroalimentación inmediata** opcional por pregunta, o al finalizar
- **Puntaje, aprobado/reprobado** (mínimo 70 %) y tiempo
- **Ejercicios de relación** a dos columnas (conceptos ↔ descripciones) unidos con **líneas**: clic en un concepto, clic en su descripción; se califican en verde/rojo al comprobar
- **Acceso con cuenta** (nombre de usuario + contraseña) mediante **Supabase** — obligatorio para entrar al examen
- **Registro de accesos**: IP, ciudad, país, red/ISP, dispositivo, navegador y sistema operativo de cada inicio de sesión, visible en un **panel de administrador** dentro de la página y en la tabla `login_events` de Supabase
- Revisión completa con respuesta correcta, tu respuesta y explicación bilingual
- Interfaz profesional y minimalista, responsive (mobile)

## Estructura

| Archivo | Contenido |
|---|---|
| `index.html` | Todo en un solo archivo: datos de las preguntas (EN/ES), lógica, autenticación y estilos |
| `supabase-schema.sql` | Esquema de base de datos: perfiles, accesos, administradores, RLS y triggers |

## Acceso (Supabase)

El acceso usa **nombre de usuario + contraseña** (no se pide correo). Internamente Supabase
Auth sí necesita un identificador tipo correo: se genera automáticamente
`usuario@examen-hacker-etico.local`, que nunca se muestra al usuario.

1. Crea un proyecto en [supabase.com](https://supabase.com) (New project).
2. En **SQL Editor → New query**, pega y ejecuta todo el contenido de `supabase-schema.sql`.
3. En **Authentication → Sign In / Providers → Email**, desactiva **Confirm email** —
   es obligatorio, si no, el registro no podrá completarse (nadie puede confirmar ese correo sintético).
4. En **Project Settings → API**, copia la *Project URL* y la clave *publishable* y pega ambas en `index.html`:

```js
const SUPABASE_URL="https://TU-PROYECTO.supabase.co";
const SUPABASE_ANON_KEY="sb_publishable_...";
```

5. En `supabase-schema.sql` (tabla `admins`) pon el correo del administrador y vuelve a
   ejecutarlo para que pueda ver el botón **📋 Accesos**.

## Publicación

La página está publicada con **GitHub Pages** desde la rama `main`:

<https://elkiko123.github.io/examen-hacker-etico/>
