# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "iscsi/map.jinja" import iscsi with context %}

/tmp/iscsi.yaml:
  file.managed:
    - contents: |
        {{iscsi|yaml(False)|indent(8)}}
