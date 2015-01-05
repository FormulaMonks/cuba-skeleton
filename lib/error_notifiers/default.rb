require "armadillo"

module ErrorNotifiers
  class Default

    attr_reader :exception

    # Initialize the ErrorsNotifiers::Default.
    #
    # @param exception [Exception]
    # @option options [String] :templates_path
    #   The path of the templates directory.
    # @option options [String] :logs_path (Dir.pwd)
    #   The path to which to place the logs directories.
    def initialize(exception, options = {})
      @exception = exception
      @templates_path = options.fetch(:templates_path)
      @logs_path = options.fetch(:logs_path, Dir.pwd)
    end

    # Log the log_content into the logs folder.
    def log
      dirname, filename = Time.now.utc.strftime("%Y%m%d_%H%M%S%L").split("_")
      dirname = File.join(@logs_path, dirname)
      filename = "#{self.class.name.gsub(/^.*\:/, "").underscore}_#{filename}"
      unless File.directory?(dirname)
        FileUtils.mkdir(dirname)
      end
      File.open(File.join(dirname, filename), "w") { |f| f.puts(content) }
    end

    # Get the content to log.
    #
    # @return [String]
    def content
      @content ||= Armadillo.render(template_name, { :notifier => self }, {
        :base_path => @templates_path
      })
    end

    # Get the exception class name.
    #
    # @return [String]
    def exception_class_name
      exception.class.name
    end

    # The current work environment.
    #
    # @return [String]
    def environment
      ENVIRONMENT
    end

  end
end
