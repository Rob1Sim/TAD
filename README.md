# Oracle Multi-Site Setup with Docker

This guide explains how to set up two Oracle Database containers using Docker, simulate two remote sites, and create a `DATABASE LINK` between them.

---

## ✨ Prerequisites
- Docker installed
- Optional: SQL Developer or SQL*Plus for connecting to the databases

---

## ✅ Step 1: Create a Docker Network
This will allow the containers to communicate with each other by name.

```bash
docker network create oracle-net
```

---

## ✅ Step 2: Run Two Oracle Containers
Here, we'll call the containers `cergy` and `pau`. Each container simulates a remote Oracle site.

```bash
# Cergy container
docker run -d --name cergy \
  --network oracle-net \
  -p 1521:1521 \
  -e ORACLE_PASSWORD=password \
  -v oracle-volume-cergy:/opt/oracle/oradata \
  gvenzl/oracle-free

# Pau container
docker run -d --name pau \
  --network oracle-net \
  -p 1522:1521 \
  -e ORACLE_PASSWORD=password \
  -v oracle-volume-pau:/opt/oracle/oradata \
  gvenzl/oracle-free
```

---

## ✅ Step 3: Test Container Communication
From within the `cergy` container, ping the `pau` container to verify network communication.

```bash
docker exec -it cergy bash
ping pau
```

---

## ✅ Step 4: Connect to the Oracle Database
Use any Oracle client (like SQL*Plus or SQL Developer) to connect:

- **Cergy DB**: `localhost:1521`, SID/Service: `FREE`
- **Pau DB**: `localhost:1522`, SID/Service: `FREE`
- **Username**: `SYSTEM`
- **Password**: `password`

---

## ✅ Step 5: Create a DATABASE LINK in Cergy
Connect to the Cergy database and run:

```sql
CREATE DATABASE LINK PAU
CONNECT TO SYSTEM IDENTIFIED BY "password"
USING 'pau:1521/FREE';

CREATE DATABASE LINK CERGY
CONNECT TO SYSTEM IDENTIFIED BY "password"
USING 'cergy:1521/FREE';
```

> Note: `pau` is the name of the container accessible from `cergy` via the Docker network.

---

## ✅ Step 6: Test the Database Link
Run the following query from Cergy:

```sql
SELECT * FROM DUAL@PAU;
```

If you get a result ("X"), the link is working!

---



