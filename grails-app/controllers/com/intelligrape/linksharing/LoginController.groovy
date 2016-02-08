package com.intelligrape.linksharing

import co.LoginCO
import co.RegisterCO
import com.intelligrape.linksharing.domain.User
import dto.TopicPostsDTO

class LoginController {

    LoginService loginService

    def index() {
        if (null != session && null != session.getAttribute("userId")) {
            redirect(controller: "Home", action: "index")
        } else {

            List<TopicPostsDTO> recentSharesList = loginService.fetchRecentShares(null)
            List<TopicPostsDTO> topPostsList = loginService.fetchTopPosts(null)
            render view: 'login', model: [recentSharesList: recentSharesList, topPostsList: topPostsList]
        }
    }

    def loginHandler(LoginCO loginCo) {
        //validate user
        def user = loginService.validateUser(loginCo)
        if (user && ((User) user).active) {
            session.setAttribute("userName", user.username)
            session.setAttribute("userId", user.id)
            session.setAttribute("firstName", user.firstName)
            session.setAttribute("lastName", user.lastName)
            session.setAttribute("fullName", user.firstName + " " + user.lastName)
            session.setAttribute("admin", user.admin)
            session.setAttribute("photo", user.photo)
            redirect(controller: "home", action: "index")
        } else if (user && !((User) user).active) {
            session.invalidate()
            flash.error = "User profile inactive. Please contact system administrator."
            redirect(action: "index")
        } else {
            flash.error = "Invalid email/password."
            redirect(action: "index")
        }

    }

    def registerUser(RegisterCO registerCO) {
        String imageUploadPath = grailsApplication.config.images.upload.path
        User user;
        if (registerCO.validate()) {
            user = loginService.registerUser(registerCO, imageUploadPath)
            registerCO.upload(imageUploadPath, user, registerCO.photo)
            flash.message = "Congratulations. You have successfully registered. Please Login to continue. "
            redirect(controller: "login", action: "index")
        } else {
            List errorsList = new ArrayList()
            registerCO.errors.allErrors.each {
                errorsList.add(it)
            }
            flash.errors = errorsList as String;
            render view: "/login/login", model: ["registerCO": registerCO]
        }
    }

    def logout() {
        session.invalidate()
        flash.message = "Logged out successfully."
        redirect(action: "index")
    }

    def validateUserName(String userName) {
        render loginService.validateUserName(userName)
    }

    def validateEmail(String email) {
        render loginService.validateEmail(email)
    }

    def validateForgotPassEmail(String email) {
        render (!(loginService.validateEmail(email)))
    }

    def forgotPassword(LoginCO loginCO){


        loginService.setNewPassword(loginCO)

        flash.message="New Password has been sent to your registered email. You can change your password after signing in."
        redirect view:"index", model: [loginCO: loginCO]
    }

}
