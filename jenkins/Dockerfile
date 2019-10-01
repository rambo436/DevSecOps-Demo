# Creating layer from the Jenkins LTS Docker Image.
from jenkins/jenkins:lts

# Used to resolve dependencies and download plugins.
RUN /usr/local/bin/install-plugins.sh ssh-slaves

# Installing Notification plugins to better support monitoring objectices.
RUN /usr/local/bin/install-plugins.sh email-ext
RUN /usr/local/bin/install-plugins.sh mailer
RUN /usr/local/bin/install-plugins.sh slack

# Used to publish the html reports that our builds generate to the job and build pages
RUN /usr/local/bin/install-plugins.sh htmlpublisher

# Adding UI Components that Moonrake Prefers
RUN /usr/local/bin/install-plugins.sh greenballs
RUN /usr/local/bin/install-plugins.sh simple-theme-plugin
RUN /usr/local/bin/install-plugins.sh blueocean

# Installing Maven
USER root
RUN apt-get update && apt-get install -y maven
USER jenkins
