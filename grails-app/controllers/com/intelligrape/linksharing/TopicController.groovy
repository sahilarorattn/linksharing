package com.intelligrape.linksharing

import com.intelligrape.linksharing.domain.User
import dto.SubTopicDTO
import dto.TopicPostsDTO
import dto.UsersDTO

class TopicController {

    def topicService

    def createTopic(String topicName, String visibility) {
        Integer userId = session.userId;
        topicService.createTopic(userId, topicName, visibility)
        flash.message = "Topic created successfully."
        redirect(controller: "home", action: "index")
    }

    def validateTopic(String topicName) {
        render topicService.validateTopic(topicName)
    }

    def unsubscribeTopic(Long topicId) {
        Long userId = Long.valueOf(session.getAttribute("userId")?.toString())
        topicService.unsubscribeTopic(topicId, userId)
        flash.message = "Topic unsubscribed successfully."
        redirect(controller: "home", action: "index")
    }

    def subscribeTopic(Long topicId, String seriousness) {
        Long userId = Long.valueOf(session.getAttribute("userId")?.toString())

        topicService.subscribeTopic(topicId, userId, seriousness)
        flash.message = "Topic subscribed successfully."
        redirect(controller: "home", action: "index")
    }

    def updateSeriousness(String seriousness, Long topicId) {
        Long userId = Long.valueOf(session.getAttribute("userId")?.toString())
        boolean updateStatus = topicService.updateSeriousness(topicId, userId, seriousness)
        String message
        if (updateStatus) {
            message = "Subscription updated successfully."
        } else {
            message = "Please subscribe to topic to update subscription."
        }
        render message
    }

    def updateVisibility(String visibility, Long topicId) {
        Long userId = Long.valueOf(session.getAttribute("userId")?.toString())
        boolean updateStatus = topicService.updateVisibility(topicId, userId, visibility)
        String message
        if (updateStatus) {
            message = "Topic updated successfully."
        } else {
            message = "Topic not updated successfully."
        }
        render message
    }

    def updateTopicName(String topicName, Long topicId) {
        Long userId = Long.valueOf(session.getAttribute("userId")?.toString())
        boolean updateStatus = topicService.updateTopicName(topicId, userId, topicName)
        render updateStatus
    }

    def deleteTopic(Long topicId) {
        Long userId = Long.valueOf(session.getAttribute("userId")?.toString())
        if (!session || !session.getAttribute("userId")) {
            flash.error = "Session expired. Login to continue"
            redirect(controller: "login", action: "index")
            return
        }
        topicService.deleteTopic(topicId, userId)
        flash.message = "Topic deleted successfully."
        redirect(controller: "home", action: "index")
    }

    def showTopic(Long topicId) {
        Long userId = session.getAttribute("userId")
        SubTopicDTO subTopicDTO = topicService.fetchTopic(topicId, userId)
        List<UsersDTO> usersDTOList = topicService.fetchUsers(topicId)

        List<TopicPostsDTO> topicPostsDTOList = topicService.fetchTopicPosts(topicId, userId, 10, 0)

        render view: "topic", model: ["topicPostsDTOList": topicPostsDTOList, "usersDTOList": usersDTOList, "subTopicDTO": subTopicDTO, "homeDTO": session.getAttribute("homeDTO")]
    }

    def viewAll() {
        Long userId = Long.valueOf(session.getAttribute("userId")?.toString())
        Boolean admin = Boolean.valueOf(session.getAttribute("admin")?.toString())

        List<SubTopicDTO> subTopicDTOList = topicService.fetchViewAllSub(userId, admin, 0, 10)
        Long count = topicService.fetchViewAllCount(userId, admin)
        render view: "viewAll", model: ["viewAllList": subTopicDTOList, "homeDTO": session.getAttribute("homeDTO"), count: count]
    }

    def fetchTopicList(int offset, int max) {
        Long userId = Long.valueOf(session.getAttribute("userId")?.toString())
        Boolean admin = Boolean.valueOf(session.getAttribute("admin")?.toString())
        List<SubTopicDTO> subTopicDTOList = topicService.fetchViewAllSub(userId, admin, offset, max)
        Long count = topicService.fetchViewAllCount(userId, admin)
        render template: "topicEntity", model: ["viewAllList": subTopicDTOList, "homeDTO": session.getAttribute("homeDTO"), count: count]
    }

    def showTopicPosts(Long topicId, SubTopicDTO subTopicDTO) {
        Long userId = Long.valueOf(session.getAttribute("userId")?.toString())
        List<TopicPostsDTO> topicPostsDTOList = topicService.fetchTopicPosts(topicId, userId, 10, 0)
        int countPosts = topicService.fetchTopicPostsCount(topicId)
        render view: "_topicPostsViewAll", model: [topicPostsDTOList: topicPostsDTOList, countPosts: countPosts, subTopicDTO: subTopicDTO, topicId: topicId]
    }

    def showPaginatedTopicPosts(int id, int max, int offset, SubTopicDTO subTopicDTO) {
        Long userId = Long.valueOf(session.getAttribute("userId")?.toString())
        List<TopicPostsDTO> topicPostsDTOList = topicService.fetchTopicPosts(id, userId, max, offset)
        int countPosts = topicService.fetchTopicPostsCount(id)
        render view: "_topicPostsViewAllDiv", model: [topicPostsDTOList: topicPostsDTOList, countPosts: countPosts, subTopicDTO: subTopicDTO, topicId: id]
    }

    def sendInvitation(String emailUser, Long topicInv) {
        Integer userId = session.userId;
        String appUrl = grailsApplication.config.appUrlPath
        Boolean invited = topicService.sendInvitation(userId, emailUser, topicInv, appUrl)
        flash.message = invited ? "Invitation sent successfully." : "Email not registered."
        redirect(controller: "home", action: "index")
    }

    def subscribeInvitation(Long userId, Long topicId, String authKey) {
        def user = topicService.subscribeInvitation(userId, topicId, authKey)
        if (user && ((User) user).active) {
            session.setAttribute("userName", user.username)
            session.setAttribute("userId", user.id)
            session.setAttribute("firstName", user.firstName)
            session.setAttribute("lastName", user.lastName)
            session.setAttribute("fullName", user.firstName + " " + user.lastName)
            session.setAttribute("admin", user.admin)
            session.setAttribute("photo", user.photo)
            flash.message = "Topic subscribed successfully."
            redirect(controller: "home", action: "index")
        } else if (user && !((User) user).active) {
            session.invalidate()
            flash.error = "User profile inactive. Please contact system administrator."
            redirect(controller: "login", action: "index")
        } else {
            flash.error = "Invalid url."
            redirect(controller: "login", action: "index")
        }


    }


}
