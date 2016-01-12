require 'spec_helper'

describe "twitter_accounts/edit" do
  before(:each) do
    @twitter_account = assign(:twitter_account, stub_model(TwitterAccount,
      :name_en => "MyString",
      :consumer_key => "MyString",
      :consumer_secret => "MyString",
      :access_token_key => "MyString",
      :access_token_secret => "MyString"
    ))
  end

  it "renders the edit twitter_account form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", twitter_account_path(@twitter_account), "post" do
      assert_select "input#twitter_account_name_en[name=?]", "twitter_account[name_en]"
      assert_select "input#twitter_account_consumer_key[name=?]", "twitter_account[consumer_key]"
      assert_select "input#twitter_account_consumer_secret[name=?]", "twitter_account[consumer_secret]"
      assert_select "input#twitter_account_access_token_key[name=?]", "twitter_account[access_token_key]"
      assert_select "input#twitter_account_access_token_secret[name=?]", "twitter_account[access_token_secret]"
    end
  end
end
