# frozen_string_literal: true

module Apps
  class Cnab < Roda
    plugin :render, escape: true
    plugin :halt

    include Import["cnab.upload", "cnab.process_import"]

    route do |r|
      r.get "upload" do
        view "cnab/upload"
      end

      r.post "upload" do
        # NOTE: we are doing a upload and file processing inside http request here.
        # Out of scope add some backgorund job for now, but already using two steps.
        (@cnab_import = upload.call(r.params["file"])).bind do
          (@result = process_import.call(@cnab_import.value!)).fmap do
            r.redirect "/reports/transactions-by-store"
          end
        end.or { r.halt 422, view("cnab/upload") }
      end
    end
  end
end
