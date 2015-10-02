require "google/api_client"
require "google_drive"
require "faraday"


module HttpTest
  class Google
    def self.process_records
      # Authorizes with OAuth and gets an access token.
      client = ::Google::APIClient.new
      auth = client.authorization
      auth.client_id = Settings.get.client_id
      auth.client_secret = Settings.get.client_secret
      auth.scope = [
        "https://www.googleapis.com/auth/drive",
        "https://spreadsheets.google.com/feeds/"
      ]
      auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
      print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
      print("2. Enter the authorization code shown in the page: ")
      # auth.code = '4/n7bIohLdo_3CMJFjdPI05iX5pS8fKzQgzGXEDLNICoo'
      auth.code = $stdin.gets.chomp
      auth.authorization_uri
      auth.fetch_access_token!
      access_token = auth.access_token

      # Creates a session.
      session = GoogleDrive.login_with_oauth(access_token)

      ws = session.spreadsheet_by_key(Settings.get.spreadsheet_by_key).worksheets[0]
      # Add time when run
      ws[3, 7] = Time.now.strftime("Run on %m/%d/%Y %I:%M%p")
      ws.save

      farday = HttpTest::Faraday.new
      (4..ws.num_rows).each do |row|
        next if ws[row,1] != "Y"
        response = farday.http_request(ws[row,3], ws[row,5],ws[row,6])
        ws[row, 7] = response[:status]
        ws[row, 8] = response[:body]
        puts("finished:" + ws[row,3] +  ws[row,5])
        ws.save
      end
    end
  end
end
