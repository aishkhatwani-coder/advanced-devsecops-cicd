# Advanced DevSecOps CI/CD Pipeline

Production-grade CI/CD pipeline featuring automated security quality gates, zero-downtime Blue-Green deployment, automated rollback, and real-time inventory synchronization.

---

## 🏗️ Architecture Overview
* **Frontend:** Interactive UI communicating with backend endpoints.
* **Backend:** .NET 8 Web API managing CRUD operations and DB connectivity.
* **Database:** PostgreSQL 15 persistent relational storage.
* **Gateway / Ingress:** Nginx Reverse Proxy (:80) routing to active environments.
* **Automation Server:** Jenkins LTS running containerized pipeline jobs.

---

## 🛡️ DevSecOps & Resilience Features
* **Secret Scanning:** Automated Gitleaks analysis to detect exposed credentials.
* **Vulnerability Scanning:** Container image security assessment via Trivy.
* **Pre-deployment Snapshot:** Automated `pg_dump` backup prior to deployment execution.
* **Blue-Green Deployment:** Independent Blue (Port 5001) and Green (Port 5002) container runtime.
* **Automated Health Probes:** HTTP status code validation prior to Nginx routing updates.
* **Resilient Rollback:** Automated failover retaining traffic on Blue if Green fails verification.

---

## 🚀 Deployment Verification
* **Public Gateway:** `http://<EC2-PUBLIC-IP>/`
* **Health Status Endpoint:** `http://<EC2-PUBLIC-IP>/api/health`
* **Product API:** `http://<EC2-PUBLIC-IP>/api/products`
