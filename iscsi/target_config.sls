# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "iscsi/map.jinja" import iscsi with context %}


{% if iscsi.get('target', {}).get('backstores', False) or iscsi.get('target', {}).get('iqns', False)  %}

  {% for backstore, backstore_data in iscsi.get('target', {}).get('backstores', {}).items()|sort %}

    # FIXME implement setting other backstore_types
    {% set backstore_path = backstore_data.blockdevice %}
    {% set backstore_type = "block" %}

iscsi_target__create_backstore_{{ backstore }}:
  cmd.run:
    - name: targetcli /backstores/{{ backstore_type }} create name={{ backstore }} dev={{ backstore_path }}
    - unless: targetcli ls /backstores/{{ backstore_type }}/{{ backstore }}
    - require_in:
      - cmd: iscsi_target__finished
    - watch_in:
      - cmd: iscsi_target__config

  {% endfor %}

  {% for iqn, iqn_data in iscsi.get('target', {}).get('iqns', {}).items()|sort %}

iscsi_target__create_iqn_{{ iqn }}:
  cmd.run:
    - name: targetcli /iscsi create {{ iqn }}
    - unless: targetcli ls /iscsi/{{ iqn }}
    - require_in:
      - cmd: iscsi_target__finished
    - watch_in:
      - cmd: iscsi_target__config


    {% for tpg, tpg_data in iqn_data.get('tpgs', {}).items()|sort %}

iscsi_target__iqn_{{ iqn }}_create_tpg_{{ tpg }}:
  cmd.run:
    - name: targetcli /iscsi/{{ iqn }} create {{ tpg }}
    - unless: targetcli ls /iscsi/{{ iqn }}/{{ tpg }}
    - require:
      - cmd: iscsi_target__create_iqn_{{ iqn }}
    - require_in:
      - cmd: iscsi_target__finished
    - watch_in:
      - cmd: iscsi_target__config


      {% for portal, portal_data in tpg_data.get('portals', {}).items()|sort %}

        {% set ip_address = portal_data.get('ip_address', '0.0.0.0') %}
        {% set ip_port = portal_data.get('ip_port', '3260') %}

iscsi_target__iqn_{{ iqn }}_tpg_{{ tpg }}_create_portal_{{ portal }}:
  cmd.run:
    - name: targetcli /iscsi/{{ iqn }}/{{ tpg }}/portals create ip_address={{ ip_address }} ip_port={{ ip_port }}
    - unless: targetcli ls /iscsi/{{ iqn }}/{{ tpg }}/portals/{{ ip_address }}:{{ ip_port }}
    - require:
      - cmd: iscsi_target__iqn_{{ iqn }}_create_tpg_{{ tpg }}
    - require_in:
      - cmd: iscsi_target__finished
    - watch_in:
      - cmd: iscsi_target__config
      {% endfor %}


      {% for acl, acl_data in tpg_data.get('acls', {}).items()|sort %}
iscsi_target__iqn_{{ iqn }}_tpg_{{ tpg }}_create_acl_{{ acl }}:
  cmd.run:
    - name: targetcli /iscsi/{{ iqn }}/{{ tpg }}/acls create {{ acl }}
    - unless: targetcli ls /iscsi/{{ iqn }}/{{ tpg }}/acls/{{ acl }}
    - require:
      - cmd: iscsi_target__iqn_{{ iqn }}_create_tpg_{{ tpg }}
    - require_in:
      - cmd: iscsi_target__finished
    - watch_in:
      - cmd: iscsi_target__config
      {% endfor %}


      {% for backstore, backstore_data in iscsi.get('target', {}).get('backstores', {}).items()|sort %}
        {% if backstore_data.iqn in [ iqn ] and backstore_data.tpg in  [ tpg ] %}

          # FIXME implement finding out backstore_type from pillar data
          {% set backstore_type = "block" %}

iscsi_target__iqn_{{ iqn }}_tpg_{{ tpg }}_create_lun_{{ backstore }}:
  cmd.run:
    - name: targetcli /iscsi/{{ iqn }}/{{ tpg }}/luns create  lun={{ backstore_data.lun }} /backstores/{{ backstore_type }}/{{ backstore }}
    - unless: targetcli ls /iscsi/{{ iqn }}/{{ tpg }}/luns/lun{{ backstore_data.lun }}
    - require:
      - cmd: iscsi_target__iqn_{{ iqn }}_create_tpg_{{ tpg }}
      - cmd: iscsi_target__create_backstore_{{ backstore }}
    - require_in:
      - cmd: iscsi_target__finished
    - watch_in:
      - cmd: iscsi_target__config
        {% endif %}

      {% endfor %}

    {% endfor %}

  {% endfor %}

{% endif %}

iscsi_target__config:
  cmd.wait:
    - name: targetctl save {{ iscsi.target.conffile }}
    - require_in:
      - cmd: iscsi_target__finished

iscsi_target__finished:
  cmd.run:
    - name: true
    - unless: true
