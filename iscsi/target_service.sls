# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "iscsi/map.jinja" import iscsi with context %}

iscsi_target_service__service:
  service.{{ iscsi.target.service.state }}:
    - name: {{ iscsi.target.service.name }}
{% if iscsi.target.service.state in [ 'running', 'dead' ] %}
    - enable: {{ iscsi.target.service.enable }}
{% endif %}

