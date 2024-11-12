# Citas Medicas

Este proyecto es una aplicación web que permite a los usuarios agendar citas médicas con diferentes especialidades. La aplicación permite a los usuarios registrarse, iniciar sesión, agendar citas, ver sus citas agendadas y cancelarlas.

## Plan del proyecto

Sin excepción todos los usuraios tendrán que loguearse en el sistema para que este pueda definir el role de quién está ingresando al sistema y de esa manera poder mostrarle la información que le corresponde.

No vamos a considerar la autenticación de los usuarios con proveedores externos como Google, Facebook y vamos a utilizar un sistema de autenticación simple con email y contraseña como el que vimos en clase.

## Base de datos:
>  -  Se tendrá una tabla de **roles** para definir los roles de los usuarios.
>  - Se tendrá una tabla de **usuarios** para guardar la información de los usuarios.
>  - Se tendrá una tabla de **especialidades** para guardar las especialidades de los médicos.
>  - Se tendrá una tabla de **medicos** para guardar la información de los médicos.
>  - Se tendrá una tabla **doctor_especialidad** para guardar la relación entre los médicos y las especialidades.
>  - Se tendrá una tabla de **citas** para guardar la información de las citas médicas.
>  - Se tendrá una tabla de **clinicas** para guardar la información de las clinicas.

La tabla las vamos a crear en TURSO para tener nuestra base de datos en la nube.

El siguiente es el código SQL para crear las tablas en TURSO.

```sql
CREATE TABLE roles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT UNIQUE NOT NULL
);

CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    edad INTEGER NOT NULL,
    email TEXT UNIQUE NOT NULL,
    tipo_documento TEXT NOT NULL,
    documento TEXT UNIQUE NOT NULL,
    telefono TEXT NOT NULL,
    celular TEXT NOT NULL,
    direccion TEXT NOT NULL,
    rol_id TEXT NOT NULL
    token TEXT UNIQUE NOT NULL,
    password TEXT,
    FOREIGN KEY (rol_id) REFERENCES roles(id)
);

CREATE TABLE especialidades (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT UNIQUE NOT NULL
);

CREATE TABLE clinicas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT UNIQUE NOT NULL,
    direccion TEXT NOT NULL,
    telefono TEXT NOT NULL
);

CREATE TABLE citas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    paciente_id INTEGER NOT NULL,
    medico_id INTEGER NOT NULL,
    especialidad_id INTEGER NOT NULL,
    clinica_id INTEGER NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    estado TEXT NOT NULL,
    FOREIGN KEY (paciente_id) REFERENCES patients(id),
    FOREIGN KEY (medico_id) REFERENCES doctors(id),
    FOREIGN KEY (especialidad_id) REFERENCES specialties(id),
    FOREIGN KEY (clinica_id) REFERENCES clinics(id)
);

CREATE TABLE doctor_especilidad (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    medico_id INTEGER NOT NULL,
    especialidad_id INTEGER NOT NULL,
    FOREIGN KEY (medico_id) REFERENCES doctors(id),
    FOREIGN KEY (especialidad_id) REFERENCES specialties(id)
);

```

## configuramos drizzle para que se conecte a nuestra base de datos en TURSO

Para ello vamos a crear un archivo .env en la raíz del proyecto con los parámetros de conexión a la base de datos.

```bash
DATABASE_URL="Aqui escribes el url que te dá turso para la base de datos"
DATABASE_TOKEN="Aqui escribes el token que te dá turso para la base de datos"
```
Creado el archivo anterior, vamos a instalar las dependencias necesarias para que drizzle pueda conectarse a la base de datos.

```bash
bun add drizzle-orm @libsql/client
bun add -D drizzle-kit
```

## Configuramos el archivo drizzle.config.ts
Este archivo se encuentra en la raíz del proyecto y es el encargado de configurar la conexión a la base de datos, pues contiene toda la información sobre esta y lo archivos de eschema.

    > "En Drizzle, los archivos de esquemas (schemas) son archivos que definen la estructura de tu base de datos. Estos archivos especifican las tablas, columnas, tipos de datos y relaciones entre las tablas en tu base de datos.

    Los esquemas son esenciales para que DRIZZLE pueda entender cómo está organizada tu base de datos y cómo debe manejar las migraciones y las conexiones. Los archivos de esquemas permiten a Drizzle generar y aplicar migraciones de manera consistente y segura, asegurando que la estructura de la base de datos esté siempre en sincronía con el código de tu aplicación.

    Por lo general, estos archivos están escritos en TypeScript o JavaScript y siguen una sintaxis específica que Drizzle puede interpretar."


Creemos entonces un archivo llamado drizzle.config.ts en la raíz del proyecto con el siguiente contenido.

```typescript
import 'dotenv/config';
import { defineConfig } from 'drizzle-kit';
export default defineConfig({
  out: './drizzle',
  schema: './src/server/db/schema.ts',
  dialect: 'turso',
  dbCredentials: {
    url: process.env.DATABASE_URL,
    authToken: process.DATABASE_TOKEN,
  },
});
```
## Generar un archivo de esquema para la nuestra base de datos:

- Drizzle Kit tiene un comando que puedes usar en la terminal para revisar tu base de datos. Este comando crea un archivo que describe cómo está organizada tu base de datos, incluyendo las tablas, columnas, relaciones e índices. Este archivo se llama "archivo de esquema" y es útil para mantener tu base de datos y tu código sincronizados.


Para crear el archivo de esquema vamos a utilizar el siguiente comando que nos proporcionna la libreria drizzle-kit que instalamos hace un momento:

```bash
bunx drizzle-kit pull
```

El anterior comando nos dará el resultado de la inspección será un archivo `schema.ts`, una carpeta `meta` con instantáneas del esquema de tu base de datos, un archivo SQL con la migración y un archivo `relations.ts` para [consultas relacionales](https://orm.drizzle.team/docs/rqb).

Todo ello quedará en el directorio raíz del proyecto dentro de la carpeta **drizzle** que indicamos en el archivo **"drizzle-config.ts"**



        ├ 📂 drizzle
        │ ├ 📂 meta
        │ ├ 📜 migration.sql
        │ ├ 📜 relations.ts ────────┐
        │ └ 📜 schema.ts ───────────┤
        ├ 📂 src                    │ 
        │  └ 📂 lib                 │
        │   └ 📂 server             │
        │     ├ 📜 relations.ts <───┤
        │     └ 📜 schema.ts <──────┘
        │              
        └ …


## Transfiere el código a tu archivo de esquema real
Transferir el código generado de *"drizzle/schema.ts"* y *"drizzle/relations.ts"* al archivo de esquema real. En esta guía, transferimos el código a *"src/lib/server/schema.ts"*. Los archivos originales para el esquema y las relaciones pueden ser eliminados. De esta manera, puedes gestionar tu esquema de una manera más estructurada.


## Conectar Drizzle a la base de datos

Creamos un archivo `index.ts`  en la carpeta `src/lib/server/` e inicializamos la conexión:

        ├ 📂 drizzle
        │ ├ 📂 meta
        │ ├ 📜 migration.sql
        │ ├ 📜 relations.ts 
        │ └ 📜 schema.ts 
        ├ 📂 src     
        │  └ 📂 lib    
        │   └ 📂 server             
        │     ├ 📜 relations.ts
        │     ├ 📜 relations.ts       
        │     └ 📜 schema.ts
        └ …

```typescript
import 'dotenv/config';
import { drizzle } from 'drizzle-orm/libsql';
import { createClient } from '@libsql/client';
const client = createClient({ 
  url: process.env.TURSO_DATABASE_URL!, 
  authToken: process.env.TURSO_AUTH_TOKEN!
});
const db = drizzle({ client });
```

1  - **Paciente**: Podrá agendar citas con los médicos y ver o modificar las citas que tiene agendadas. Para ello vamos a realizar los siguientes pasos.
  -  Crear ruta de pacientes, con subrutas para el agendamiento de citas, la modificación de citas y la cancelación de citas


Debes crear un nuevo proyecto de sveltekit en donde pondremos el código de la aplicación.

```bash
# crear un proyecto nuevo en la carpeta actual
bunx sv create citas-medicas

```

## Desarrollo

Once you've created a project and installed dependencies with `npm install` (or `pnpm install` or `yarn`), start a development server:

```bash
npm run dev

# or start the server and open the app in a new browser tab
npm run dev -- --open
```

## Building

To create a production version of your app:

```bash
npm run build
```

You can preview the production build with `npm run preview`.

> To deploy your app, you may need to install an [adapter](https://svelte.dev/docs/kit/adapters) for your target environment.
