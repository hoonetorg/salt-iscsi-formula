# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "iscsi/map.jinja" import iscsi with context %}

iscsi_target_install__pkg:
  pkg.installed:
    - pkgs: {{ iscsi.target.pkgs }}
