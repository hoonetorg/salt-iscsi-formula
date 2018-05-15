# -*- coding: utf-8 -*-
# vim: ft=sls

include:
  - iscsi.initiator_install
  - iscsi.initiator_config
  - iscsi.initiator_service

extend:
  iscsi_initiator_config__initiatorname_file:
    file:
      - require:
        - pkg: iscsi_initiator_install__pkg
  iscsi_initiator_config__conffile:
    file:
      - require:
        - pkg: iscsi_initiator_install__pkg
  iscsi_initiator_service__service:
    service:
      - watch:
        - file: iscsi_initiator_config__conffile
        - file: iscsi_initiator_config__initiatorname_file
      - require:
        - pkg: iscsi_initiator_install__pkg
