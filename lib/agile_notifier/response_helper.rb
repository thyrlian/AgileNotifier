require 'json'
require 'httparty'

module ResponseHelper
  def get_value_of_key(url, key)
    response = HTTParty.get(url)
    if response.code == 200
      return JSON.parse(response.body)[key]
    else
      return nil
    end
  end
end