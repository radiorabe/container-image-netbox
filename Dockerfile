FROM quay.io/netboxcommunity/netbox:v4.7.3@sha256:6f2bedaa56e6fb1d6ef95f6fb5e08e8eb0ecf0ac590c8da723f79bc7518da6c7

COPY ./plugin_requirements.txt /opt/netbox/

COPY --from=ghcr.io/astral-sh/uv:0.12 /uv /usr/local/bin/
RUN /usr/local/bin/uv --directory /opt/netbox/venv pip install -r /opt/netbox/plugin_requirements.txt

RUN mkdir -p /opt/netbox/netbox/static/netbox_topology_views/img

RUN sed -i 's/PLUGINS\s=.*/PLUGINS = \["netbox_topology_views"\]/' /etc/netbox/config/configuration.py

RUN DEBUG="true" SECRET_KEY="dummydummydummydummydummydummydummydummydummydummy" \
    /opt/netbox/venv/bin/python /opt/netbox/netbox/manage.py collectstatic --no-input
