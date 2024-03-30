#!/usr/bin/env fish

set teddycloud_dir "$PWD/teddycloud"

read --prompt "echo 'target teddycloud version: ' " -l target_tc_version

cd $teddycloud_dir
git fetch --quiet
git checkout --quiet tc_v$target_tc_version
git submodule update --recursive --quiet
cd ..

read --prompt "echo 'update config.yaml? (y/n)' " -l update_config
if test "$update_config" = "y"
    set -l config_file "$PWD/config.yaml"
    sd "version: \"(.+)\"" "version: \"$target_tc_version-1\"" $config_file
end