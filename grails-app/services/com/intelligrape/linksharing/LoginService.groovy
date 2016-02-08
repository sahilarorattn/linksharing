package com.intelligrape.linksharing

import co.LoginCO
import co.RegisterCO
import com.intelligrape.linksharing.domain.DocumentResource
import com.intelligrape.linksharing.domain.LinkResource
import com.intelligrape.linksharing.domain.ReadingItem
import com.intelligrape.linksharing.domain.Resource
import com.intelligrape.linksharing.domain.Subscription
import com.intelligrape.linksharing.domain.Topic
import com.intelligrape.linksharing.domain.User
import dto.TopicPostsDTO
import grails.transaction.Transactional
import org.springframework.web.multipart.commons.CommonsMultipartFile

@Transactional
class LoginService {

    def mailService
    def validateUser(LoginCO loginCO){
        User user = User.createCriteria().get{
            like("email", loginCO.emailLogin.trim())
            eq("password",loginCO.passwordLogin)
        }
//        User user =   User.findByUsernameIlikeAndPasswordLike(""+loginCO.emailLogin,""+loginCO.passwordLogin)
//        User user =   User.findByUsernameAndPassword(loginCO.emailLogin,loginCO.passwordLogin)
        if(user){
            return user
        }
        return false
    }

    User registerUser(RegisterCO registerCO,String filePath) {
        String photo = null
        if(!registerCO.photo.isEmpty()){
            CommonsMultipartFile photoFile = registerCO.photo
            String[] type = photoFile.fileItem.name.split("\\.")
            photo = "user_image_${registerCO.userName}"+(type.length>1?".${type[type.length-1]}":"")
        }
        User user = new User([admin:false,photo:photo,active: true, email:registerCO.email, username:registerCO.userName, password:registerCO.password, firstName:registerCO.firstName, lastName:registerCO.lastName])
        user.save(flush: true)
        return user
    }

    def validateUserName(String userName){
        User user = User.findByUsername(userName)
        if(user){
            return false
        }
        return true
    }

    def validateEmail(String email){
        User user = User.findByEmail(email)
        if(user){
            return false
        }
        return true
    }


    def fetchTopPosts(Long userId=null) {
        List<Resource> resourceList = Resource.createCriteria().list {
            topic {
                eq("visibility", Topic.Visibility.PUBLIC)
            }
            maxResults(5)
            order("id", "desc")
        }
        List<TopicPostsDTO> topPostsList = new ArrayList<TopicPostsDTO>()
        for (Resource it : resourceList) {
            TopicPostsDTO dto = new TopicPostsDTO()
            dto.setType(it.domainClass.toString())
            dto.setResId(it.id)
            dto.setDesc(it.description)
            if (dto.type.contains("LinkResource")) {
                dto.setUrl(((LinkResource) it).url)
            } else if (dto.type.contains("DocumentResource")) {
                dto.setFilePath(((DocumentResource) it).filePath)
            }
            dto.setRead(false)
            dto.setPhoto(it.createdBy.photo)
            dto.setCreatedUserId(it.createdBy.id)
            dto.topicName = it.topic.name
            dto.topicId = it.topic.id
            Subscription subscription
            if(userId){
                subscription=Subscription.findByUserAndTopic(User.load(userId),it.topic)
            }
            if (subscription) {
                dto.setIsSubscribed(true)
            } else {
                dto.setIsSubscribed(false)
            }
            ReadingItem readingItem = ReadingItem.findByUserAndResource(User.load(userId), it)
            if (readingItem && readingItem.isRead) {
                dto.setRead(true)
            } else {
                dto.setRead(false)
            }
            topPostsList .add(dto)
        }
        return topPostsList
    }

    def fetchRecentShares(Long userId=null) {
        List<Resource> resourceList = Resource.createCriteria().list {
            topic {
                eq("visibility", Topic.Visibility.PUBLIC)
            }
            maxResults(5)
            order("id", "desc")
        }
        List<TopicPostsDTO> topPostsList = new ArrayList<TopicPostsDTO>()
        for (Resource it : resourceList) {
            TopicPostsDTO dto = new TopicPostsDTO()
            dto.setType(it.domainClass.toString())
            dto.setResId(it.id)
            dto.setDesc(it.description)
            if (dto.type.contains("LinkResource")) {
                dto.setUrl(((LinkResource) it).url)
            } else if (dto.type.contains("DocumentResource")) {
                dto.setFilePath(((DocumentResource) it).filePath)
            }
            dto.setRead(false)
            dto.setPhoto(it.createdBy.photo)
            dto.setCreatedUserId(it.createdBy.id)
            dto.topicName = it.topic.name
            dto.topicId = it.topic.id
            Subscription subscription
            if(userId){
                subscription=Subscription.findByUserAndTopic(User.load(userId),it.topic)
            }
            if (subscription) {
                dto.setIsSubscribed(true)
            } else {
                dto.setIsSubscribed(false)
            }
            ReadingItem readingItem = ReadingItem.findByUserAndResource(User.load(userId), it)
            if (readingItem && readingItem.isRead) {
                dto.setRead(true)
            } else {
                dto.setRead(false)
            }
            topPostsList .add(dto)
        }
        return topPostsList
    }

    def setNewPassword(LoginCO loginCO){
        User user= User.findByEmail(loginCO.emailLogin)
        if(user){
            String randomString = org.apache.commons.lang.RandomStringUtils.random(9, true, true)
            user.setPassword(randomString)
            user.save(flush: true)
            def reply = sendNewPasswordMail(loginCO,randomString )

            return true
        }else{
            return false
        }
    }

    def sendNewPasswordMail(LoginCO loginCO, String randomString){
        def reply=mailService.sendMail {
            to loginCO.emailLogin
            subject "Link Sharing Password Reset"
            body "Hi,\n" +
                    "\n" +
                    "Greetings!\n" +
                    "\n" +
                    "You are just a step away from accessing your Link Sharing account\n" +
                    "\n" +
                    "Your NEW PASSWORD is: ${randomString}\n" +
                    "\n" +
                    "You can change the password after signing in.\n" +
                    "\n" +
                    "Best Regards, \n" +
                    "Team LinkSharing"
        }
        return reply
    }

}
