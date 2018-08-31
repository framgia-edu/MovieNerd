module ModelSpecHelper
  def email_slug email, id
    "#{email.gsub(/@[a-z\d\-.]+\.[a-z]+\z/, '')}#{id}"
  end
end
