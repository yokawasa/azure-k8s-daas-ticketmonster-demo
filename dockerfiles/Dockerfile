# Use a customized 10.0.0.Final jboss/wildfly
FROM rafabene/wildfly-admin

MAINTAINER "Yoichi Kawasaki" <yoichi.kawasaki@outlook.com>

USER root

RUN \
    curl -s -L -O https://github.com/rafabene/devops-demo/archive/master.tar.gz && \
    tar xf master.tar.gz && \
    mv devops-demo-master/Dockerfiles/ticketmonster-ha/customization /opt/jboss/wildfly/ && \
    mv devops-demo-master/Dockerfiles/ticketmonster-ha/ticket-monster.war /opt/jboss/wildfly/standalone/deployments/ && \
    rm -rf devops-demo-master master.tar.gz

# Add customization folder
COPY customization/commands.cli /opt/jboss/wildfly/customization/

# Run customization scripts as root
RUN chmod +x /opt/jboss/wildfly/customization/execute.sh
RUN /opt/jboss/wildfly/customization/execute.sh standalone standalone-ha.xml

# Fix for Error: Could not rename /opt/jboss/wildfly/standalone/configuration/standalone_xml_history/current
RUN rm -rf /opt/jboss/wildfly/standalone/configuration/standalone_xml_history

RUN chown -R jboss:jboss /opt/jboss/wildfly/

USER jboss

# Expose the ports we're interested in
EXPOSE 8080 9990 8009

# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to external interface
CMD /opt/jboss/wildfly/bin/standalone.sh -c standalone-ha.xml -b 0.0.0.0 -bmanagement 0.0.0.0 -Dpostgres.host=$POSTGRES_EXTERNAL_HOST -Dpostgres.port=$POSTGRES_EXTERNAL_PORT -Dpostgres.user=$POSTGRES_EXTERNAL_USER -Dpostgres.password=$POSTGRES_EXTERNAL_PASSWORD -Dmodcluster.host=$MODCLUSTER_SERVICE_HOST -Dmodcluster.port=$MODCLUSTER_SERVICE_PORT
