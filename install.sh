#!/usr/bin/env bash

project_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
project_resources="$project_dir/resources"
config_dir=/usr/local/etc
config_file=pushcut-announce
script_dir=/usr/local/bin
script_file=pushcut-announce
systemd_unit_dir=/usr/local/lib/systemd/system
systemd_unit_filename=pushcut-announce.service
systemd_unit_link=/etc/systemd/system/pushcut-announce.service

config_is_fresh=yes

if [[ $EUID -ne 0 ]]; then
  echo -e "This script must be run as root so systemd may be updated\n" >&2
  exit 1
fi

mkdir -p "$config_dir"
if [[ -f "$config_dir/$config_file" ]]; then
  echo "Configuration file exists at $config_dir/$config_file"
  read -p "Replace? [y/n]: " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    cp -f "$project_resources/config" "$config_dir/$config_file"
    echo "Replaced configuration file at $config_dir/$config_file"
  else
    echo "Existing configuration file untouched."
    config_is_fresh=no
  fi 
else
  cp "$project_resources/config" "$config_dir/$config_file"
  echo "Created configuration file at $config_dir/$config_file"
fi
chmod 600 "$config_dir/$config_file"

mkdir -p "$script_dir"
cp "$project_resources/pushcut-announce" "$script_dir/$script_file"
echo "Created service script at $script_dir/$script_file"

mkdir -p "$systemd_unit_dir"
cp "$project_resources/systemd-unit" "$systemd_unit_dir/$systemd_unit_filename"
echo "Created systemd service unit at $systemd_unit_dir/$systemd_unit_filename"
if [[ -L "$systemd_unit_link" ]]; then
  systemctl disable --quiet "$systemd_unit_filename"
  rm -f "$systemd_unit_link"
fi
ln -s "$systemd_unit_dir/$systemd_unit_filename" "$systemd_unit_link"
echo "Created systemd service unit link as $systemd_unit_link"
systemctl daemon-reload
systemctl enable --quiet "$systemd_unit_filename"

if [[ $config_is_fresh == "yes" ]]; then
  echo -e "\nDone! Please edit the configuration file at $config_dir/$config_file"
else
  echo -e "\nDone! Existing configuration file preserved at $config_dir/$config_file"
fi
