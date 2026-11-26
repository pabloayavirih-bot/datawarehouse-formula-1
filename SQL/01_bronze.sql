
-- ==================================================
-- PROYECTO FINAL - FORMULA 1 (1950-2024)
-- Base de datos: dw_formula_1
-- CAPA BRONZE
-- ==================================================

IF SCHEMA_ID('bronze') IS NULL
    EXEC('CREATE SCHEMA bronze');

-- ==================================================
-- 1. CIRCUITOS
-- ==================================================

CREATE TABLE bronze.circuits (
    circuitId     NVARCHAR(50),
    circuitRef    NVARCHAR(100),
    name          NVARCHAR(200),
    location      NVARCHAR(200),
    country       NVARCHAR(100),
    lat           NVARCHAR(50),
    lng           NVARCHAR(50),
    alt           NVARCHAR(50),
    url           NVARCHAR(500)
);

-- ==================================================
-- 2. CONSTRUCTORES
-- ==================================================

CREATE TABLE bronze.constructors (
    constructorId  NVARCHAR(50),
    constructorRef NVARCHAR(100),
    name           NVARCHAR(200),
    nationality    NVARCHAR(100),
    url            NVARCHAR(500)
);

-- ==================================================
-- 3. PILOTOS
-- ==================================================

CREATE TABLE bronze.drivers (
    driverId      NVARCHAR(50),
    driverRef     NVARCHAR(100),
    number        NVARCHAR(50),
    code          NVARCHAR(50),
    forename      NVARCHAR(100),
    surname       NVARCHAR(100),
    dob           NVARCHAR(50),
    nationality   NVARCHAR(100),
    url           NVARCHAR(500)
);

-- ==================================================
-- 4. CARRERAS
-- ==================================================

CREATE TABLE bronze.races (
    raceId        NVARCHAR(50),
    [year]        NVARCHAR(50),
    [round]       NVARCHAR(50),
    circuitId     NVARCHAR(50),
    name          NVARCHAR(200),
    [date]        NVARCHAR(50),
    [time]        NVARCHAR(50),
    url           NVARCHAR(500),
    fp1_date      NVARCHAR(50),
    fp1_time      NVARCHAR(50),
    fp2_date      NVARCHAR(50),
    fp2_time      NVARCHAR(50),
    fp3_date      NVARCHAR(50),
    fp3_time      NVARCHAR(50),
    quali_date    NVARCHAR(50),
    quali_time    NVARCHAR(50),
    sprint_date   NVARCHAR(50),
    sprint_time   NVARCHAR(50)
);

-- ==================================================
-- 5. RESULTADOS DE CARRERAS
-- ==================================================

CREATE TABLE bronze.results (
    resultId        NVARCHAR(50),
    raceId          NVARCHAR(50),
    driverId        NVARCHAR(50),
    constructorId   NVARCHAR(50),
    number          NVARCHAR(50),
    grid            NVARCHAR(50),
    position        NVARCHAR(50),
    positionText    NVARCHAR(50),
    positionOrder   NVARCHAR(50),
    points          NVARCHAR(50),
    laps            NVARCHAR(50),
    [time]          NVARCHAR(50),
    milliseconds    NVARCHAR(50),
    fastestLap      NVARCHAR(50),
    [rank]          NVARCHAR(50),
    fastestLapTime  NVARCHAR(50),
    fastestLapSpeed NVARCHAR(50),
    statusId        NVARCHAR(50)
);

-- ==================================================
-- 6. PARADAS EN BOXES
-- ==================================================

CREATE TABLE bronze.pit_stops (
    raceId        NVARCHAR(50),
    driverId      NVARCHAR(50),
    [stop]        NVARCHAR(50),
    lap           NVARCHAR(50),
    [time]        NVARCHAR(50),
    duration      NVARCHAR(50),
    milliseconds  NVARCHAR(50)
);

-- ==================================================
-- 7. ESTADOS DE CARRERA
-- ==================================================

CREATE TABLE bronze.status (
    statusId      NVARCHAR(50),
    status        NVARCHAR(200)
);

-- ==================================================
-- VERIFICACION DE TABLAS CREADAS
-- ==================================================

SELECT
    TABLE_SCHEMA AS Esquema,
    TABLE_NAME AS Tabla
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'bronze'
ORDER BY TABLE_NAME;
