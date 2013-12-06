require 'omniauth-oauth'

module OmniAuth
  module Strategies
    class Doximity < OmniAuth::Strategies::OAuth
      option :name, 'doximity'

      option :client_options, {
        site: 'www.doximity.com',
        token_path: '/oauth/token',
        authorize_path: '/oauth/authorize',
        profile_path: '/api/v1/users/current'
      }
      option :response_type, 'code'
      option :scope, 'email'
      option :redirect_uri
      option :uid_field, 'code'
      option :grant_type, 'authorization_code'

      attr_reader :profile

      def request_phase
        redirect_uri = URI(options.redirect_uri)
        redirect_uri.query = request.params.to_query
        uri = URI::HTTPS.build(
          host: options.client_options.site,
          path: options.client_options.authorize_path,
          query: {
            client_id: consumer.key,
            redirect_uri: redirect_uri.to_s,
            response_type: options.response_type,
            scope: options.scope
            }.to_query
        )
        redirect uri.to_s
      end

      def callback_phase
        @profile = user_profile(request.params['code'])
        self.env['omniauth.auth'] = auth_hash
        call_app!
      end

      def exchange_code(code)
        uri = URI::HTTPS.build(
          host: options.client_options.site,
          path: options.client_options.token_path
        )
        req = Net::HTTP::Post.new(uri.to_s)
        req.set_form_data(
          client_id: consumer.key,
          client_secret: consumer.secret,
          redirect_uri: options.redirect_uri,
          grant_type: options.grant_type,
          code: code
        )

        res = Net::HTTP.start(uri.host, uri.port,
          :use_ssl => uri.scheme == 'https') do |http|
          http.request(req)
        end

        JSON.parse(res.body)
      end

      def user_profile(code)
        token_exchange = exchange_code(code)
        uri = URI::HTTPS.build(
          host: options.client_options.site,
          path: options.client_options.profile_path,
          query: {
            access_token: token_exchange['access_token']
          }.to_query
        )
        req = Net::HTTP::Get.new(uri.to_s)

        res = Net::HTTP.start(uri.host, uri.port,
          :use_ssl => uri.scheme == 'https') do |http|
          http.request(req)
        end

        JSON.parse(res.body).merge('token_exchange' => token_exchange)
      end

      uid do
        profile['id']
      end

      info do
        {
          'name' => profile['full_name'],
          'email' => profile['email'],
          'first_name' => profile['first_name'],
          'last_name' => profile['last_name'],
          'description' => profile['description'],
          'image' => profile['profile_photo'],
          'phone' => profile['phone'],
          'urls' => {}
        }
      end

      extra do
        { 'raw_info' => profile }
      end

      private

      def auth_hash
        hash = AuthHash.new(:provider => options.name, :uid => uid)
        hash.info = info
        hash.credentials = { 'token' => profile['token_exchange']['access_token'] }
        hash.extra = extra
        hash
      end
    end
  end
end
