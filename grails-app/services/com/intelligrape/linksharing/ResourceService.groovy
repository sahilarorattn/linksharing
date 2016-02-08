package com.intelligrape.linksharing

import com.intelligrape.linksharing.domain.DocumentResource
import com.intelligrape.linksharing.domain.LinkResource
import com.intelligrape.linksharing.domain.ReadingItem
import com.intelligrape.linksharing.domain.Resource
import com.intelligrape.linksharing.domain.ResourceRating
import com.intelligrape.linksharing.domain.Subscription
import com.intelligrape.linksharing.domain.Topic
import com.intelligrape.linksharing.domain.User
import dto.HomeDTO
import dto.SubTopicDTO
import dto.TopicPostsDTO
import grails.transaction.Transactional
import org.springframework.web.multipart.commons.CommonsMultipartFile

@Transactional
class ResourceService {

    def createDocument(Integer userId, Integer topicId, DocumentResource documentResource) {
        documentResource.setTopic(Topic.load(topicId))
        documentResource.setCreatedBy(User.load(userId))
        documentResource.save(flush: true)
        ReadingItem readingItem = ReadingItem.findOrCreateByResourceAndUserAndIsRead(documentResource, User.load(userId), false)
        readingItem.save(flush: true)
    }

    void upload(String fileLocation, CommonsMultipartFile doc) {
        String docName = doc.fileItem.name
        File fi = new File(fileLocation, docName)
        fi.setBytes(doc.bytes)
        println fi.absolutePath
    }

    def createLink(Integer userId, Integer topicId, LinkResource linkResource) {
        linkResource.setTopic(Topic.load(topicId))
        linkResource.setCreatedBy(User.load(userId))
        linkResource.save(flush: true)
        ReadingItem readingItem = ReadingItem.findOrCreateByResourceAndUserAndIsRead(linkResource, User.load(userId), false)
        readingItem.save(flush: true)
    }

    def editLink(Long resId, String descriptionLink, String link) {
        LinkResource linkResource = LinkResource.get(resId)
        linkResource.setUrl(link)
        linkResource.setDescription(descriptionLink)
        linkResource.save(flush: true)
    }

    def editDoc(Long resId, String descriptionLink, CommonsMultipartFile doc) {
        DocumentResource documentResource = DocumentResource.get(resId)
        documentResource.setFilePath(doc.fileItem.name)
        documentResource.setDescription(descriptionLink)
        documentResource.save(flush: true)
    }

    def markAsRead(Long resourceId, Boolean read, Long userId) {
        ReadingItem readingItem = ReadingItem.findByResourceAndUser(Resource.load(resourceId), User.load(userId))
        if (readingItem) {
            readingItem.setIsRead(read)
        } else {
            readingItem = new ReadingItem(isRead: read, user: User.load(userId), resource: Resource.load(resourceId))
        }
        readingItem.save(flush: true)
    }

    def fetchTrendingTopics(Integer userId) {
        List<Topic> topicList = Topic.createCriteria().list {
            eq("visibility", Topic.Visibility.PUBLIC)
            order("resources", "desc")
            maxResults(5)
        }
        // List<Topic> topicList = Topic.executeQuery("select tp from Topic as tp where tp.visibility= :visibility group by tp.id order by count(tp.resources) desc",["visibility":Topic.Visibility.PUBLIC])

//        def topicList = Resource.createCriteria().list {
//            projections {
//                property('topic')
//                count("id","count")
//
//            }
//            groupProperty("topic")
//            order("count","desc")
//        }
//        List<Topic> topicList = Topic.findAllByVisibility(Topic.Visibility.PUBLIC,[max: 5, sort: "count(resources)", order: 'desc'])
//        List<Topic> topicList = Topic.findAllByVisibility(Topic.Visibility.PUBLIC,[max: 5, sort: "resources.size", order: "desc"])
        List<SubTopicDTO> trendTopicDTOList = new ArrayList<SubTopicDTO>()
        for (Topic topic : topicList) {
            SubTopicDTO subTopicDTO = new SubTopicDTO()
            subTopicDTO.setTopicId(topic.id)
            subTopicDTO.setTopicName(topic.name)
            subTopicDTO.setTopicSubsCount(String.valueOf(topic.subscriptions?.size()))
            subTopicDTO.setTopicPostsCount(String.valueOf(topic.resources?.size()))
            Subscription subscription
            if (userId) {
                subscription = Subscription.findByUserAndTopic(User.load(userId), topic)
            }
            if (subscription) {
                subTopicDTO.setSeriousness(String.valueOf(subscription.seriousness))
                subTopicDTO.subscribed = true
            } else {
                subTopicDTO.setSeriousness(null)
                subTopicDTO.subscribed = false
            }
            subTopicDTO.setVisibility(String.valueOf(topic.visibility))
            subTopicDTO.setCreatedUserName(topic.createdBy.username)
            subTopicDTO.setCreatedUserId(topic.createdBy.id)
            subTopicDTO.setPhoto(topic.createdBy.photo)
            trendTopicDTOList.add(subTopicDTO)
        }
        return trendTopicDTOList
    }

    def fetchPost(Long resourceId, Long userId) {
        Resource it = Resource.get(resourceId)
        TopicPostsDTO dto = new TopicPostsDTO()
        dto.setType(it.domainClass.toString())
        dto.setResId(it.id)
        dto.setDesc(it.description)
        dto.setCreatedUserId(it.createdBy.id)
        dto.setUserName(it.createdBy.username)
        dto.setFullName(it.createdBy.firstName + " " + it.createdBy.lastName)
        dto.setPhoto(it.createdBy.photo)
        dto.setTopicId(it.topic.id)
        dto.setTopicName(it.topic.name)
        Subscription subscription
        ResourceRating resourceRating
        if (userId) {
            subscription = Subscription.findByUserAndTopic(User.load(userId), it.topic)
            resourceRating = ResourceRating.findByUserAndResource(User.load(userId), it)
        }
        if (subscription) {
            dto.setIsSubscribed(true)
        } else {
            dto.setIsSubscribed(false)
        }
        if(resourceRating){
            dto.setRating(resourceRating.score)
        }
        if (dto.type.contains("LinkResource")) {
            dto.setUrl(((LinkResource) it).url)
        } else if (dto.type.contains("DocumentResource")) {
            dto.setFilePath(((DocumentResource) it).filePath)
        }
        ReadingItem readingItem = ReadingItem.findByUserAndResource(User.load(userId), it)
        def ratingData = fetchRatingData(resourceId)
        dto.avgRating=ratingData.get(0)[0]
        dto.countUsersRated=ratingData.get(0)[1]
        if (readingItem && readingItem.isRead) {
            dto.setRead(true)
        } else {
            dto.setRead(false)
        }
        return dto
    }

    def deletePost(Long resId) {
        Resource.load(resId).delete(flush: true)
    }

    def searchPosts(String searchText, int max, int offset, Boolean admin) {
        if ((!searchText || searchText.trim().length() == 0) && admin) {
            searchText = "%"
        }
        List<Resource> resourceList = Resource.createCriteria().list {
            or {
                like("description", "%" + searchText + "%")
                topic {
                    like("name", "%" + searchText + "%")
                    eq("visibility", Topic.Visibility.PUBLIC)
                }
            }
            maxResults(max)
            firstResult(offset)
        }
        List<TopicPostsDTO> searchPostsList = new ArrayList<TopicPostsDTO>()
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
            searchPostsList.add(dto)
        }
        return searchPostsList
    }

    def searchPostsCount(String searchText, Boolean admin) {
        if ((!searchText || searchText.trim().length() == 0) && admin) {
            searchText = "%"
        }
        int count = Resource.createCriteria().count {
            or {
                like("description", "%" + searchText + "%")
                topic {
                    like("name", "%" + searchText + "%")
                    eq("visibility", Topic.Visibility.PUBLIC)
                }
            }
        }
        return count
    }

    def fetchTopPosts(Long userId) {
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
            if (userId) {
                subscription = Subscription.findByUserAndTopic(User.load(userId), it.topic)
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
            topPostsList.add(dto)
        }
        return topPostsList
    }

    def setRating(Long userId, Long resId, Float rating) {
        ResourceRating resourceRating = ResourceRating.findOrCreateByUserAndResource(User.load(userId), Resource.load(resId))
        resourceRating.score = rating
        resourceRating.save(flush: true)
        def ratingData = fetchRatingData(resId)
        return ratingData
    }

    def fetchRatingData(Long resId){
        def ratingData = ResourceRating.createCriteria().list {
            projections {
                avg("score", "avgRate")
                count("id", "totalCount")
            }
            eq("resource",Resource.load(resId))
        }
        return ratingData
    }
}
