# config/initializers/temporary_directory.rb

TEMPORARY_DIRECTORY = Rails.root.join('tmp', 'csv_files')
FileUtils.mkdir_p(TEMPORARY_DIRECTORY) unless Dir.exist?(TEMPORARY_DIRECTORY)
