# frozen_string_literal: true

require "rom/sql/rake_task"

namespace :db do
  task setup: "lib:boot" do
    ROM::SQL::RakeSupport.env = Lib["rom.config"]
  end
end
