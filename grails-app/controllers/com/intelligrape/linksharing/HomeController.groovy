package com.intelligrape.linksharing

import co.RegisterCO
import com.intelligrape.linksharing.domain.Subscription
import com.intelligrape.linksharing.domain.Topic
import com.intelligrape.linksharing.domain.User
import dto.HomeDTO
import dto.SubTopicDTO
import dto.TopicPostsDTO
import dto.UsersDTO

class HomeController {

    def homeService
    def topicService
    def resourceService
    def loginService
//  def mailService
    def index() {
        if (!session || !session.getAttribute("userId")) {
            flash.error = "Session expired. Login to continue"
            redirect(controller: "login", action: "index")
            return
        }
        String userName = session.getAttribute("userName")
        Integer userId = session.getAttribute("userId")
        /*mailService.sendMail {
            to "mailId@tothenew.com"
            subject "This is a test mail"
            body "Hello, This is a test mail, how are you?"
        }*/
        List<Topic.Visibility> visibility = Topic.Visibility.values()
        List<Subscription.Seriousness> seriousness = Subscription.Seriousness.values()
        Integer topicsCreatedCount = topicService.countTopicsCreated(userId)
        HomeDTO homeDTO = new HomeDTO([firstName: (session.getAttribute("firstName")).toString(),lastName: (session.getAttribute("lastName")).toString(),photo:(session.getAttribute("photo")),admin: (session.getAttribute("admin")), userId: userId, topicsCreatedCount: topicsCreatedCount ?: 0, visibility: visibility, seriousness: seriousness, userName: userName, fullName: (session.getAttribute("fullName")).toString()])
        def  array = topicService.fetchSubscribtions(userId, homeDTO)
        homeDTO = array.get(0)
        List<SubTopicDTO> subTopicDTOList =array.get(1)
        List<SubTopicDTO> trendTopicDTOList =  topicService.fetchTrendingTopics(userId)
        List<TopicPostsDTO> topicPostsDTOList = homeService.fetchUnreadPosts(userId,10,0)
        int count =  homeService.fetchUnreadPostsCount(userId)
        session.setAttribute("homeDTO", homeDTO)
        render view: "home", model: [count:count,trendTopicDTOList:trendTopicDTOList,"homeDTO": homeDTO, subTopicDTOList:subTopicDTOList, topicPostsDTOList: topicPostsDTOList]
    }

    def fetchUnreadPosts(int offset, int max){
        Integer userId = session.getAttribute("userId")
        List<TopicPostsDTO> topicPostsDTOList = homeService.fetchUnreadPosts(userId,max,offset)
        int count =  homeService.fetchUnreadPostsCount(userId)
        render template:"inbox", model: [topicPostsDTOList:topicPostsDTOList,count:count]
    }

    def showEditProfile() {
        Integer userId = session.getAttribute("userId")
        List<SubTopicDTO> trendTopicDTOList = homeService.fetchCreatedTopics(userId,10,0)
        int count =  homeService.fetchCreatedTopicsCount(userId)
        HomeDTO homeDTO = session.getAttribute("homeDTO")
        render view: "/home/editProfile", model: ["homeDTO": homeDTO, trendTopicDTOList: trendTopicDTOList,count:count]
    }

    def showPaginatedEditProfile(int max, int offset) {
        Integer userId = session.getAttribute("userId")
        List<SubTopicDTO> trendTopicDTOList = homeService.fetchCreatedTopics(userId,max,offset)
        int count =  homeService.fetchCreatedTopicsCount(userId)
        HomeDTO homeDTO = session.getAttribute("homeDTO")
        render template: "editProfileTopics", model: ["homeDTO": homeDTO, trendTopicDTOList: trendTopicDTOList,count:count]
    }

    def editProfile(RegisterCO registerCO) {
        String imageUploadPath = grailsApplication.config.images.upload.path
        HomeDTO homeDTO = (HomeDTO)session.getAttribute("homeDTO")
        Integer userId = session.getAttribute("userId")
        User user;
        user = homeService.editProfile(registerCO, userId)
        homeDTO.setUserName(registerCO.userName)
        homeDTO.setFirstName(registerCO.firstName)
        homeDTO.setLastName(registerCO.lastName)
        homeDTO.setFullName(registerCO.firstName + " " + registerCO.lastName)
        homeDTO.setPhoto(user.photo)
        session.setAttribute("userName", registerCO.userName)
        session.setAttribute("firstName", user.firstName)
        session.setAttribute("lastName", user.lastName)
        session.setAttribute("fullName",user.firstName+" "+user.lastName)
        session.setAttribute("photo",user.photo)
        session.setAttribute("homeDTO", homeDTO)
        if(!registerCO.photo.isEmpty()) {
            registerCO.upload(imageUploadPath, user, registerCO.photo)
        }
        flash.message = "User profile updated successfully."
        redirect action: "showEditProfile", model: [registerCO: registerCO, homeDTO: homeDTO]
    }

    def updatePassword(RegisterCO registerCO){
        HomeDTO homeDTO = (HomeDTO)session.getAttribute("homeDTO")
        Integer userId = session.getAttribute("userId")
        User user;
        user = homeService.updatePassword(registerCO, userId)
        flash.message = "Password updated successfully."
        redirect action: "showEditProfile", model: [registerCO: registerCO, homeDTO: homeDTO]
    }

    def validateUserName(String userName){
        String signIdUserName = session.getAttribute("userName")
        if(signIdUserName.equalsIgnoreCase(userName)){
            render true
        }else{
            render loginService.validateUserName(userName)
        }
    }

    def fetchUsers() {
        List<UsersDTO> usersDTOList = homeService.fetchUsers()
        render view: "users", model: ["usersDTOList": usersDTOList, "homeDTO": session.getAttribute("homeDTO")]
    }

    def deactivateUser(Integer userId) {
        homeService.deactivateUser(userId)
        flash.message = "User deactivated successfully"
        redirect(action: "fetchUsers")
    }

    def activateUser(Integer userId) {
        homeService.activateUser(userId)
        flash.message = "User activated successfully"
        redirect(action: "fetchUsers")
    }

    def markAsRead(Long resourceId, Boolean read) {
        Integer userId = session.getAttribute("userId")
        resourceService.markAsRead(resourceId, read, userId)
        if (read) {
            flash.message = "Post marked as read."
        } else {
            flash.message = "Post marked as unread."
        }

        redirect(controller: "home", action: "index")
    }

    def showUser(Long userId){
        Integer logedInUserId = session.getAttribute("userId")
        Boolean admin = session.getAttribute("admin")
        UsersDTO usersDTO = homeService.fetchUserDetails(logedInUserId,userId,admin)
        List<SubTopicDTO> trendTopicDTOList = homeService.fetchUserCreatedTopics(logedInUserId,userId,10,0,admin)
        int count =  homeService.fetchUserCreatedTopicsCount(logedInUserId, userId, admin)
        List<TopicPostsDTO> topicPostsDTOList = homeService.fetchAllPosts(logedInUserId,userId,10,0,admin)
        int countPosts =  homeService.fetchAllPostsCount(logedInUserId,userId,admin)
        HomeDTO homeDTO = session.getAttribute("homeDTO")
        render view: "/home/user", model: ["homeDTO": homeDTO, trendTopicDTOList: trendTopicDTOList,count:count,usersDTO:usersDTO,topicPostsDTOList:topicPostsDTOList,countPosts:countPosts]
    }

    def showPaginatedUser(int id, int max, int offset) {
        Integer logedInUserId = session.getAttribute("userId")
        Boolean admin = session.getAttribute("admin")
        UsersDTO usersDTO = homeService.fetchUserDetails(logedInUserId,id,admin)
        List<SubTopicDTO> trendTopicDTOList = homeService.fetchUserCreatedTopics(logedInUserId,id,max,offset,admin)
        int count =  homeService.fetchUserCreatedTopicsCount(logedInUserId,id,admin)
        HomeDTO homeDTO = session.getAttribute("homeDTO")
        render template: "userTopics", model: [homeDTO:homeDTO,"usersDTO": usersDTO, trendTopicDTOList: trendTopicDTOList,count:count]
    }

    def fetchAllPosts(int id, int offset, int max){
        Integer logedInUserId = session.getAttribute("userId")
        Boolean admin = session.getAttribute("admin")
        List<TopicPostsDTO> topicPostsDTOList = homeService.fetchAllPosts(logedInUserId,id,max,offset,admin)
        UsersDTO usersDTO = homeService.fetchUserDetails(logedInUserId,id,admin)
        int countPosts =  homeService.fetchAllPostsCount(logedInUserId,id,admin)
        render template:"allPosts", model: [usersDTO:usersDTO,topicPostsDTOList:topicPostsDTOList,countPosts:countPosts]
    }
}
