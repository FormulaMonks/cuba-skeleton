require "cuba"

module Webapp
  module Routes
    class Main < Cuba

      define do
        on get, root do
          render_view("dashboard.html")
        end
      end

    end
  end
end
