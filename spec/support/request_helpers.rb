module Requests
  module JsonHelpers
    def json
      #@json_response ||= JSON.parse(response.body, symbolize_names: true)
      JSON.parse(response.body)
    end
  end
end
