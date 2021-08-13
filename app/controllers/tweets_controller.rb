class TweetsController < ApplicationController

    get '/tweets' do
        # redirects to login if user isn't logged in 
        if logged_in?
            @tweets = Tweet.all
            erb :'tweets/tweets'
        else
            redirect_if_not_logged_in
        end
    end

    post '/tweets' do
        # only post from own account and has to be logged in 
        # can't post a blank tweet
        redirect_if_not_logged_in
        @tweet = current_user.tweets.build(content: params[:content])

        if @tweet.save
            redirect to "/tweets/#{@tweet.id}"
        else
            redirect to "/tweets/new"
        end
    end

    get '/tweets/new' do
        # only accessible if logged in 
        # can't post a blank tweet
        redirect_if_not_logged_in

        erb :'tweets/new'
    end

    get '/tweets/:id' do
        # user has to be logged in 
        redirect_if_not_logged_in
        redirect_if_not_authorized
        
        @tweet = Tweet.find_by_id(params[:id])
        
        erb :'tweets/show_tweet'
    end

    get '/tweets/:id/edit' do
        # user has to be logged in and has to be their tweet
        # can not edit blank content
        redirect_if_not_logged_in
        redirect_if_not_authorized
        
        @tweet = Tweet.find_by_id(params[:id])
        
        erb :'tweets/edit_tweet'
    end

    patch '/tweets/:id' do
        redirect_if_not_logged_in
        redirect_if_not_authorized

        @tweet = Tweet.find_by_id(params[:id])

        if @tweet.update(content: params[:content])
            redirect to "/tweets/#{@tweet.id}"
        else
            redirect to "/tweets/#{@tweet.id}/edit"
        end
    end

    delete '/tweets/:id/delete' do
        # user has to be logged in and has to be their tweet
        redirect_if_not_logged_in
        redirect_if_not_authorized
        @tweet = Tweet.find_by_id(params[:id])
        @tweet.destroy

        redirect to "/tweets"
    end

    private

    def redirect_if_not_authorized
        @tweet = Tweet.find_by_id(params[:id])
        if @tweet.user_id != session[:user_id]
            redirect to "/tweets"
        end
    end
end
