require 'faraday'

class Processor
  def initialize
    @request = Faraday.new(
      url: Rails.application.secrets.processor_url,
      headers: {
        'Content-Type' => 'application/json',
        'X-Sent' => Time.now.strftime('%Hh%M - %d/%m/%y')
      }
    )
  end

  def send(data)
    @request.post('/') do |req|
      req.body = data.to_json
    end
  end
end
