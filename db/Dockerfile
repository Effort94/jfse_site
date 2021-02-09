FROM mysql:5.7
# Enable timezone setup (will now use the TZ env var to set mysqls timezone)
RUN echo "USE mysql;" > /docker-entrypoint-initdb.d/timezones.sql &&  mysql_tzinfo_to_sql /usr/share/zoneinfo >> /docker-entrypoint-initdb.d/timezones.sql