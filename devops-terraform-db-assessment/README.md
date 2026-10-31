# DevOps Terraform Database Assessment

## 1. Project Overview

This project demonstrates an AWS-based infrastructure design using Terraform reusable modules, MySQL database management, Docker Compose, and GitHub Actions CI automation.

The solution follows a modular and environment-based approach, with separate Development and Production configurations.

**Key objectives:**
- Provision infrastructure using reusable Terraform modules.
- Design a scalable AWS architecture using ECS Fargate and RDS MySQL.
- Maintain separate Dev and Prod configurations.
- Manage MySQL schema migrations, indexes, and seed data.
- Implement database backup and restore procedures.
- Automate Terraform and Docker Compose validation using GitHub Actions.

## 2. Architecture

The proposed AWS architecture follows this flow:

Internet → Application Load Balancer → ECS Fargate → Private RDS MySQL

### AWS Components

- **VPC:** Isolated networking environment.
- **Public Subnets:** Host the Application Load Balancer.
- **Private Subnets:** Host ECS tasks and RDS resources.
- **Application Load Balancer:** Distributes incoming HTTP traffic.
- **Amazon ECS Fargate:** Runs containerized application workloads.
- **Amazon RDS MySQL:** Managed relational database.
- **Security Groups:** Control communication between infrastructure components.

## 3. Project Structure

```text
devops-terraform-db-assessment/
│
├── README.md
├── docker-compose.yml
│
├── db/
│   ├── migrations/
│   │   ├── 001_init.sql
│   │   └── 002_indexes.sql
│   ├── queries/
│   │   └── booking_report.sql
│   └── seed.sql
│
├── backups/
│
├── scripts/
│   ├── backup.sh
│   └── restore.sh
│
└── infra/
    ├── envs/
    │   ├── dev/
    │   │   ├── backend.tf
    │   │   ├── main.tf
    │   │   ├── variables.tf
    │   │   ├── outputs.tf
    │   │   └── terraform.tfvars
    │   │
    │   └── prod/
    │       ├── backend.tf
    │       ├── main.tf
    │       ├── variables.tf
    │       ├── outputs.tf
    │       └── terraform.tfvars
    │
    └── modules/
        ├── network/
        ├── ecs/
        └── rds/
```

## 4. Terraform Infrastructure

Terraform is organized into reusable modules to improve maintainability and reduce duplication.

### Reusable Modules

| Module | Responsibility |
|---|---|
| Network | VPC, public/private subnets, routing and networking |
| ECS | ECS cluster, task definition, service and load balancer |
| RDS | MySQL database instance and configuration |

### Environment Configuration

Separate Terraform root configurations are maintained for Dev and Prod.

| Configuration | Development | Production |
|---|---|---|
| Project | devops-assessment-dev | devops-assessment-prod |
| VPC CIDR | 10.10.0.0/16 | 10.20.0.0/16 |
| ECS Desired Tasks | 1 | 2 |
| Fargate CPU | 256 | 512 |
| Fargate Memory | 512 MB | 1024 MB |
| RDS Instance | db.t3.micro | db.t3.small |
| RDS Storage | 20 GB | 50 GB |
| Backup Retention | 1 day | 7 days |
| Deletion Protection | Disabled | Enabled |

Both environments use MySQL on Amazon RDS, private database access, and encrypted storage.

## 5. Database Implementation

MySQL is managed locally using Docker Compose.

### Database Components

- Schema creation through SQL migrations.
- Database indexes for query optimization.
- Seed data for testing.
- Booking report SQL query.
- Database backup and restore scripts.

### Start MySQL

```bash
docker-compose up -d
```

### Check Container Status

```bash
docker-compose ps
```

### Run Database Migrations

```bash
docker-compose exec -T mysql mysql -uappuser -papppassword bookings < db/migrations/001_init.sql

docker-compose exec -T mysql mysql -uappuser -papppassword bookings < db/migrations/002_indexes.sql
```

### Load Seed Data

```bash
docker-compose exec -T mysql mysql -uappuser -papppassword bookings < db/seed.sql
```
Note: Run the seed script once on a fresh database to avoid inserting duplicate test records.

### Execute Report Query

```bash
docker-compose exec -T mysql mysql -uappuser -papppassword bookings < db/queries/booking_report.sql
```

## 6. Database Backup and Restore

Shell scripts are provided for database backup and restoration.

### Backup

```bash
bash scripts/backup.sh
```

### Restore

```bash
bash scripts/restore.sh <backup-file>
```

The backup and restore workflow supports MySQL database recovery and validation.

Database backup files are excluded from Git to avoid committing generated database dumps.

## 7. CI/CD Using GitHub Actions

GitHub Actions automates infrastructure and database configuration validation.

Workflow file:

```text
.github/workflows/terraform-ci.yml
```

### Pipeline Triggers

- Push to MASTER.
- Pull requests targeting MASTER.

### Pipeline Stages

**Terraform Validation**
1. Checkout repository.
2. Set up Terraform.
3. Check Terraform formatting.
4. Initialize and validate Dev configuration.
5. Initialize and validate Prod configuration.

**Database Validation**
1. Checkout repository.
2. Validate Docker Compose configuration.

### Validation Commands

```bash
terraform fmt -check -recursive infra/
```

Development:

```bash
cd infra/envs/dev
terraform init
terraform validate
```

Production:

```bash
cd infra/envs/prod
terraform init
terraform validate
```

Docker Compose:

```bash
docker compose config --quiet
```

The GitHub Actions workflow runs validation automatically without provisioning AWS infrastructure.

## 8. Security Considerations

- RDS is configured as non-publicly accessible.
- Security groups restrict database access to the application tier.
- RDS storage encryption is enabled.
- Production deletion protection is enabled.
- Database credentials are supplied through sensitive Terraform variables.
- Credentials, Terraform state files, and database backup dumps should not be committed to Git.
- Production deployments should use valid AWS credentials and appropriately scoped IAM permissions.

## 9. Assessment Execution Scope

This repository demonstrates infrastructure design, Terraform module reusability, database operations, backup and restore procedures, and automated CI validation.

Terraform formatting and validation were performed for both environments. GitHub Actions was configured to validate Terraform and Docker Compose.

**No real AWS infrastructure was provisioned as part of this assessment.** Terraform plans and CI checks are validation activities, not evidence of a live deployment.

## 10. Technologies Used

- AWS
- Terraform
- Amazon VPC
- Amazon ECS Fargate
- Application Load Balancer
- Amazon RDS MySQL
- Docker
- Docker Compose
- MySQL
- SQL
- Bash
- Git
- GitHub
- GitHub Actions

