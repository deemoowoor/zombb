require 'test_helper'

class UserTest < ActiveSupport::TestCase
    def setup
        @user = User.new(name: "Example User", email: "user@example.com",
                         password: "foobar", password_confirmation: 'foobar')
    end

    test "password should have a minimum length" do
        @user.password = @user.password_confirmation = "a" * 5
        @user.save
        assert_not @user.valid?
    end

    test "email should be downcased before saving" do
        mixed_case_email = 'User@ExAmplE.com'
        @user.email = mixed_case_email
        @user.save
        assert_equal mixed_case_email.downcase, @user.email

    end
end
