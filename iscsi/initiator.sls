# -*- coding: utf-8 -*-
# vim: ft=sls

include:
  - iscsi.initiator.install
  - iscsi.initiator.config
  - iscsi.initiator.service

extend:
  iscsi_initiator_config__conffile:
    file:
      - require:
        - pkg: iscsi_initiator_install__pkg
  iscsi_initiator_service__service:
    service:
      - watch:
        - file: iscsi_initiator_config__conffile
      - require:
        - pkg: iscsi_initiator_install__pkg
