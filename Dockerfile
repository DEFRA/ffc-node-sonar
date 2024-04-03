ARG PARENT_VERSION=2.2.2-node20.11.1

FROM defradigital/node-development:${PARENT_VERSION} AS development

# Install Sonar Scanner, Coverlet and Java (required for Sonar Scanner)
USER root
RUN apk --no-cache add openjdk17 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community

# Install Node.js (needed for scanning JavaScript)
RUN apk --no-cache ad nodejs npm

# Install Sonar Scanner
RUN npm install -g sonar-scanner

# Map args to env vars
ARG PARENT_VERSION
ENV SONAR_HOST_URL https://sonarcloud.io
ENV SONAR_ORGANIZATION_KEY defra
ENV SONAR_PR_PROVIDER GitHub
ENV FIX_COVERAGE_REPORT true

LABEL uk.gov.defra.ffc.parent-image=defradigital/node-development:${PARENT_VERSION}

COPY --chown=node:node ./scripts .
RUN install -d -o node -g node /home/node/project/ && \
    install -d -o node -g node /home/node/working/

ENTRYPOINT [ "./run-analysis" ]
