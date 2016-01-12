require 'spec_helper'

describe "twitter_accounts/new" do
  before(:each) do
    assign(:twitter_account, stub_model(TwitterAccount,
      :name_en => "MyString",
      :consumer_key => "MyString",
      :consumer_secret => "MyString",
      :access_token_key => "MyString",
      :access_token_secret => "MyString"
    ).as_new_record)
  end

  it "renders new twitter_account form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", twitter_accounts_path, "post" do
      assert_select "input#twitter_account_name_en[name=?]", "twitter_account[name_en]"
      assert_select "input#twitter_account_consumer_key[name=?]", "twitter_account[consumer_key]"
      assert_select "input#twitter_account_consumer_secret[name=?]", "twitter_account[consumer_secret]"
      assert_select "input#twitter_account_access_token_key[name=?]", "twitter_account[access_token_key]"
      assert_select "input#twitter_account_access_token_secret[name=?]", "twitter_account[access_token_secret]"
    end
  end
end
