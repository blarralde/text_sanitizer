require 'rubygems'
require 'test_helper'
require 'text_sanitizer'

class TextSanitizerTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, TextSanitizer
  end

  test "capitalize_text should capitalize text" do
    post = Post.create(name: 'lower case')
    assert_equal 'Lower Case', post.name
  end

  test "sanitize_text should sanitize text" do
    post = Post.create(body: '<script>with script</script>')
    assert_equal 'with script', post.body
  end

  test "downcase_text should downcase text" do
    post = Post.create(email: 'UPCASE@EMAIL.COM')
    assert_equal 'upcase@email.com', post.email
  end

  test "method register_sanitizer should be defined" do
    Post.send :define_method, :upcase do |text|
      text.upcase
    end
    Post.register_sanitizer :upcase, :before_validation, :title
    post = Post.create(title:'lower case')
    assert_equal 'LOWER CASE', post.title
  end

  test "shouldn't break if text fields are not defined" do
    Post.create
  end
end
