package com.intelligrape.linksharing

import co.RegisterCO
import com.intelligrape.linksharing.domain.*
import dto.SubTopicDTO
import dto.TopicPostsDTO
import dto.UsersDTO
import grails.transaction.Transactional
import org.springframework.web.multipart.commons.CommonsMultipartFile

@Transactional
class HomeService {

    def fetchUsers() {
        List<User> users = User.findAll()
        List<UsersDTO> usersDTOList = new ArrayList<UsersDTO>()
        for (User it : users) {
            UsersDTO usersDTO = new UsersDTO()
            usersDTO.setAdmin(it.admin)
            usersDTO.setEmail(it.email)
            usersDTO.setUserId(String.valueOf(it.id))
            usersDTO.setUserName(it.username)
            usersDTO.setFirstName(it.firstName)
            usersDTO.setLastName(it.lastName)
            usersDTO.setActive(it.active)
            usersDTOList.add(usersDTO)
        }
        return usersDTOList
    }

    def deactivateUser(userId) {
        User user = User.load(userId)
        user.setActive(false)
        user.save()
    }

    def activateUser(userId) {
        User user = User.load(userId)
        user.setActive(true)
        user.save()
    }

    def fetchUnreadPosts(Long userId, int max, int offset) {
        List<TopicPostsDTO> topicPostsDTOList = new ArrayList<TopicPostsDTO>()
//        def resourceList = Resource.findAll(" from Resource rs, Subscription sub, ReadingItem ri where rs.topic.id = sub.topic.id and sub.user.id= :userId and ((ri.user.id= :userId and ri.isRead=false and ri.resource.id=rs.id) or ri is null ) ", ["userId": userId,offset:offset,max:max])
        def readingItemsList = ReadingItem.findAllByUserAndIsRead(User.load(userId), false, [max: max, offset: offset])
        for (def tempReading : readingItemsList) {
            Resource it = tempReading.resource
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
            topicPostsDTOList.add(dto)
        }
        return topicPostsDTOList
    }

    def fetchUnreadPostsCount(Long userId) {
        def readingItemsListCount = ReadingItem.countByUserAndIsRead(User.load(userId), false)
        return readingItemsListCount
    }

    def fetchCreatedTopics(Integer userId, int max, int offset) {
        List<Topic> topicList = Topic.createCriteria().list(max: max, offset: offset) {
            eq("createdBy", User.load(userId))
            order("resources", "desc")
        }
        List<SubTopicDTO> trendTopicDTOList = new ArrayList<SubTopicDTO>()
        for (Topic topic : topicList) {
            SubTopicDTO subTopicDTO = new SubTopicDTO()
            subTopicDTO.setTopicId(topic.id)
            subTopicDTO.setTopicName(topic.name)
            subTopicDTO.setTopicSubsCount(String.valueOf(topic.subscriptions?.size()))
            subTopicDTO.setTopicPostsCount(String.valueOf(topic.resources?.size()))
            Subscription subscription = Subscription.findByUserAndTopic(User.load(userId), topic)
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
            trendTopicDTOList.add(subTopicDTO)
        }
        return trendTopicDTOList
    }

    def fetchCreatedTopicsCount(Integer userId) {
        int count = Topic.countByCreatedBy(User.load(userId))
        return count
    }

    def fetchUserCreatedTopics(Long logedInUserId, Long userId, int max, int offset, Boolean admin) {
        List<Topic> topicList
        if (logedInUserId == userId || admin) {
            topicList = Topic.createCriteria().list(max: max, offset: offset) {
                eq("createdBy", User.load(userId))
                order("resources", "desc")
            }
        } else {
            topicList = Topic.createCriteria().list(max: max, offset: offset) {
                eq("createdBy", User.load(userId))
                eq("visibility", Topic.Visibility.PUBLIC)
                order("resources", "desc")
            }
        }

        List<SubTopicDTO> trendTopicDTOList = new ArrayList<SubTopicDTO>()
        for (Topic topic : topicList) {
            SubTopicDTO subTopicDTO = new SubTopicDTO()
            subTopicDTO.setTopicId(topic.id)
            subTopicDTO.setTopicName(topic.name)
            subTopicDTO.setTopicSubsCount(String.valueOf(topic.subscriptions?.size()))
            subTopicDTO.setTopicPostsCount(String.valueOf(topic.resources?.size()))
            Subscription subscription = Subscription.findByUserAndTopic(User.load(userId), topic)
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
            trendTopicDTOList.add(subTopicDTO)
        }
        return trendTopicDTOList
    }

    def fetchUserCreatedTopicsCount(Long logedInUserId, Long userId, Boolean admin) {
        int count
        if (logedInUserId == userId || admin) {
            count = Topic.countByCreatedBy(User.load(userId))
        } else {
            count = Topic.countByCreatedByAndVisibility(User.load(userId), Topic.Visibility.PUBLIC)
        }
        return count
    }

    def editProfile(RegisterCO registerCO, Integer userId) {
        User user = User.get(userId)
        String photo = null
        if (!registerCO.photo.isEmpty()) {
            CommonsMultipartFile photoFile = registerCO.photo
            String[] type = photoFile.fileItem.name.split("\\.")
            photo = "user_image_${userId}" + (type.length > 1 ? ".${type[type.length - 1]}" : "")
            user.setPhoto(photo)
        }
        user.setUsername(registerCO.userName)
        user.setFirstName(registerCO.firstName)
        user.setLastName(registerCO.lastName)
        user.save(flush: true)
        return user
    }

    def updatePassword(RegisterCO registerCO, Integer userId) {
        User user = User.get(userId)
        user.setPassword(registerCO.password)
        user.save(flush: true)
        return user
    }

    def fetchUserDetails(Long logedInUserId, Long userId, Boolean admin) {
        User it = User.get(userId)
        UsersDTO usersDTO = new UsersDTO()
        usersDTO.setAdmin(it.admin)
        usersDTO.setEmail(it.email)
        usersDTO.setUserId(String.valueOf(it.id))
        usersDTO.setUserName(it.username)
        usersDTO.setFirstName(it.firstName)
        usersDTO.setLastName(it.lastName)
        usersDTO.setActive(it.active)
        usersDTO.setPhoto(it.photo)
        if (logedInUserId == userId || admin) {
            usersDTO.setCountSubcriptions(Subscription.countByUser(User.load(userId)))
            usersDTO.setCountTopics(Topic.countByCreatedBy(User.load(userId)))
        } else {
            usersDTO.setCountSubcriptions(Subscription.executeQuery("select count(*) from Subscription where user.id= :userId and topic.visibility='PUBLIC'", ['userId': userId]))
            usersDTO.setCountTopics(Topic.countByCreatedByAndVisibility(User.load(userId), Topic.Visibility.PUBLIC))
        }
        return usersDTO
    }

    def fetchAllPosts(Long logedInUserId, Long userId, int max, int offset, Boolean admin) {
        List<TopicPostsDTO> topicPostsDTOList = new ArrayList<TopicPostsDTO>()
        def resourceList
        if (logedInUserId && (logedInUserId == userId || admin)) {
//            resourceList = Resource.findAll(" from Resource order by id desc", [max: max, offset: offset])
            resourceList = Resource.createCriteria().list {
                topic {
                    eq('createdBy', User.load(userId))
                }
                order('id', 'desc')
                firstResult(offset)
                maxResults(max)
            }
        } else {
            resourceList = Resource.createCriteria().list {
                topic {
                    eq('visibility', Topic.Visibility.PUBLIC)
                    eq('createdBy', User.load(userId))
                }

                order('id', 'desc')
                firstResult(offset)
                maxResults(max)
            }
        }

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
            topicPostsDTOList.add(dto)
        }
        return topicPostsDTOList
    }

    def fetchAllPostsCount(Long logedInUserId, Long userId, Boolean admin) {
        def count
        if (logedInUserId == userId || admin) {
            count = Resource.createCriteria().count {
                topic {
                    eq('createdBy', User.load(userId))
                }
            }
        } else {
            count = Resource.createCriteria().count {
                topic {
                    eq('visibility', Topic.Visibility.PUBLIC)
                    eq('createdBy', User.load(userId))
                }
            }
        }

        return count
    }

}

