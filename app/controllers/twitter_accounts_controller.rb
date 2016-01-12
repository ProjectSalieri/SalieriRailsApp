class TwitterAccountsController < ApplicationController
  before_action :set_twitter_account, only: [:show, :edit, :update, :destroy]

  # CSRFトークンエラー対応
  protect_from_forgery with: :null_session

  # GET /twitter_accounts
  # GET /twitter_accounts.json
  def index
    @twitter_accounts = TwitterAccount.all
  end

  # GET /twitter_accounts/1
  # GET /twitter_accounts/1.json
  def show

  end

  # GET /twitter_accounts/new
  def new
    @twitter_account = TwitterAccount.new
  end

  # GET /twitter_accounts/1/edit
  def edit
  end

  # POST /twitter_accounts
  # POST /twitter_accounts.json
  def create
    @twitter_account = TwitterAccount.new(twitter_account_params)

    respond_to do |format|
      if @twitter_account.save
        format.html { redirect_to @twitter_account, notice: 'Twitter account was successfully created.' }
        format.json { render :show, status: :created, location: @twitter_account }
      else
        format.html { render :new }
        format.json { render json: @twitter_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /twitter_accounts/1
  # PATCH/PUT /twitter_accounts/1.json
  def update
    respond_to do |format|
      if @twitter_account.update(twitter_account_params)
        format.html { redirect_to @twitter_account, notice: 'Twitter account was successfully updated.' }
        format.json { render :show, status: :ok, location: @twitter_account }
      else
        format.html { render :edit }
        format.json { render json: @twitter_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /twitter_accounts/1
  # DELETE /twitter_accounts/1.json
  def destroy
    @twitter_account.destroy
    respond_to do |format|
      format.html { redirect_to twitter_accounts_url, notice: 'Twitter account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET
  def regist_user
    user = TwitterAccount.find_or_create_by({:name_en => params[:name_en]})
    user.consumer_key = params[:consumer_key] if params[:consumer_key]
    user.consumer_secret = params[:consumer_secret] if params[:consumer_secret]
    user.access_token_key = params[:access_token_key] if params[:access_token_key]
    user.access_token_secret = params[:access_token_secret] if params[:access_token_secret]

    render :text => "failed" if !user.save

    home_timelines = user.home_timelines()
    user.post("test")
    render :text => home_timelines.to_json
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_twitter_account
      @twitter_account = TwitterAccount.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def twitter_account_params
      params.require(:twitter_account).permit(:name_en, :consumer_key, :consumer_secret, :access_token_key, :access_token_secret)
    end
end
