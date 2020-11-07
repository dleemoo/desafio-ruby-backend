# frozen_string_literal: true

Lib.boot(:rom) do |container|
  init do
    require "pg"
    require "sequel"
    require "rom"
    require "rom-sql"
    require "rom/transformer"
  end

  start do
    Sequel.default_timezone = :utc

    db_url = if Lib.env == "test"
               container[:settings].test_database_url
             else
               container[:settings].database_url
             end

    config = ROM::Configuration.new(:sql, db_url)
    config.auto_registration container.root.join("persistence") if container[:settings].boot_rom

    register "rom.config", config
    register "rom", ROM.container(config)
  end
end
