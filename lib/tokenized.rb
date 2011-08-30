module Tokenized

  def self.included(base)
    base.before_validation :generate_token, :on => :create, :unless => lambda {self.token.present?}
  end

  # Generate a new token if undefined
  def token
    t = read_attribute(:token)
    if t.nil? && !new_record?
      generate_token
      t = update_attribute :token, token
    end
    t
  end

  private

  def generate_token
    self.token = Digest::SHA512.hexdigest([Time.now, rand, self.object_id].join)[0...16]
    generate_token unless self.class.find_by_token(self.token).nil?
  end

end