## Technical Decisions

### 1. **Infrastructure as Code Framework: OpenTofu**
   - **Decision**: Use OpenTofu (Terraform fork) instead of native Terraform
   - **Rationale**: 
     - Open-source alternative to Terraform
     - Community-driven development with more transparency
     - Fully compatible with existing Terraform modules
     - Better alignment with open-source principles
   - **Trade-offs**: Smaller ecosystem than Terraform, but catching up rapidly

### 2. **Cloud Provider: AWS**
   - **Decision**: AWS as primary cloud provider
   - **Rationale**:
     - Market-leading cloud platform with extensive service catalog
     - Mature ecosystems and tools
     - EC2 cost-effective for development/staging workloads (t3.micro)
     - VPC provides network isolation and security
   - **Trade-offs**: Vendor lock-in, requires AWS credentials and knowledge

### 3. **AWS Region: eu-north-1 (Stockholm)**
   - **Decision**: Default to EU-North-1 region
   - **Rationale**:
     - EU data residency compliance
     - Lower latency for European users
     - Cost-effective pricing
     - GDPR-compliant data handling
   - **Trade-offs**: May have higher latency for non-EU users

### 4. **Compute: EC2 t3.micro Instance with Systems Manager Access**
   - **Decision**: Use t3.micro with IAM role for Systems Manager Session Manager
   - **Rationale**:
     - AWS free tier eligible (1 year)
     - Sufficient for development and testing
     - Cost-effective (~$7-10/month after free tier)
     - ARM-based Graviton processors available as alternative
     - Systems Manager provides secure access without SSH port exposure
   - **IAM Requirements**:
     - IAM role with trust relationship to EC2 service
     - AmazonSSMManagedInstanceCore policy attached
     - Instance profile for attaching role to instance
   - **Trade-offs**: Limited performance for production workloads
   - **Recommendation**: Use t3.small or larger for production with equivalent IAM setup

### 5. **Container Orchestration: Docker Compose**
   - **Decision**: Docker Compose instead of Kubernetes/ECS
   - **Rationale**:
     - Simpler setup for small deployments
     - Lower operational overhead
     - Easier for development and testing
     - All services on single EC2 instance (reduced cost)
   - **Trade-offs**: 
     - Limited scalability
     - No automatic recovery/restart on host failure
     - Difficult scaling across multiple hosts
   - **Recommendation**: Migrate to ECS/Kubernetes for production multi-instance deployments

### 6. **Database: PostgreSQL 15**
   - **Decision**: PostgreSQL in Docker container with persistent volumes
   - **Rationale**:
     - Powerful open-source relational database
     - ACID compliance for data integrity
     - Version 15 latest stable release
     - Great ecosystem and tools
   - **Persistence**:
     - Docker named volume `postgres_data` mapped to `/var/lib/postgresql/data`
     - Data persists across container restarts
     - Health check ensures database readiness
   - **Trade-offs**: 
     - Data lost if EC2 instance terminates (not AWS-managed)
     - No automated backups configured
   - **Recommendation for Production**:
     - Use AWS RDS PostgreSQL for managed backups and automated failover
     - Configure EBS snapshots for backup strategy
     - Enable Point-in-Time Recovery (PITR)

### 7. **Caching: Redis 7**
   - **Decision**: Redis for session/cache layer (ephemeral)
   - **Rationale**:
     - High-performance in-memory data store
     - Session management for web application
     - Pub/Sub capabilities for real-time features
     - Version 7 includes function scripting
   - **Persistence**:
     - No persistence configured (ephemeral cache)
     - Data lost on container or EC2 restart
   - **Trade-offs**: 
     - Single instance (no replication for HA)
   - **Recommendation for Production**:
     - Use AWS ElastiCache for managed Redis with automatic failover
     - Enable replication and multi-AZ for high availability
     - Configure automated backups and snapshots if persistence is needed

### 8. **Monitoring Stack: Prometheus + Grafana**
   - **Decision**: Prometheus for metrics, Grafana for visualization with persistent volumes
   - **Rationale**:
     - Industry-standard open-source monitoring
     - Pull-based metrics collection (efficient)
     - Time-series data optimized for historical analysis
     - Rich dashboard capabilities in Grafana
   - **Persistence**:
     - Grafana dashboard data stored in Docker named volume `grafana_data`
     - Dashboards and provisioning preserved across restarts
     - Prometheus metrics: in-memory with optional WAL persistence
   - **Trade-offs**: 
     - Single-instance Prometheus (no HA)
     - No built-in alerting (would need Alertmanager)
     - Metrics data lost on container restart if WAL not enabled
   - **Recommendation for Production**:
     - Add Prometheus Alertmanager for alerting
     - Use persistent volumes for metrics storage
     - Consider Thanos for long-term storage

### 9. **Web Application: Node.js + Express**
   - **Decision**: Node.js for web application runtime
   - **Rationale**:
     - JavaScript ecosystem for rapid development
     - Non-blocking I/O efficient for concurrent requests
     - Good NPM package ecosystem
     - Lightweight and quick startup
   - **Trade-offs**: Single-threaded model may limit CPU-bound workloads
   - **Recommendation for Production**:
     - Add clustering/load balancing
     - Use PM2 or similar process manager
     - Implement graceful shutdown

### 10. **Networking: VPC with Single Public Subnet**
   - **Decision**: Single public subnet architecture
   - **Rationale**:
     - Simplified setup for development
     - All services Internet-accessible
     - Easier troubleshooting
   - **Trade-offs**: 
     - No private subnets for database tier
     - All resources directly Internet-accessible
     - Poor security posture
   - **Recommendation for Production**:
     - Multi-tier VPC: public (web), private (app, db)
     - Use NAT Gateway for private subnet outbound
     - Implement strict Security Group rules
     - Use private endpoints for AWS services

### 11. **Security Group: Restrictive Rules**
   - **Decision**: Only expose application and monitoring ports; databases are internal
   - **Rationale**:
     - Production-ready security posture
     - Databases accessed only via localhost by application
     - SSH access via AWS Systems Manager Session Manager 
   - **Ports Exposed**:
     - 8080 - Node.js Web Application
     - 9090 - Prometheus Monitoring
     - 3000 - Grafana Dashboards
   - **Access Method**:
     - SSH via Systems Manager Session Manager 
     - Requires IAM role with AmazonSSMManagedInstanceCore policy
   - **Trade-offs**: None - this is best practice
   - **Recommendation for Production**:
     - Add WAF for HTTP/HTTPS traffic
     - Enable VPC Flow Logs for monitoring
     - Consider private subnets for additional isolation

### 12. **CI/CD: GitHub Actions**
   - **Decision**: GitHub Actions for automation
   - **Rationale**:
     - Native GitHub integration
     - No external CI/CD platform needed
     - Generous free tier
     - YAML-based declarative workflow
   - **Trade-offs**: Limited when self-hosted runners aren't available
   - **Recommendation**: 
     - Use self-hosted runners for consistent environment
     - Implement approval gates before prod deployment

### 13. **Infrastructure State Management: Local State**
   - **Decision**: Local terraform.tfstate files
   - **Rationale**:
     - Simple for single developer
     - Easy to understand and debug
   - **Trade-offs**: 
     - Not suitable for team collaboration
     - State file stored in git (security risk)
   - **Recommendation for Team/Production**:
     - Use S3 backend for remote state
     - Enable state locking with DynamoDB
     - Encrypt state at rest and in transit
     - Use IAM policies to restrict access

### 14. **Module Structure: Modular but Not Nested**
   - **Decision**: Flat module structure (vpc, security_group, ec2)
   - **Rationale**:
     - Clear dependencies
     - Easy to understand and modify
     - Reusable across environments
   - **Trade-offs**: 
     - Some code duplication
     - Limited abstraction
   - **Recommendation**: Consider composite modules for complex deployments

### 15. **Environment Management: Variable Files per Environment**
   - **Decision**: Separate .tfvars files for dev/staging/prod
   - **Rationale**:
     - Clear separation of concerns
     - Easy to promote changes
     - Prevents accidental prod changes
   - **Trade-offs**: File duplication
   - **Recommendation**: Consider Terraform workspaces for smaller projects

---