# Etapa de construcción
FROM quay.io/keycloak/keycloak:20.0.2 as builder

# Habilitar soporte de health y metrics
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Configurar la base de datos
ENV KC_DB=postgres

WORKDIR /opt/keycloak

# Construir Keycloak
RUN /opt/keycloak/bin/kc.sh build

# Etapa final
FROM quay.io/keycloak/keycloak:20.0.2
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Configurar la conexión a la base de datos PostgreSQL
ENV KC_DB=postgres
ENV KC_DB_URL=jdbc:postgresql://deleyfdatabase-deleyfdatabase.i.aivencloud.com:11249/deleyfdatabase
ENV KC_DB_USERNAME=avnadmin
ENV KC_DB_PASSWORD=AVNS_4QYLIdHz32YmwJmHYQS

# Configurar el hostname para que coincida con el ALB de AWS
ENV KC_HOSTNAME_STRICT=false
ENV KC_HOSTNAME_STRICT_BACKCHANNEL=false

# Variables de entorno para el administrador de Keycloak
ENV KEYCLOAK_ADMIN=admin
ENV KEYCLOAK_ADMIN_PASSWORD=deleyf20224*

# Definir el comando de arranque de Keycloak
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start-dev"]