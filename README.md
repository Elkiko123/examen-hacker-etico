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
- **Acceso con cuenta** (login / registro) mediante **Supabase** — obligatorio para entrar al examen
- **Registro de accesos**: IP, ciudad, país, red/ISP, dispositivo, navegador y sistema operativo de cada inicio de sesión, visible en un **panel de administrador** dentro de la página y en la tabla `login_events` de Supabase
- Revisión completa con respuesta correcta, tu respuesta y explicación bilingual
- Interfaz profesional y minimalista, responsive (mobile)

## Estructura

| Archivo | Contenido |
|---|---|
| `index.html` | Todo en un solo archivo: datos de las preguntas (EN/ES), lógica, autenticación y estilos |
| `supabase-schema.sql` | Esquema de base de datos: perfiles, accesos, administradores, RLS y triggers |

## Acceso (Supabase)

1. Crea un proyecto en [supabase.com](https://supabase.com) (New project).
2. En **SQL Editor → New query**, pega y ejecuta todo el contenido de `supabase-schema.sql`.
3. En **Auth → Sign In / Providers → Email**, desactiva *Confirm email* (para poder entrar de inmediato tras registrarte).
4. En **Settings → API**, copia la *Project URL* y la *anon public key* y pega ambas en `index.html`:

```js
const SUPABASE_URL="https://TU-PROYECTO.supabase.co";
const SUPABASE_ANON_KEY="TU-ANON-KEY";
```

5. Pon tu correo en `supabase-schema.sql` (tabla `admins`) y vuelve a ejecutarlo para que seas administrador y puedas ver el botón **📋 Accesos**.

## Publicación

La página está publicada con **GitHub Pages** desde la rama `main`:

<https://elkiko123.github.io/examen-hacker-etico/>
