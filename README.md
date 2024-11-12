# Citas Medicas

Este proyecto es una aplicación web que permite a los usuarios agendar citas médicas con diferentes especialidades. La aplicación permite a los usuarios registrarse, iniciar sesión, agendar citas, ver sus citas agendadas y cancelarlas.

## Plan del proyecto

Sin excepción todos los usuarios tendrán que loguearse en el sistema para que este pueda definir el role de quién está ingresando y de esa manera poder mostrarle la información que le corresponde.

No vamos a considerar la autenticación de los usuarios con proveedores externos como Google, Facebook y vamos a utilizar un sistema de autenticación simple con email y contraseña como el que vimos en clase.

### Base de datos:
>  -  Se tendrá una tabla de **roles** para definir los roles de los usuarios.
>  - Se tendrá una tabla de **usuarios** para guardar la información de los usuarios.
>  - Se tendrá una tabla de **especialidades** para guardar las especialidades de los médicos.
>  - Se tendrá una tabla de **medicos** para guardar la información de los médicos.
>  - Se tendrá una tabla **doctor_especialidad** para guardar la relación entre los médicos y las especialidades.
>  - Se tendrá una tabla agenda para grabar las citas de un periódo de tiempo.
>  - Se tendrá una tabla de **citas** para guardar la información de las citas médicas.
>  - Se tendrá una tabla de **clinicas** para guardar la información de las clinicas.

La tabla las vamos a crear en TURSO para tener nuestra base de datos en la nube.

El siguiente es el código SQL para crear las tablas en TURSO.

```sql
DROP TABLE IF EXISTS citas;
DROP TABLE IF EXISTS agenda;
DROP TABLE IF EXISTS doctor_especialidad;
DROP TABLE IF EXISTS especialidades;
DROP TABLE IF EXISTS clinicas;
DROP TABLE IF EXISTS usuarios;
DROP TABLE IF EXISTS roles;

-- Crear tablas
CREATE TABLE roles (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nombre TEXT NOT NULL
);

CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    edad INTEGER NOT NULL,
    email TEXT NOT NULL,
    tipo_documento TEXT NOT NULL,
    documento TEXT NOT NULL UNIQUE,
    telefono TEXT,
    celular TEXT,
    direccion TEXT NOT NULL,
    rol_id INTEGER NOT NULL,
    password_hash TEXT NOT NULL,
    token_auth TEXT,
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (rol_id) REFERENCES roles(id) ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE clinicas (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nombre TEXT NOT NULL,
    direccion TEXT NOT NULL,
    telefono TEXT NOT NULL,
    email TEXT,
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE especialidades (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nombre TEXT NOT NULL,
    descripcion TEXT,
    created_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE doctor_especialidad (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    medico_id INTEGER NOT NULL,
    especialidad_id INTEGER NOT NULL,
    created_at TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (especialidad_id) REFERENCES especialidades(id) ON UPDATE NO ACTION ON DELETE NO ACTION,
    FOREIGN KEY (medico_id) REFERENCES usuarios(id) ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE agenda (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    fecha TEXT NOT NULL,
    hora TEXT NOT NULL,
    medico_id INTEGER NOT NULL,
    especialidad_id INTEGER NOT NULL,
    clinica_id INTEGER NOT NULL,
    disponible INTEGER DEFAULT 1,
    estado TEXT DEFAULT 'activo',
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now')),
    created_by INTEGER NOT NULL,
    FOREIGN KEY (created_by) REFERENCES usuarios(id) ON UPDATE NO ACTION ON DELETE NO ACTION,
    FOREIGN KEY (clinica_id) REFERENCES clinicas(id) ON UPDATE NO ACTION ON DELETE NO ACTION,
    FOREIGN KEY (especialidad_id) REFERENCES especialidades(id) ON UPDATE NO ACTION ON DELETE NO ACTION,
    FOREIGN KEY (medico_id) REFERENCES usuarios(id) ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE citas (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    agenda_id INTEGER NOT NULL,
    paciente_id INTEGER NOT NULL,
    fecha_reserva TEXT DEFAULT (datetime('now')),
    estado TEXT NOT NULL,
    motivo TEXT,
    notas_medicas TEXT,
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (paciente_id) REFERENCES usuarios(id) ON UPDATE NO ACTION ON DELETE NO ACTION,
    FOREIGN KEY (agenda_id) REFERENCES agenda(id) ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Crear índices
CREATE INDEX idx_usuarios_email ON usuarios(email);
CREATE INDEX idx_agenda_fecha_hora ON agenda(fecha, hora);
CREATE INDEX idx_agenda_medico ON agenda(medico_id);
CREATE INDEX idx_citas_agenda ON citas(agenda_id);

-- Insertar datos de prueba
-- Roles
INSERT INTO roles (nombre) VALUES
('admin'),
('medico'),
('paciente');



```

## Configuramos drizzle para que se conecte a nuestra base de datos en TURSO

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

### Creamos el archivo drizzle.config.ts
Este archivo lo debemos crear en la raíz del proyecto y es el encargado de configurar la conexión a la base de datos, pues contiene toda la información sobre esta y los archivos de eschema.

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
### Generar un archivo de esquema para la nuestra base de datos:

- Drizzle Kit tiene un comando que puedes usar en la terminal para revisar tu base de datos. Este comando crea un archivo que describe cómo está organizada tu base de datos, incluyendo las tablas, columnas, relaciones e índices. Este archivo se llama "archivo de esquema" y es útil para mantener tu base de datos y tu código sincronizados.


Para crear el archivo de esquema vamos a utilizar el siguiente comando que nos proporcionna la libreria drizzle-kit que instalamos hace un momento:

```bash
bunx drizzle-kit pull
```

El anterior comando nos dará el resultado de la inspección será un archivo `schema.ts`, una carpeta `meta` con instantáneas del esquema de tu base de datos, un archivo SQL con la migración y un archivo `relations.ts` para [consultas relacionales](https://orm.drizzle.team/docs/rqb).

Todo ello quedará en el directorio raíz del proyecto dentro de la carpeta `drizzle` que indicamos en el archivo **"drizzle-config.ts"**

## Copiar el código de la carpeta drizzle a su destino final
Se recomienda copiar los archivos drizzle/schema.ts y drizzle/relations.ts a la carpeta donde se almacenarán definitivamente en le proyecto. En este caso los vamos a dejar en src/server/db/. 

    ├ 📂 drizzle
    │ ├ 📂 meta
    │ ├ 📜 migration.sql
    │ ├ 📜 relations.ts ─────────┐
    │ └ 📜 schema.ts ────────────┤ 
    ├ 📂 src                     │
    └ 📂 db                      │
    │   └ 📂 server              │
    │     └ 📂 db                │
    │       ├ 📜 relations.ts <──│
    │       └ 📜 schema.ts <─────┘
    └ …

Pongo todas las definiciones de tablas y relaciones en un nuevo archivo que llamaré `data.ts`, por supuesto que no vamos a escribir todo eso nuevamente, sino que vamos a escribir en el lo siguiente, lo que equivaldría a lo mismo:

```typescript
    export * from `./relations`;
    export * from `./schema`;
```


    ├ 📂 src                     
    └ 📂 db                      
    │   └ 📂 server              
    │     └ 📂 db                
    │       ├ 📜 relations.ts 
    │       ├ 📜 schema.ts
    │       └ 📜 data.ts
    └ …

y modificamos el código de drizzle.config.ts, pues necesitamos cambiar la clave schema, para que ahora se haga referencia a data.ts:

```typescript
import 'dotenv/config';
import { defineConfig } from 'drizzle-kit';
export default defineConfig({
  out: './drizzle',
  schema: './src/server/db/data.ts', //cambiamos schema.ts por data.ts
  dialect: 'turso',
  dbCredentials: {
    url: process.env.DATABASE_URL,
    authToken: process.DATABASE_TOKEN,
  },
});
```
🥳 ✨ ***Felicidades*** 🥳 ✨, hemos conectado nuestra aplicación a la base de datos a través de drizzle
