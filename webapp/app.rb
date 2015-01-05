require "cuba"
require "rack/protection"

require "webapp/routes/main"
require "webapp/helpers"
require "lib/error_notifiers/rack_error"

Cuba.use(Rack::MethodOverride)
Cuba.use(Rack::ShowExceptions) if ENVIRONMENT == "development"
Cuba.use(Rack::Session::Cookie, {
  :secret => CubaSkeleton::Settings::SESSION_SECRET,
  :key => "cuba-skeleton.session"
})
Cuba.use(Rack::Protection, {
  :use => [:remote_referrer, :authenticity_token],
  :except => [:remote_token]
})

Cuba.plugin(Webapp::Helpers)

Cuba.define do
  begin
    run(Webapp::Routes::Main)
  rescue Exception => ex
    if ENVIRONMENT != "development"
      ErrorNotifiers::RackError.new(ex, env, {
        :templates_path => File.join(APP_DIR, "notifiers"),
        :logs_path => CubaSkeleton::Settings::LOGS_DIR
      }).log
      render_file("public/500.html", 500)
    else
      raise ex
    end
  end
end
