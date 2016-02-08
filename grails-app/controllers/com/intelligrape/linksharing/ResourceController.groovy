package com.intelligrape.linksharing

import com.intelligrape.linksharing.domain.DocumentResource
import com.intelligrape.linksharing.domain.LinkResource
import com.intelligrape.linksharing.domain.Resource
import dto.HomeDTO
import dto.SubTopicDTO
import dto.TopicPostsDTO
import grails.converters.JSON
import org.springframework.web.multipart.commons.CommonsMultipartFile

class ResourceController {

    def resourceService
    def topicService

    def createLink(String topicSub, String description, String link) {
        Integer userId = Integer.valueOf(session.getAttribute("userId")?.toString())
        if (!topicSub) {
            flash.error = "Please subscribe to a topic to share a link."
            redirect(controller: "home", action: "index")
            return
        }
        Integer topicId = Integer.valueOf(topicSub?.toString())
        LinkResource linkResource = new LinkResource()
        linkResource.setUrl(link)
        linkResource.setDescription(description)
        resourceService.createLink(userId, topicId, linkResource)
        flash.message = "Link shared successfully."
        redirect(controller: "home", action: "index")
    }

    def createDocument(String topicSub, String description) {
        Integer userId = Integer.valueOf(session.getAttribute("userId")?.toString())
        if (!topicSub) {
            flash.error = "Please subscribe to a topic to share a document."
            redirect(controller: "home", action: "index")
            return
        }
        Integer topicId = Integer.valueOf(topicSub?.toString())
        DocumentResource documentResource = new DocumentResource()
        CommonsMultipartFile doc = params.get("document")
        String docUploadPath = grailsApplication.config.docs.upload.path
        resourceService.upload(docUploadPath, doc)
        documentResource.setFilePath(doc.fileItem.name)
        documentResource.setDescription(description)
        resourceService.createDocument(userId, topicId, documentResource)
        flash.message = "Document shared successfully."
        redirect(controller: "home", action: "index")
    }

    def markAsRead(Long resourceId, Boolean read, Long topicId) {
        Integer userId = Integer.valueOf(session.getAttribute("userId")?.toString())
        resourceService.markAsRead(resourceId, read, userId)
        if (read) {
            flash.message = "Post marked as read."
        } else {
            flash.message = "Post marked as unread."
        }

        redirect(controller: "topic", action: "showTopic", params: ["topicId": topicId])
    }

    def viewPost(Long resourceId) {
        Integer userId = session.getAttribute("userId")
        HomeDTO homeDTO = (HomeDTO) session.getAttribute("homeDTO")
        TopicPostsDTO topicPostsDTO = resourceService.fetchPost(resourceId, userId)
        List<SubTopicDTO> trendTopicDTOList = resourceService.fetchTrendingTopics(userId)
        render view: "viewPost", model: [topicPostsDTO: topicPostsDTO, homeDTO: homeDTO, trendTopicDTOList: trendTopicDTOList]
    }

    def markAsReadPost(Long resourceId, Boolean read) {
        Integer userId = Integer.valueOf(session.getAttribute("userId")?.toString())
        resourceService.markAsRead(resourceId, read, userId)
        if (read) {
            flash.message = "Post marked as read."
        } else {
            flash.message = "Post marked as unread."
        }

        redirect(controller: "resource", action: "viewPost", params: [resourceId: resourceId])
    }

    def deleteTopic(Long topicId, Long resourceId) {
        Long userId = Long.valueOf(session.getAttribute("userId")?.toString())
        if (!session || !session.getAttribute("userId")) {
            flash.error = "Session expired. Login to continue"
            redirect(controller: "login", action: "index")
            return
        }
        topicService.deleteTopic(topicId, userId)
        flash.message = "Topic deleted successfully."
        redirect(controller: "resource", action: "viewPost", params: [resourceId: resourceId])
    }

    def editLink(Long resId, String descriptionLink, String link) {
        Integer userId = Integer.valueOf(session.getAttribute("userId")?.toString())
        resourceService.editLink(resId, descriptionLink, link)
        flash.message = "Link post updated successfully."
        redirect(controller: "resource", action: "viewPost", params: [resourceId: resId])
    }

    def editDoc(Long resId, String descriptionDoc) {
        Integer userId = Integer.valueOf(session.getAttribute("userId")?.toString())
        CommonsMultipartFile doc = params.get("document")
        String docUploadPath = grailsApplication.config.docs.upload.path
        resourceService.upload(docUploadPath, doc)
        resourceService.editDoc(resId, descriptionDoc, doc)
        flash.message = "Document post updated successfully."
        redirect(controller: "resource", action: "viewPost", params: [resourceId: resId])
    }

    def deletePost(Long resId) {
        if (!session || !session.getAttribute("userId")) {
            flash.error = "Session expired. Login to continue"
            redirect(controller: "login", action: "index")
            return
        }
        resourceService.deletePost(resId)
        flash.message = "Post deleted successfully."
        redirect(controller: "home", action: "index")
    }

    def searchPosts(String searchText) {
        Boolean admin = session.getAttribute("admin")
        Integer userId = session.getAttribute("userId")
        List<SubTopicDTO> trendTopicDTOList = topicService.fetchTrendingTopics(userId)
        HomeDTO homeDTO = session.getAttribute("homeDTO")
        List<TopicPostsDTO> topPostsList = resourceService.fetchTopPosts(userId)
        int countPosts = 0
        if ((!searchText || searchText.trim().length() == 0) && !admin) {
            flash.error = 'Please enter some text to search'
            render view: "search", model: [trendTopicDTOList: trendTopicDTOList, homeDTO: homeDTO,
                                           searchPostsList  : new ArrayList<TopicPostsDTO>(), countPosts: countPosts, searchText: searchText, topPostsList: topPostsList]
            return
        }
        List<TopicPostsDTO> searchPostsList = resourceService.searchPosts(searchText, 10, 0, admin)
        countPosts = resourceService.searchPostsCount(searchText, admin)
        render view: "search", model: [trendTopicDTOList: trendTopicDTOList, homeDTO: homeDTO,
                                       searchPostsList  : searchPostsList, countPosts: countPosts, searchText: searchText, topPostsList: topPostsList]
    }

    def searchPaginatedPosts(String id, int max, int offset) {
        Integer userId = session.getAttribute("userId")
        Boolean admin = session.getAttribute("admin")
        List<TopicPostsDTO> searchPostsList = resourceService.searchPosts(id, max, offset, admin)
        int countPosts = resourceService.searchPostsCount(id, admin)
        HomeDTO homeDTO = session.getAttribute("homeDTO")
        render view: "_searchPosts", model: [homeDTO: homeDTO, searchPostsList: searchPostsList, countPosts: countPosts, searchText: id]
    }

    def setRating(Long resId, Float rating) {
        Integer userId = session.getAttribute("userId")
        def ratingData = resourceService.setRating(userId, resId, rating)
        render([avgRating: (ratingData.get(0))[0], countUsers: (ratingData.get(0))[1]] as JSON);
    }


}
