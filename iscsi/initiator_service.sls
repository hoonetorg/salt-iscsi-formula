# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "iscsi/map.jinja" import iscsi with context %}

iscsi_initiator_service__service:
  service.{{ iscsi.initiator.service.state }}:
    - name: {{ iscsi.initiator.service.name }}
{% if iscsi.initiator.service.state in [ 'running', 'dead' ] %}
    - enable: {{ iscsi.initiator.service.enable }}
{% endif %}

