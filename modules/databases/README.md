### Reference
- https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-studio.html
- https://aws.amazon.com/blogs/big-data/orchestrating-analytics-jobs-on-amazon-emr-notebooks-using-amazon-mwaa/

With permissions:

We create two service roles for EMR Studio.  The first service role is obviously a service role.  The second serice role is one that will be assumed by the user.  We will create and attache three policies to that role.  At the time of assigning users to the studio, we can then choose the session policy (basic, intermediate, advanced).

Still need to see why the SSO Permission-Sets aren't showing up as options for the studio.