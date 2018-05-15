# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "iscsi/map.jinja" import iscsi with context %}

iscsi_initiator_install__pkg:
  pkg.installed:
    - pkgs: {{ iscsi.initiator.pkgs }}
