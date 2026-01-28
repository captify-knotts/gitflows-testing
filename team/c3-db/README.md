# Database Migrations Workflow
This repository contains database migration scripts managed by an automated GitHub Actions workflow. 

The workflow handles migration detection, optional database snapshots, and applies migrations in a controlled manner.

## Repository Structure
Your repository must follow this exact structure for the workflow to function correctly:

```
<team-project>/
└── <database-name>-db-migrations/
    ├── migrations/
    │   ├── postgres/                 # REQUIRED: Regular migrations (versioned)
    │   ├── postgres-repeatable/      # REQUIRED: Repeatable migrations (R__*.sql)
    │   └── postgres-utility/         # REQUIRED: Utility migrations (R__*.sql)
    ├── database-config.yaml          # REQUIRED: Configuration file
    └── README.md
```

## Configuration File
The database-config.yaml file is the central configuration for your database migrations. 

The workflow parses this file to determine database connections, migration settings, and environment configurations.

### Required Structure

```yaml
# General configurations
description: "Your database description"

migrator:
  postgres_version: 15                    # PostgreSQL version
  postgres_jdbc_version: "42.7.8"         # JDBC driver version
  flyway_version: "11.20.0"               # Flyway version

database:
  name: "your_database_name"              # Database name

ecr_repo: "account.dkr.ecr.region.amazonaws.com/repo-name"  # ECR repository

# Environment specific configurations
environments:
  qa:
    database:
      account: "AWS_ACCOUNT_ID"               # AWS account ID
      identifier: "rds-instance-name"         # RDS instance identifier
      url: "database.host.name"               # Database host URL
      arn: "arn:aws:rds:..."                  # RDS ARN
      port: 5432                              # Database port
      user: "database_user"                   # Database username
      ssm_password_path: "/path/to/password"  # SSM parameter path for password

  prod:
    # Production configuration (same structure as qa)

# REQUIRED FOR COST ALLOCATION: TAGS
market: "shared"
owner: "team_name"
service: "service_name"
product: "product_name"
```

## Key Configuration Points
1. Environment Configuration: Each environment (qa, prod) must have complete database connection details

2. SSM Password Path: Must point to a valid SSM Parameter Store path containing the database password

3. ECR Repository: Must be accessible by the GitHub Actions runner with appropriate permissions

4. Tags: Required for AWS cost allocation and resource management

## How to Use
### 1. Adding New Migrations
To add a new migration:

1. <b>Regular Migrations</b> (versioned): 
    Add SQL files to `migrations/postgres/`

* Format: <i>V{version}__{description}.sql</i> (e.g., `V1_2_0__add_users_table.sql`)
* Applied once, in order based on version numbers

2. <b>Repeatable Migrations</b>:
    Add SQL files to `migrations/postgres-repeatable/`

* Format: <i>R__{description}.sql</i> (e.g., `R__001_refresh_materialized_view.sql`)
* Re-applied when checksum changes

3. <b>Utility Migrations</b>: 
    Add SQL files to `migrations/postgres-utility/`

* Format: <i>R__{description}.sql</i> (e.g., `R__001_ownership_procedures.sql`)
* Intended for administrative or operational SQL
* Tracked in a separate Flyway schema history table
* Repeatable by design

### 2. Triggering Migrations
<b>QA</b>
* <b> Trigger</b> Pull Request
* <b>Branch</b>: Any
* <b>Snapshot</b>: Always created before migrations


<b>PROD</b> (N/A - WiP)


### 3. Migration Process
When triggered, the workflow:

1. <b>Detects Changes</b>: Scans for modified files in migration directories

2. <b>Creates database snapshot</b>

3. Applies Migrations:

* Regular migrations (versioned, sequential)

* Repeatable migrations (re-run if changed)

* Utility migrations (one-time scripts)

4. Parallel Safety: Migrations run sequentially (max-parallel: 1) to prevent conflicts

## Important Notes
### Migration Files
* <b>Never delete or modify</b> already-applied migration files

* Flyway tracks applied migrations in schema history tables

* Changing existing files can cause checksum errors and migration failures

### Rollbacks
* <b>No automatic rollback mechanism is provided</b>

* Use the snapshot feature before applying risky migrations

* Manual intervention required for rollbacks

### Troubleshooting
#### Common Issues
1. Workflow not triggering: Ensure you're pushing to the master branch and files are in correct migrations/ directories

2. SSM parameter not found: Verify the ssm_password_path in config matches an existing SSM parameter

3. Permission errors: Check IAM role permissions for the GitHub Actions runner

4. Migration failures: Check Flyway schema history tables for errors: flyway_schema_history, flyway_schema_history_repeatable, flyway_schema_history_utility

### Checking Migration Status
After migrations run, check:

* GitHub Actions workflow logs for detailed output

* Database schema history tables for applied migrations

* RDS snapshots (if snapshot was requested)

# Support
For issues with:

* Workflow execution: Check GitHub Actions logs

* Database connectivity: Verify config file parameters and AWS permissions

* Migration failures: Review SQL syntax and Flyway compatibility

* <b>Contact Infra Team</b>