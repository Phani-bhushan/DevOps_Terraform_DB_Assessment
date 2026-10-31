# AWS DevOps Terraform and MySQL Assessment

This repository contains an AWS infrastructure and database automation assessment demonstrating practical AWS DevOps skills using Terraform, Docker Compose, MySQL, and GitHub Actions.

## Project Overview

The project provisions infrastructure through reusable Terraform modules and separates development and production configurations.

It also demonstrates local MySQL database setup, schema migrations, indexing, sample data generation, reporting queries, and database backup and restore operations.

## Technology Stack

- AWS: VPC, public/private subnets, Internet Gateway, NAT Gateway, security groups, ALB, ECS Fargate, RDS
- Infrastructure as Code: Terraform
- Containers: Docker and Docker Compose
- Database: MySQL 8.0
- Scripting: Bash
- CI: GitHub Actions

## Project Structure

The complete assessment implementation is available in:

`devops-terraform-db-assessment/`

It includes:

- `infra/modules/` — reusable Network, ECS, and RDS modules
- `infra/envs/dev/` — development environment
- `infra/envs/prod/` — production environment
- `db/` — database migrations, seed data, and reporting queries
- `scripts/` — MySQL backup and restore scripts
- `docker-compose.yml` — local MySQL environment

## Validation

The GitHub Actions workflow checks Terraform formatting, initializes and validates both environments, and validates the Docker Compose configuration.

Database backup and restore operations were tested locally.

## Deployment Scope

This repository is an infrastructure and database assessment. Terraform configuration and database operations were validated, but AWS infrastructure was not deployed as part of this assessment.

## Detailed Documentation

See [the complete project README](devops-terraform-db-assessment/README.md).
