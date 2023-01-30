Rails.application.config.middleware.insert_before 0, Rack::Cors, debug: true, logger: (-> { Rails.logger }) do
  allow do
    origins '*'

    resource '/api/*',
      :headers => :any,
      :methods => [:get,:post,:options],
      :max_age => 0
  end
end
