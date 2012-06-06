require 'config'
require 'fileutils'
require 'pathname'
require 'logger'
include ServerConfig
include FileUtils

log = Logger.new("#{config.log.dir}/backup.log",'monthly') 

begin
  home = Pathname.new(ENV['HOME'])
  backup_dirs = config.backup.dirs
  backup_destination_dir = Pathname.new config.backup.destination

  backup_dirs.each do | dir_name |
    source_dir_path = Pathname.new dir_name
    dest_dir_path = backup_destination_dir + source_dir_path.relative_path_from(home)
    log.info "Deleting #{dest_dir_path}"
    rm_rf dest_dir_path
    mkdir_p dest_dir_path.dirname
    cp_r source_dir_path, dest_dir_path.dirname
    log.info "Backed up #{source_dir_path} to #{dest_dir_path}"
  end
  #autoupdate `date +%F-%T`

rescue StandardError => e
  log.error "Error occurred while backing up"
  log.error e
  raise e
end
