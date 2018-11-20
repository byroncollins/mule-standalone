FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift
ARG MULE_VERSION

ENV MULE_HOME /opt/mule
ENV MULE_VERSION ${MULE_VERSION:-4.1.1}

# Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Base Image for Mule ESB" \
      io.k8s.display-name="Mule ESB ${MULE_VERSION} Enterprise base image" \
      io.openshift.tags="builder,mule,java"

# we need some tools from yum
# and install mule ee standalone
USER root
RUN curl -o /opt/mule.tar.gz https://repository-master.mulesoft.org/nexus/content/repositories/releases/org/mule/distributions/mule-standalone/${MULE_VERSION}/mule-standalone-${MULE_VERSION}.tar.gz \
    && tar -xzf /opt/mule.tar.gz -C /opt \
    && mv /opt/mule-standalone-${MULE_VERSION} $MULE_HOME \
    && rm /opt/mule.tar.gz*

# run as non-root user
RUN chown -R 1001:0 $MULE_HOME && \
    chmod -R g+wrx $MULE_HOME

# Openshift runtime user
USER 1001
