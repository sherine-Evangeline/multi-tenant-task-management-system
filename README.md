# Multi-Tenant Task Management System

A full-stack multi-tenant task management platform built with **Java Spring Boot**, **React.js**, **MySQL/H2**, **JWT authentication**, and **Docker**.

Multiple organizations can manage their own tasks securely with strict data isolation and role-based access control (RBAC).

---

## 🏗️ Tech Stack

| Layer            | Technology                          |
| ---------------- | ----------------------------------- |
| **Backend**      | Java 17, Spring Boot 3.2, Spring Security, Spring Data JPA |
| **Frontend**     | React 18, Vite 5, React Router 6, Axios |
| **Database**     | H2 (development) / MySQL 8 (Docker) |
| **Auth**         | JWT (jjwt 0.12.5) + BCrypt          |
| **Container**    | Docker, Docker Compose               |

---

## 📁 Project Structure

```
Multi-Tenant Task Management System/
├── backend/
│   ├── src/main/java/com/taskmanager/
│   │   ├── config/          # Security, CORS, JWT filter
│   │   ├── controller/      # REST API controllers
│   │   ├── dto/             # Request/Response DTOs
│   │   ├── entity/          # JPA entities
│   │   ├── enums/           # Role, TaskStatus, ActionType
│   │   ├── exception/       # Global error handling
│   │   ├── repository/      # Spring Data repositories
│   │   ├── security/        # JWT utility
│   │   └── service/         # Business logic
│   ├── src/main/resources/
│   │   ├── application.properties          # H2 (default)
│   │   └── application-docker.properties   # MySQL
│   ├── Dockerfile
│   └── pom.xml
├── frontend/
│   ├── src/
│   │   ├── api/             # Axios instance with JWT interceptor
│   │   ├── components/      # Navbar, TaskForm, TaskTable, ProtectedRoute
│   │   ├── context/         # AuthContext
│   │   └── pages/           # Login, Register, Dashboard
│   ├── Dockerfile
│   ├── nginx.conf
│   └── package.json
├── docker-compose.yml
└── README.md
```

---

## 🔐 Features

### Authentication & Authorization
- **JWT-based** stateless authentication
- **BCrypt** password encryption
- **Role-Based Access Control (RBAC)**:
  - `ADMIN` — Full CRUD on all tasks within their organization
  - `MEMBER` — Create tasks + CRUD only on their own tasks

### Multi-Tenant Isolation
- Every user belongs to an organization via `organizationId`
- Users can **only** access data from their own organization
- Strict data isolation enforced at the service layer

### Task Management
- Create, Read, Update, Delete tasks
- Task statuses: `PENDING`, `IN_PROGRESS`, `COMPLETED`
- Organization-scoped task listing

### Activity Logging
- Immutable audit trail for all task actions (`CREATED`, `UPDATED`, `DELETED`)
- Organization-scoped log retrieval

---

## 🚀 Getting Started

### Prerequisites

- **Java 17+** (for local backend)
- **Maven 3.8+** (for local backend)
- **Node.js 18+** & **npm** (for local frontend)
- **Docker & Docker Compose** (for containerized deployment)

---

### Option 1: Run Locally (H2 Database)

#### 1. Start the Backend

```bash
cd backend
mvn clean spring-boot:run
```

The backend starts on `http://localhost:8080` with an H2 in-memory database.

> H2 Console available at: `http://localhost:8080/h2-console`
> - JDBC URL: `jdbc:h2:mem:taskdb`
> - Username: `sa` / Password: *(empty)*

#### 2. Start the Frontend

```bash
cd frontend
npm install
npm run dev
```

The frontend starts on `http://localhost:5173` with API proxy to the backend.

#### 3. Open in Browser

Navigate to `http://localhost:5173`

---

### Option 2: Run with Docker Compose (MySQL)

```bash
# From the project root directory
docker-compose up --build
```

| Service    | URL                          |
| ---------- | ---------------------------- |
| Frontend   | `http://localhost:3000`       |
| Backend    | `http://localhost:8080`       |
| MySQL      | `localhost:3306` (taskdb)     |

To stop:
```bash
docker-compose down
```

To stop and remove volumes:
```bash
docker-compose down -v
```

---

## 📡 API Endpoints

### Authentication (Public)

| Method | Endpoint             | Description     |
| ------ | -------------------- | --------------- |
| POST   | `/api/auth/register` | Register user   |
| POST   | `/api/auth/login`    | Login user      |

**Register Request Body:**
```json
{
  "name": "John Doe",
  "email": "john@acme.com",
  "password": "password123",
  "organizationId": "acme-corp",
  "role": "ADMIN"
}
```

**Login Request Body:**
```json
{
  "email": "john@acme.com",
  "password": "password123"
}
```

**Auth Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "userId": 1,
  "name": "John Doe",
  "email": "john@acme.com",
  "role": "ADMIN",
  "organizationId": "acme-corp"
}
```

### Tasks (Requires JWT)

| Method | Endpoint          | Description      | Headers                          |
| ------ | ----------------- | ---------------- | -------------------------------- |
| POST   | `/api/tasks`      | Create task      | `Authorization: Bearer <token>`  |
| GET    | `/api/tasks`      | List tasks       | `Authorization: Bearer <token>`  |
| GET    | `/api/tasks/{id}` | Get task by ID   | `Authorization: Bearer <token>`  |
| PUT    | `/api/tasks/{id}` | Update task      | `Authorization: Bearer <token>`  |
| DELETE | `/api/tasks/{id}` | Delete task      | `Authorization: Bearer <token>`  |

### Activity Logs (Requires JWT)

| Method | Endpoint     | Description                    |
| ------ | ------------ | ------------------------------ |
| GET    | `/api/logs`  | Get logs for same organization |

---

## 🧪 Testing the Flow

1. **Register** an ADMIN user for organization `acme-corp`
2. **Register** a MEMBER user for the same organization `acme-corp`
3. **Register** a user for a different organization `beta-inc`
4. Login as ADMIN → Create tasks → See all org tasks
5. Login as MEMBER → Create tasks → See only their own tasks
6. Login as `beta-inc` user → Verify zero visibility into `acme-corp` tasks
7. Check activity logs for audit trail

---

## 🛡️ Security Notes

- JWT tokens expire after **24 hours** (configurable via `jwt.expiration-ms`)
- Passwords are **never** stored in plaintext — BCrypt with default strength
- All API endpoints (except auth) require a valid JWT
- Organization isolation is enforced at the **service layer**, not just the query level
- CORS is configured to allow all origins in development — restrict in production

---

## 📝 License

This project is for educational and demonstration purposes.
