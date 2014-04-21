require 'omniauth-oauth2'
# require 'oauth2'

module OmniAuth
  module Strategies
    class Lumo < OmniAuth::Strategies::OAuth2

      # option :name, 'lumo'
      # option :scope, DEFAULT_API_NAMES
      # option :provider_ignores_state, true

      option :client_options, {
        :site => 'https://api.lumobodytech.com',
        :authorize_url => 'http://localhost:3000/authorized/',
        :token_url => "https://api.lumobodytech.com/oauth2/token",
        :token_method => :get,
        :parse => :json
      }

      def authorize_params
        super.tap do |params|
          params[:response_type] = 'code'
          params[:APIName] = options.scope
        end
      end

      def token_params
        super.tap do |params|
          params[:client_id] = client.id
          params[:client_secret] = client.secret
          params[:grant_type] = "authorization_code"
        end
      end

      def build_access_token
        token_url_params = {:code => request.params['code'], :redirect_uri => callback_url}.merge(token_params.to_hash(:symbolize_keys => true))
        parsed_response = client.request(options.client_options.token_method, client.token_url(token_url_params), parse: :json).parsed
        hash = {
          :access_token => parsed_response["AccessToken"],
          :expires_in => parsed_response["Expires"],
          :refresh_token => parsed_response["RefreshToken"],
          :user_id => parsed_response["UserID"],
          :api_name => parsed_response["APIName"],
          :client_para => parsed_response["client_para"]
        }
        ::OAuth2::AccessToken.from_hash(client, hash)
      end

      uid { access_token[:user_id] }

      info { user_data.slice(:name, :nickname, :image) }

      extra do
        { :user_info => user_data, :raw_info => raw_info }
      end

      def raw_info
        access_token.options[:mode] = :query
        user_profile_params = {:client_id => client.id, :client_secret => client.secret, :access_token => access_token.token}
        user_profile_params.merge({:sc => options.sc, :sv => options.sv}) if options.sc && options.sv
        @raw_info ||= access_token.get("/openapiv2/user/#{access_token[:user_id]}.json/?#{user_profile_params.to_param}", parse: :json).parsed
      end

      def user_data
        info = raw_info
        user_data ||= {
          :name => info["nickname"],
          :gender => info["gender"].downcase,
          :birthday => Time.at(info["dateofbirth"]).to_date.strftime("%Y-%m-%d"),
          :image => URI.unescape(info["logo"]),
          :nickname => info["nickname"],
          :height => calc_height(info["height"], info["HeightUnit"]),
          :weight => calc_weight(info["weight"], info["WeightUnit"])
        }
      end
    end
  end
end


OmniAuth.config.add_camelization 'ihealth', 'IHealth'