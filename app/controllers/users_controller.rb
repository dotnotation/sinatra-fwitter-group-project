class UsersController < ApplicationController

    get '/signup' do
        # redirects to twitter index
        # does not allow sign up without username, email, password
        # does not allow logged in user to view signup page
        redirect_if_logged_in
        erb :'/users/create_user'
        # if !logged_in
        #     erb :'/users/create_user'
        # else
        #     redirect to "/tweets"
        # end
    end

    post '/signup' do
        # log in user and add user_id to session hash
        redirect_if_logged_in
        user = User.new(params[:user])
        if user.save
            session[:user_id] = user.id
            redirect to "/tweets"
        else
            redirect to "/signup"
        end
    end

    get '/login' do
        # redirects to tweet index
        # does not allow user to see login page if logged in
        redirect_if_logged_in
        erb :'/users/login'
    end

    post '/login' do
        # log in user and add user_id to session hash
        redirect_if_logged_in

        user = User.find_by(username: params[:user][:username])

        if user && user.authenticate(params[:user][:password])
            session[:user_id] = user.id
            redirect_if_logged_in
        else
            redirect to "/login"
        end
    end

    get '/logout' do
        # redirects to login page
        # if user is not logged in, redirects to login
        # clear session hash
        redirect_if_not_logged_in
        erb :'/users/logout'
    end

    post '/logout' do
        session.delete(:user_id)
        redirect to "/login"
    end

    get '/users/:slug' do
        # shows all of the user's tweets
        erb :'/users/show'
    end
end
