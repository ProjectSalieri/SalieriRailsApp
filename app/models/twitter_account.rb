class TwitterAccount < ActiveRecord::Base

  include Twitter::TwitterUtil

  def self.admin
    return TwitterAccount.find_by({:name_en => "projectsalieri"})
  end

  def home_timelines
    login
    return get_home_timelines(@accessor)
  end

  def post(text, opt = {})
    login

    post_options = {}
    if opt.key?(:reply_id)
      unless /^@[\w\d]* .*/ =~ text && text[0] == "@"
        abort("リプライ指定するときは「@」から初めてください\n#{text}")
      end
      post_options[:in_reply_to_status_id] = opt[:reply_id]
    end

    return Twitter::TwitterUtil::post(@accessor, text, post_options)
  end

  private
  def login
    return true if @accessor != nil

    @accessor = Twitter::TwitterAccessor.new()
    admin_user = TwitterAccount.admin
    @accessor.login(admin_user.consumer_key, admin_user.consumer_secret, access_token_key, access_token_secret)
  end
end
