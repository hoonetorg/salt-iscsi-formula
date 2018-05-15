# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "iscsi/map.jinja" import iscsi with context %}

iscsi_initiator_config__conffile:
  file.managed:
    - name: {{ iscsi.initiator.conffile }}
    - source: salt://iscsi/files/iscsid.conf.jinja
    - template: jinja
    - context:
      confdict: {{iscsi|json}}
    - mode: 644
    - user: root
    - group: root
