require 'google/api_client'

class GClient < Google::APIClient
  def initialize(key_path,key_secret,key_email)
    key = KeyUtils.load_from_pkcs12(File.expand_path("../#{key_path}", __FILE__), key_secret)
    asserter = JWTAsserter.new(key_email,'https://www.googleapis.com/auth/devstorage.read_only',key)
    client = Google::APIClient.new(application_name: "auth for newrelic", application_version: "1.0")
    client.authorization = asserter.authorize()

    @storage = client.discovered_api('storage', 'v1')
    @client = client
  end

  def size(bucket)
    page_token = '' # An empty pageToken will be ignored. maxResults is 1000 by default.
    total = 0
    until page_token.nil? do
      objects_list_result = @client.execute(
        api_method: @storage.objects.list,
        parameters: {bucket: bucket, pageToken: page_token}
      )
      objects_list_result.data.items.each { |item| total = total + item.size }
      page_token = objects_list_result.next_page_token
    end
    puts "[#{Time.now}] Total bytes in #{bucket}: #{total} bytes"
    return total
  end

  def number(bucket)
    page_token = '' # An empty pageToken will be ignored. maxResults is 1000 by default.
    total = 0
    until page_token.nil? do
      objects_list_result = @client.execute(
        api_method: @storage.objects.list,
        parameters: {bucket: bucket, pageToken: page_token}
      )
      objects_list_result.data.items.each { |item| total = total + 1 }
      page_token = objects_list_result.next_page_token
    end
    puts "[#{Time.now}] Total bytes in #{bucket}: #{total} Elements"
    return total
  end

end