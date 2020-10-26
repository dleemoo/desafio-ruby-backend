# frozen_string_literal: true

Lib.boot(:database) do |container|
  init do
    require "sequel"
  end

  start do
    Sequel.default_timezone = :utc
    Sequel::Model.plugin :timestamps, update_on_create: true

    db_url = if container[:settings].rack_env == "test"
               container[:settings].test_database_url
             else
               container[:settings].database_url
             end

    register "db", Sequel.connect(db_url)

    container.root.glob("models/**/*.rb").each do |path|
      require path
      inflector  = Dry::Inflector.new
      model_name = path.basename.sub(".rb", "").to_s
      class_name = inflector.classify(model_name)
      namespace  = inflector.pluralize(model_name)
      register "models.#{namespace}", const_get("Models::#{class_name}")
    end
  end

  stop { container[:db].disconnect }
end
