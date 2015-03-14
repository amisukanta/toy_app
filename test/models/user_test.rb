require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end
  
  test "user should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = " "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end
  
  test "user name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "user email should not be too long" do
    @user.email = "a" * 256
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com foo_as_user_foo.COM user.foo@example.
                         foo@example_bar.com foo@baz+cn+bar.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "email address should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "password should have a minimum length of 6 " do
    @user.password  = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "authenticated? with user without remember digest should be false" do
    assert_not @user.authenticated?(:remember, '')
  end
  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create(content: "suka ekta vukha")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
  
  test "should follow and unfollow a user" do
    sukanta = users(:sukanta)
    amrita = users(:amrita)
    assert_not sukanta.following?(amrita)
    sukanta.follow(amrita)
    assert sukanta.following?(amrita)
    assert amrita.followers.include?(sukanta)
    sukanta.unfollow(amrita)
    assert_not sukanta.following?(amrita)
  end
  
  test "feed should have the right posts" do
   sukanta = users(:sukanta)
   amrita = users(:amrita)
   lana = users(:lana)
   lana.microposts.each do |following_post|
     assert sukanta.feed.include?(following_post)
   end
   sukanta.microposts.each do |self_post|
     assert sukanta.feed.include?(self_post)
   end
   amrita.microposts.each do |other_post|
     assert_not sukanta.feed.include?(other_post)
   end
  end
end

