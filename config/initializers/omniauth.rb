okta = YAML.load_file("#{Rails.root}/config/okta.yml")
okta_settings = okta[Rails.env] || okta['staging']

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :saml,
           :issuer => "http://localhost:3000",
           :idp_sso_target_url => okta_settings['auth']['target_url'],
           :idp_cert_fingerprint => okta_settings['auth']['fingerprint'],
           :name_identifier_format => "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress",
           :idp_sso_target_url_runtime_params => {:redirectUrl => :RelayState}
end