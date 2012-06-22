class Post < ActiveRecord::Base
  attr_accessible :body, :email, :title, :name
  sanitize_text :body
  downcase_text :email
  capitalize_text :name
end
