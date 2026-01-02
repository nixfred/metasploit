# Vulnerable Tomcat with exposed Manager
# MSF: exploit/multi/http/tomcat_mgr_upload
# Creds: tomcat/tomcat, admin/admin
FROM tomcat:9.0-jdk11

# Copy default webapps (Tomcat 9 stores them in webapps.dist)
RUN cp -r /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps/

# Create manager users with weak credentials
RUN echo '<?xml version="1.0" encoding="UTF-8"?>\n\
<tomcat-users xmlns="http://tomcat.apache.org/xml"\n\
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"\n\
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"\n\
              version="1.0">\n\
  <role rolename="manager-gui"/>\n\
  <role rolename="manager-script"/>\n\
  <role rolename="manager-jmx"/>\n\
  <role rolename="manager-status"/>\n\
  <role rolename="admin-gui"/>\n\
  <role rolename="admin-script"/>\n\
  <user username="tomcat" password="tomcat" roles="manager-gui,manager-script,manager-jmx,manager-status,admin-gui,admin-script"/>\n\
  <user username="admin" password="admin" roles="manager-gui,manager-script,admin-gui,admin-script"/>\n\
</tomcat-users>' > /usr/local/tomcat/conf/tomcat-users.xml

# Allow manager access from any IP (default only allows localhost)
RUN echo '<?xml version="1.0" encoding="UTF-8"?>\n\
<Context antiResourceLocking="false" privileged="true">\n\
  <Valve className="org.apache.catalina.valves.RemoteAddrValve"\n\
         allow=".*" />\n\
</Context>' > /usr/local/tomcat/webapps/manager/META-INF/context.xml

# Same for host-manager
RUN echo '<?xml version="1.0" encoding="UTF-8"?>\n\
<Context antiResourceLocking="false" privileged="true">\n\
  <Valve className="org.apache.catalina.valves.RemoteAddrValve"\n\
         allow=".*" />\n\
</Context>' > /usr/local/tomcat/webapps/host-manager/META-INF/context.xml

EXPOSE 8080

CMD ["catalina.sh", "run"]
