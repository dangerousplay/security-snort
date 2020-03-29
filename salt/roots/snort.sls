install ansible:
  pkg.installed:
    - name: ansible

python-pip:
  pkg.installed

mysql-python:
  pip.installed:
    - require:
      - pkg: python-pip

install ansible playbook:
  cmd.run:
    - name: ansible-galaxy install mrlesmithjr.snort

install mysql:
  pkg.installed:
    - user: root
    - name: mysql-server

install snort:
  ansible.playbooks:
    - name: playbook.yml
    - rundir: /srv/salt/

PHP Repository:
  pkgrepo.managed:
      - name: ppa:ondrej/php

install BASE Packages:
  pkg.installed:
    - names:
      - apache2
      - php5.6-mysql
      - libphp-adodb
      - php5.6-mail
      - php5.6-gd
      - php-pear
      - php5.6-cli
      - php5.6
      - php5.6-common
      - php5.6-xml

download Adodb:
  cmd.run:
    - name: wget https://github.com/ADOdb/ADOdb/archive/v5.20.16.tar.gz -O /tmp/adodb.tar.gz

create Adodb TEMP:
  cmd.run:
    - name: mkdir -p /tmp/adodb-unzip

unzip Adodb:
  cmd.run:
    - name: tar -xvzf /tmp/adodb.tar.gz -C /tmp/adodb-unzip

move Adodb:
  cmd.run:
    - name: mv /tmp/adodb-unzip/ADOdb-5.20.16 /usr/share/adodb

download BASE:
  cmd.run:
    - name: wget http://sourceforge.net/projects/secureideas/files/BASE/base-1.4.5/base-1.4.5.tar.gz -O /tmp/base.tar.gz

create BASE TEMP:
  cmd.run:
    - name: mkdir -p /tmp/debian-base

unzip BASE:
  cmd.run:
    - name: tar -xvzf /tmp/base.tar.gz -C /tmp/debian-base

move BASE to PHP:
  cmd.run:
    - name: mv /tmp/debian-base/base-1.4.5 /var/www/html/base

configure BASE php:
  file.managed:
    - name: /var/www/html/base/base_conf.php
    - source: salt://base-php-conf.j2
    - template: jinja

restart apache:
  cmd.run:
    - name: service apache2 restart
