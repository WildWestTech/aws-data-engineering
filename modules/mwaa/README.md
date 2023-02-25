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
- 