require 'omniauth-oauth2'
module OmniAuth
  module Strategies
    class Lumo < OmniAuth::Strategies::OAuth2

      option :name, 'lumo'

      option :client_options, {
        :site => 'https://api.lumobodytech.com/',
        :authorize_url => "https://api.lumobodytech.com/oauth/authorize/",
        :token_url => "https://api.lumobodytech.com/oauth2/token",
        :token_method => :post
      }

      option :token_options, { :grant_type => "authorization_code", :oauth_callback => "http://127.0.0.1:3000/auth/lumo/callback/"}

      def authorize_params
        puts "Building authorize_params"
        super.tap do |params|
          params[:response_type] = 'code'
          params[:client_id] = ENV['LUMO_CLIENT_ID']
          params[:redirect_url] = CGI.escape("http://127.0.0.1:3000/auth/lumo/callback/")
        end
      end

      uid{ raw_info['id'] }

      info do
        {
          :name => raw_info['name'],
          :email => raw_info['email']
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/me').parsed
      end

      private

      def client_params
        puts 'client params'
        {:client_id => options[:client_id], :redirect_uri => callback_url ,:response_type => "code"}
      end

    end
  end
end

OmniAuth.config.add_camelization 'lumo', 'Lumo'