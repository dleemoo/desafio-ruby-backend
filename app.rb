# frozen-string-literal: true

require "roda"

require_relative "system/lib"
require_relative "apps/cnab"
require_relative "apps/report"

class App < Roda
  route do |r|
    r.on("cnab") { r.run Apps::Cnab }
    r.on("reports") { r.run Apps::Report }

    r.root { r.redirect("reports/transactions-by-store") }
  end
end
