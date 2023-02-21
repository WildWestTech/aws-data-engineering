### Cluster Templates

- Even though you're working 99% in Terraform, don't forget to review events in cloudformation in the AWS console.  It can provided additional insight for trouble-shooting (details aren't always available in EMR Studio).
- Review the LogUri.  I think this is a managed bucket by AWS, but I'm not sure at the moment.
- Keep an eye on your JobFlowRole.  Make sure it matches what we see in the ClusterTemplateLaunchRole.  This role has to provide  
- Currently looking in to Livy Timeout & bootstrap actions.