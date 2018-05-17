# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "iscsi/map.jinja" import iscsi with context %}

include:
  - iscsi.target_install
  - iscsi.target_config
  - iscsi.target_service

extend:
  {% if iscsi.get('target', {}).get('backstores', False) or iscsi.get('target', {}).get('iscsis', False)  %}
  iscsi_target__finished:
    cmd:
      - require:
        - pkg: iscsi_target_install__pkg
  {% endif %}
  iscsi_target_service__service:
    service:
      {% if iscsi.get('target', {}).get('backstores', False) or iscsi.get('target', {}).get('iscsis', False)  %}
      - watch:
        - cmd: iscsi_target__config
      {% endif %}
      - require:
        - pkg: iscsi_target_install__pkg
