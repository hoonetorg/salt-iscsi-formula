# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "iscsi/map.jinja" import iscsi with context %}

include:
  - iscsi.target_install
  - iscsi.target_config
  - iscsi.target_service

extend:
  {% if iscsi.get('target', {}).get('targets', False) %}
  iscsi_target_config__conffile:
    file:
      - require:
        - pkg: iscsi_target_install__pkg
  {% endif %}
  iscsi_target_service__service:
    service:
      {% if iscsi.get('target', {}).get('targets', False) %}
      - watch:
        - file: iscsi_target_config__conffile
      {% endif %}
      - require:
        - pkg: iscsi_target_install__pkg
