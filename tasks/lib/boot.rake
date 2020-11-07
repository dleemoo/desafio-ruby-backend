# frozen_string_literal: true

namespace :lib do
  task :boot do
    ENV["BOOT_ROM"] = "false"
    require_relative "../../system/lib"
  end
end
