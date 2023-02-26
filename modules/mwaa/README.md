### Amazon Managed Workflows for Apache Airflow (MWAA)

- https://aws.amazon.com/managed-workflows-for-apache-airflow/pricing/
- MWAA is expensive.  Bare minimum setup will run north of $350/month.
- So I plan on keeping this inactive when not testing.  I doubt I'll push this to prod in this lab more than a few times.
- Also, the spin-up time takes a long time (30+ minutes), so keep that in mind and plan ahead.
- Assuming this is for testing, you'll also want to tear it back down, so plan accordingly.
- Private requires several VPC Endpoints
- https://docs.aws.amazon.com/mwaa/latest/userguide/configuring-networking.html
- https://docs.aws.amazon.com/mwaa/latest/userguide/networking-about.html

### Networking Requirements (Public)
- VPC
- Private Subnet (AZ1)-> NAT Gateway (in Public Subnet 1) -> Public Subnet (AZ1) -> IGW (only one per VPC)
- Private Subnet (AZ2)-> NAT Gateway (in Public Subnet 2) -> Public Subnet (AZ2) -> IGW (only one per VPC)
- Note on Routing Tables:
    -  I was originally placing all private subnets in a private subnet routing table, when most of my private resources were not being routed to a NAT Gateway.  B/C MWAA requires this routing, I am splitting my route tables by subnet/AZ.
- Note on Access:
    - Taking the Public Approach may cauase some concerns.  However, MWAA is only available via AWS SSO, so that should relieve some concerns.  

### Newtworking Requirements (Private)
- The private approach would require several additional VPC endpionts.  And because this is an expensive service for a lab environment, I felt the Public approach was sufficient.
- Instead, I will likely be using airflow in an inexpensive ec2 instance.  For that, I will be placing my ec2 in a private subnet and accessing it only over VPN.