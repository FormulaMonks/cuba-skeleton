require "armadillo"
require "json"
require "rack"
require "webapp/contexts/web_context"

module Webapp
  module Helpers

    # Render no content and halt.
    def no_content!
      res.headers.delete("Content-Type")
      res.status = 204
      halt(res.finish)
    end

    # Render a 404 page into the response and halt.
    def not_found!
      if accept?("text/html")
        render_file("public/404.html", 404, false)
      else
        res.headers.delete("Content-Type")
        res.status = 404
        halt(res.finish)
      end
    end

    # Halt the execution of a route handler and redirect.
    #
    # @param path [String]
    def redirect!(path)
      res.redirect(path)
      halt(res.finish)
    end

    # Render and append the specified view with the given locals in the response
    # body content.
    #
    # @param view_path [String]
    # @param locals [Hash] ({})
    def render_view(view_path, locals = {})
      content = Armadillo.render(view_path, locals, {
        :escape_html => true,
        :scope => template_context,
        :base_path => File.join(WEBAPP_DIR, "views")
      })
      res.write(content)
      halt(res.finish)
    end

    # Render and append the object by its JSON serialization.
    #
    # @param object [Object]
    #   An object that must be able to be serialized into JSON.
    def render_json(object)
      res["Content-Type"] = "application/json"
      res.write(JSON.generate(object))
      halt(res.finish)
    end

    # Get the Hash from the params namespaced by the specified string.
    #
    # @param namespace [String]
    #
    # @return [Hash]
    def params_hash(namespace)
      params = req.params[namespace]
      unless params.kind_of?(Hash)
        params = {}
      end
      params
    end

    # Get the current request path.
    #
    # @return [String]
    def current_path
      env["REQUEST_PATH"].gsub(%r{/$}, "")
    end

    # Render a file to the response.
    #
    # @param path [String]
    #   The relative file path.
    # @param status_code [Fixnum]
    # @param cached [Boolean] (false)
    #   If true, the response might return a 304.
    def render_file(path, status_code = 200, cached = false)
      file = Rack::File.new(nil)
      file.path = path
      status, headers, body = file.serving(env)
      unless cached
        headers.delete("Last-Modified")
      end
      halt([status, headers, body])
    end

    # Determine if the request includes the Mime-Type on the Accepts header.
    #
    # @param mimetype [String]
    #
    # @return [Boolean]
    def accept?(mimetype)
      String(env["HTTP_ACCEPT"]).split(",").any? { |s| s.strip == mimetype }
    end

    # Extract the current notifications from session.
    #
    # @return [Array<(Symbol, String)>]
    def notifications
      session.delete(:notifications) || []
    end

    # Add a notification to the session.
    #
    # @param type [Symbol]
    #   One of :success, :error, :warning or :info.
    # @param message [String]
    def add_notification(type, message)
      (session[:notifications] ||= []).push([type, message])
    end

    # Determine if there are any notifications in session.
    #
    # @return [Boolean]
    def notifications?
      session[:notifications] && session[:notifications].any?
    end

    # Get a web context object with view helpers.
    #
    # @return [Contexts::WebContext]
    def template_context
      @template_context ||= Contexts::WebContext.new({
        :notifications => notifications,
        :params => req.params,
        :locales_dir => File.join(WEBAPP_DIR, "locales"),
        :authenticity_token => session[:csrf]
      })
    end

  end
end
