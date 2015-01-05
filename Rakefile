task :environment do
  require "./initialize"
end

namespace :db do
  desc "Run the migrations"
  task :migrate, [:version] => :environment do |t, args|
    puts "DATABASE: #{CubaSkeleton::Settings::DATABASE_NAME}"
    Sequel.extension(:migration)
    if args[:version]
      puts "Migrating to version #{args[:version]}"
      Sequel::Migrator.run(CubaSkeleton::DB, "migrations",
                           :target => args[:version].to_i)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(CubaSkeleton::DB, "migrations")
    end
  end
end

task :console => :environment do
  require "irb"
  require "irb/completion"
  ARGV.clear
  IRB.start
end
