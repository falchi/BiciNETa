class User < ActiveRecord::Base

	before_create :create_remember_token #antes de crear el usuario se le creará su remember_token
  before_save :email_downcase#{ |user| user.email = email.downcase }
  before_save :encrypt_password

  #before_save { |user| user.password = encrypt(user.password) }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates_presence_of :name, :password

  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false},
                    confirmation: true #crea el pseudo-atributo "email_confirmation"

  validates :email_confirmation, presence: true
  
	attr_accessible :name, :email, :email_confirmation, :password, :latitude, :longitude

  def email_downcase
      self.email = self.email.downcase
  end

	def log_in(submitted_password) 
		user = User.find_by_email(email)
		return nil if user.nil?
		return user if user.has_password?(submitted_password)
	end

	#ve si la pass(encriptada) en la BD coincide con la pass ingresada (encriptada)
	def has_password?(submitted_password)
		password == encrypt(submitted_password) 
  end

	private

    def encrypt_password
      self.password = encrypt(password)
    end

		#devuelve la encriptación de la variable "string" (password ingresada)
		def encrypt(string) 
			secure_hash("#{string}")		
		end

		def secure_hash(string)
			Digest::SHA1.hexdigest(string)
		end

		#asigna el valor remember_token al usuario
		def create_remember_token 
			self.remember_token = SecureRandom.urlsafe_base64
		end
end
