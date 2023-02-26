### Airflow on EC2

We have a few options with AirFlow.  AWS released MWAA a while back, and I have already created than in my mwaa folder.  In fact, that's one of the tools we are using where I work.  However, it's just a bit more expensive than I'd care to deal with right now.  It might be worth the investment for a larger team, but if you just want a place to experiment with DAGs (directed acyclic graphs), consider running your AirFlow in a small EC2 instance for around 1/10th the price.

Most of this project so far has been terraform/code-first.  This one will be a bit different.  I'll actually create this instance in the console, run all of my commands to install airflow, then create an AMI that I can reference later, so I can capture my configurations for future launches.

#### Instructions
- credit: this was a helpful tutorial https://www.youtube.com/watch?v=o88LNQDH2uI
- notes from video: https://robust-dinosaur-2ef.notion.site/Running-Airflow-on-a-small-AWS-EC2-Instance-8e2a42d2ce7946c3a3d753abc13f2e57

##### Key Pairs
- EC2 -> Network and Security -> Key Pairs -> Create Key Pair
    - naming mine: airflow-pem-keys
    - download and keep safe for later

##### EC2 Instance
- EC2 -> Launch
- name: airflow
- image: ubuntu (ami-0557a15b87f6559cf)
- architecture: 64bit-x64
- type: t2.small (1 vCPU, 2GB ram)
- key pair: choose the pair we just created
- vpc: main
- subnet: Private-1A
- instance profile: airflow-ec2-service-role
- public ip: disable
- security group: airflow_ec2_security_group
- launch instance -> wait -> connect
- this part differs from the video, since I am running my EC2 instance in a private subnet and I am connected using VPN
- navigate to the location of your pem keys and run this: chmod 400 airflow-pem-keys.pem
- ssh to your instance using your private ip
    - example: ssh -i "airflow-pem-keys.pem" ubuntu@10.0.2.34

##### SSH commands
- sudo apt update
- sudo apt install python3-pip
- sudo apt install sqlite3
- sudo apt install python3.10-venv
- python3 -m venv venv
- source venv/bin/activate
- sudo apt-get install libpq-dev
- pip install "apache-airflow[postgres]==2.5.0" --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.5.0/constraints-3.7.txt"
- airflow db init
- sudo apt-get install postgresql postgresql-contrib
- sudo -i -u postgres
- psql
- CREATE DATABASE airflow;
- CREATE USER airflow WITH PASSWORD 'airflow';
- GRANT ALL PRIVILEGES ON DATABASE airflow TO airflow;
- logout, log back in
- source venv/bin/activate
- cd airflow
- sed -i 's#sqlite:////home/ubuntu/airflow/airflow.db#postgresql+psycopg2://airflow:airflow@localhost/airflow#g' airflow.cfg
- sed -i 's#SequentialExecutor#LocalExecutor#g' airflow.cfg
- airflow db init
- airflow users create -u airflow -f airflow -l airflow -r Admin -e airflow@gmail.com
- airflow webserver &
- airflow scheduler
- update password if prompted: Password#12345 <--- something better than this

##### Login To AirFlow UI
- Assuming you are on VPN
- Navigate to the Private IP Address on port 8080
- http://10.0.2.103:8080/
- Login with username: airflow@gmail.com <--- or whatever you named it

##### Create an AMI
- In the EC2 dashboard, navigate to the airflow EC2 instance.
- Select it -> choose actions -> Image and Templates -> Create Image
- Name it, give it a description, and create it.
- After a few minutes, a new AMI will be ready under Images 

##### Start the Server
- Log in to the new instance (might have to login as ubuntu instead of root)
- source venv/bin/activate
- cd airflow
- airflow webserver &
- airflow scheduler

##### Create a Startup Script
    nano startup_script.sh

Paste this into the startup script:

    #!/bin/bash

    # Activate virtual environment
    source venv/bin/activate

    # Change to the airflow directory
    cd airflow

    # Start the Airflow webserver in the background
    airflow webserver &

    # Start the Airflow scheduler
    airflow scheduler

- Press CTRL + O to save the file, then press ENTER.
- Press CTRL + X to exit the nano editor.
- Make the script executable by running the following command

    chmod +x startup_script.sh

- open cron
    crontab -e

- add an uncommented line
    @reboot ./startup_script.sh

##### Create a New AMI
- We didn't have to create the first AMI, but that was where the turorial I was following had stopped.
- I don't want to have to ssh into the machine, enable the virtual environment, and start AirFlow each time.
- Adding these steps as a startup script, then creating a new AMI that handles all of that for us will make things much better.

##### Sharing the AMI
- If you plan on running this in multiple account (dev & prod), consider appending the environment to your key name.
- You can also do as I did and share your AMI with your other account.  In my case, I developed this in dev and simply went to permissions and shared it with my prod account.
