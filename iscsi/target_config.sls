# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "iscsi/map.jinja" import iscsi with context %}


{% if iscsi.get('target', {}).get('targets', False) %}
iscsi_target_config__conffile:
  file.managed:
    - name: {{ iscsi.target.conffile }}
    - source: salt://iscsi/files/saveconfig.json.jinja
    - template: jinja
    - context:
      confdict: {{iscsi|json}}
    - mode: 644
    - user: root
    - group: root
{% endif %}
