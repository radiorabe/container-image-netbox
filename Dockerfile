FROM quay.io/netboxcommunity/netbox:v4.7.2@sha256:3cf9d3bd77aa186233b84d0ea1cf1755581d5e5678fa7d86ec3be62f79d0c643

COPY ./plugin_requirements.txt /opt/netbox/

COPY --from=ghcr.io/astral-sh/uv:0.12 /uv /usr/local/bin/
RUN /usr/local/bin/uv --directory /opt/netbox/venv pip install -r /opt/netbox/plugin_requirements.txt

RUN mkdir -p /opt/netbox/netbox/static/netbox_topology_views/img

RUN sed -i 's/PLUGINS\s=.*/PLUGINS = \["netbox_topology_views"\]/' /etc/netbox/config/configuration.py

RUN DEBUG="true" SECRET_KEY="dummydummydummydummydummydummydummydummydummydummy" \
    /opt/netbox/venv/bin/python /opt/netbox/netbox/manage.py collectstatic --no-input
