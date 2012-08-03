OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, "xFe0CWDaD78htI3HZ20r0w" , "SskIHF2bJfzGZVp6cLcvzOCOPg2nTaeCHNZ6jNW08w" 
  provider :facebook, '269297293176542', '8ec75746c7194a7f91976d623fe4f247',
  		   :scope => 'email,user_birthday,read_stream', :display => 'popup'
end