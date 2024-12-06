class User < ApplicationRecord
  validates :email,
    presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: URI::MailTo::EMAIL_REGEXP }

  passwordless_with :email

  def admin?
    email == ENV["ADMIN_EMAIL"] || "sebagonz91@gmail.com"
  end
end
