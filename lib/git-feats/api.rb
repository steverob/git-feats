require 'faraday'
require 'json'

module GitFeats
  module API

    extend self

    URL = 'http://localhost:3000'

    def upload_feats(background=true)
      # spawn the request as a background process
      if background
        request = fork do
          begin
            post_feats
          rescue
          end
        end
        Process.detach(request)
      
      # make the request normally
      else
        response = post_feats
        puts response
      end
    end

    private

    def post_feats
      conn.post do |req|
        req.url '/api/feats'
        req.headers['Content-Type'] = 'application/json'
        req.body = upload_feats_body.to_json
      end
    end

    # Return the faraday connection or create one
    def conn
      @conn ||= new_connection
    end

    def new_connection
      # Create git-feats connection
      Faraday.new(:url => URL) do |faraday|
        faraday.request  :url_encoded
      end
    end

    # Construct the body for the upload feats post
    def upload_feats_body
      {
        :username  => Config.name,
        :key       => Config.key,
        :history   => History.data
      }
    end
  end
end
