require "lib/error_notifiers/default"

module ErrorNotifiers
  class RackError < Default

    REJECTED_ENV_KEYS = [
      "rack.input", "rack.request.form_hash", "rack.request.form_input",
      "rack.request.form_vars", "rack.request.cookie_hash",
      "rack.request.cookie_string", "HTTP_COOKIE"
    ]
    REJECTED_PARAM_KEYS = [
      "password"
    ]

    # Initialize the ErrorsNotifiers::RackError.
    #
    # @param exception [Exception]
    # @param env [Hash]
    def initialize(exception, env, options = {})
      super(exception, options)
      @env = env
    end

    # Get the sanitized request params.
    #
    # @return [Hash]
    def params
      @sanitized_params ||= _sanitized_params(request.params)
    end

    # Get the rack env without any of the rejected keys.
    #
    # @return [Array<(String, Object)>]
    #   An Array of two-element pairs, the first one being the rack env key
    #   and the second one the rack env value.
    def sanitized_env
      @sanitized_env ||= begin
        @env.reject do |k, v|
          REJECTED_ENV_KEYS.include?(k)
        end.to_a.sort_by(&:first)
      end
    end

    protected

    # Get the template name for this logger.
    #
    # @return [String]
    def template_name
      "rack_error.text"
    end

    # Get the Rack::Request.
    #
    # @return [Rack::Request]
    def request
      @request ||= Rack::Request.new(@env)
    end

    # Get the request params without the rejected param keys.
    #
    # @return [Hash]
    def _sanitized_params(params)
      params.each_with_object({}) do |(key, value), sanitized|
        sanitized[key] = if REJECTED_PARAM_KEYS.include?(key)
          "[FILTERED]"
        elsif value.kind_of?(Hash)
          _sanitized_params(value)
        else
          value
        end
      end
    end

  end
end
