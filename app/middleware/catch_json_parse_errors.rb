class CatchJsonParseErrors
  # Catching bad json formating
  # https://robots.thoughtbot.com/catching-json-parse-errors-with-custom-middleware
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      @app.call(env)
    rescue ActionDispatch::ParamsParser::ParseError => error
      if env['HTTP_ACCEPT'] == "application/json" || env['HTTP_ACCEPT'] == "*/*"
        error_output = "There was a problem in the JSON you submitted: #{error}"
        return [
          400, { "Content-Type" => "application/json" },
          [ { status: 400, error: error_output,
              hint: "form-data with Content-Type application/json is not compatible"
             }.to_json ]
        ]
      else
        raise error
      end
    end
  end
end
