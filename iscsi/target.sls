# -*- coding: utf-8 -*-
# vim: ft=sls

include:
  - iscsi.target.install
  - iscsi.target.config
  - iscsi.target.service

extend:
  iscsi_target_config__conffile:
    file:
      - require:
        - pkg: iscsi_target_install__pkg
  iscsi_target_service__service:
    service:
      - watch:
        - file: iscsi_target_config__conffile
      - require:
        - pkg: iscsi_target_install__pkg
