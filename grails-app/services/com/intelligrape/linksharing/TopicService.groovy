package com.intelligrape.linksharing

import com.intelligrape.linksharing.domain.*
import dto.HomeDTO
import dto.SubTopicDTO
import dto.TopicPostsDTO
import dto.UsersDTO
import grails.transaction.Transactional

@Transactional
class TopicService {

    def mailService

    def createTopic(Integer userId, String topicName, String visibility) {
        User user = User.load(userId)
        Topic topic = new Topic(name: topicName, createdBy: user,
                visibility: visibility)
        topic.save(flush: true)
        subscribeTopic(user, topic, Subscription.Seriousness.VERY_SERIOUS,userId)
    }

    def subscribeTopic(User user, Topic topic, Subscription.Seriousness seriousness,Integer userId) {
        Subscription subs = new Subscription(user: user, topic: topic, seriousness: seriousness)
        subs.save(flush: true)
        /*List<Resource> resources = subs.topic.resources
        resources.each {
            ReadingItem readingItem = ReadingItem.findOrCreateByResourceAndUserAndIsRead(it,User.load(userId),false)
            readingItem.save(flush: true)
        }*/
    }

    def fetchSubscribtions(Integer userId, HomeDTO homeDTO) {
        User user = User.load(userId)
        List<Subscription> list =//Subscription.executeQuery("SELECT sub from Subscription sub, Topic tp where sub.topic_id= tp.id and sub.user_id=:userId order by (select )",[:])
                Subscription.findAllByUser(user,[max:5])
        Long countSubs = Subscription.countByUser(user)
        homeDTO.setSubsCount(countSubs)
        Map<Long, String> topicSub = new HashMap<Long, String>()
        List<SubTopicDTO> subTopicDTOList = new ArrayList<SubTopicDTO>()
        for (Subscription sub : list) {
            //topicSub.put(sub.topic.id, sub.topic.name)
            SubTopicDTO subTopicDTO = new SubTopicDTO()
            subTopicDTO.setTopicId(sub.topic.id)
            subTopicDTO.setTopicName(sub.topic.name)
            subTopicDTO.setTopicSubsCount(String.valueOf(sub.topic.subscriptions?.size()))
            subTopicDTO.setTopicPostsCount(String.valueOf(sub.topic.resources?.size()))
            subTopicDTO.setSeriousness(String.valueOf(sub.seriousness))
            subTopicDTO.setVisibility(String.valueOf(sub.topic.visibility))
            subTopicDTO.setCreatedUserName(sub.topic.createdBy.username)
            subTopicDTO.setCreatedUserId(sub.topic.createdBy.id)
            subTopicDTO.setPhoto(sub.topic.createdBy.photo)
            subTopicDTOList.add(subTopicDTO)
        }
        list = Subscription.findAllByUser(user)
        for (Subscription sub : list) {
            topicSub.put(sub.topic.id, sub.topic.name)
        }
        homeDTO.setTopicSub(topicSub)
        return [homeDTO,subTopicDTOList]
    }

    def fetchTrendingTopics(Integer userId){
        List<Topic> topicList = Topic.createCriteria().list{
            eq("visibility", Topic.Visibility.PUBLIC)
            order("resources","desc")
            maxResults(5)
        }
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
            if(userId){
                subscription= Subscription.findByUserAndTopic( User.load(userId),topic)
            }
            if(subscription){
                subTopicDTO.setSeriousness(String.valueOf(subscription.seriousness))
                subTopicDTO.subscribed=true
            }
            else{
                subTopicDTO.setSeriousness(null)
                subTopicDTO.subscribed=false
            }
            subTopicDTO.setVisibility(String.valueOf(topic.visibility))
            subTopicDTO.setCreatedUserName(topic.createdBy.username)
            subTopicDTO.setCreatedUserId(topic.createdBy.id)
            subTopicDTO.setPhoto(topic.createdBy.photo)
            trendTopicDTOList.add(subTopicDTO)
        }
        return trendTopicDTOList
    }

    def countTopicsCreated(Integer userId) {
        User user = User.load(userId)
        return Topic.countByCreatedBy(user)
    }

    def validateTopic(String topicName) {
        Topic topic = Topic.findByName(topicName)
        if (topic) {
            return false
        }
        return true
    }

    def unsubscribeTopic(Long topicId, Long userId){
        Subscription subs = Subscription.findByUserAndTopic(User.load(userId), Topic.load(topicId))
        Resource[] resources = subs.topic.resources
        resources.each {
            ReadingItem readingItem = ReadingItem.findByResourceAndUser(it,User.load(userId))
            readingItem?.delete(flush: true)
        }
        subs.delete(flush: true)

    }

    def subscribeTopic(Long topicId, Long userId , String seriousness) {
        Subscription.Seriousness serious
        if(seriousness.equalsIgnoreCase("CASUAL")){
            serious = Subscription.Seriousness.CASUAL
        }else if(seriousness.equalsIgnoreCase("SERIOUS")){
            serious = Subscription.Seriousness.SERIOUS
        }else{
            serious = Subscription.Seriousness.VERY_SERIOUS
        }
        Subscription subs = Subscription.findByUserAndTopic( User.load(userId), Topic.load(topicId))
        if(subs){
            subs.seriousness=serious
        }
        else{
            subs = new Subscription(user: User.load(userId), topic: Topic.load(topicId), seriousness: serious)
        }
        subs.save(flush: true)
        Resource[] resources = subs.topic.resources
        resources.each {
            ReadingItem readingItem = ReadingItem.findOrCreateByResourceAndUserAndIsRead(it,User.load(userId),false)
            readingItem.save(flush: true)
        }
    }

    def updateSeriousness(Long topicId, Long userId , String seriousness) {
        Subscription.Seriousness serious
        if(seriousness.equalsIgnoreCase("CASUAL")){
            serious = Subscription.Seriousness.CASUAL
        }else if(seriousness.equalsIgnoreCase("SERIOUS")){
            serious = Subscription.Seriousness.SERIOUS
        }else{
            serious = Subscription.Seriousness.VERY_SERIOUS
        }
        Subscription subs = Subscription.findByUserAndTopic(User.load(userId), Topic.load(topicId))
        if(subs){
            subs.setSeriousness(serious)
            subs.save(flush: true)
            return true
        }
        return false
    }

    def updateVisibility(Long topicId, Long userId , String visibility) {
        Topic.Visibility visibility1
        if(visibility.equalsIgnoreCase("PUBLIC")){
            visibility1 = Topic.Visibility.PUBLIC
        }else{
            visibility1 = Topic.Visibility.PRIVATE
        }
        Topic topic = Topic.load(topicId)
        topic.setVisibility(visibility1)
        topic.save(flush: true)
        return true
    }

    def updateTopicName(Long topicId, Long userId , String topicName) {
        List<Topic> tpcLst= Topic.findAllByNameAndCreatedBy(topicName, User.load(userId))
        if((tpcLst.size()==1 && tpcLst.get(0).id==topicId) || (tpcLst.size()==0) ){
            Topic topic = Topic.load(topicId)
            topic.setName(topicName)
            topic.save(flush: true)
            return true
        }
        else{
            return false
        }
    }

    def deleteTopic(Long topicId, Long userId){
        Topic.load(topicId).delete(flush: true)
    }

    def fetchTopic(Long topicId, Long userId){
        Topic topic= Topic.get(topicId)
        SubTopicDTO subTopicDTO = new SubTopicDTO()
        subTopicDTO.setTopicId(topic.id)
        subTopicDTO.setTopicName(topic.name)
        subTopicDTO.setTopicSubsCount(String.valueOf(topic.subscriptions?.size()))
        subTopicDTO.setTopicPostsCount(String.valueOf(topic.resources?.size()))
        Subscription subscription
        if(userId){
            subscription = Subscription.findByUserAndTopic( User.load(userId),topic)
        }
        if(subscription){
            subTopicDTO.setSeriousness(String.valueOf(subscription.seriousness))
            subTopicDTO.subscribed=true
        }
        else{
            subTopicDTO.setSeriousness(null)
            subTopicDTO.subscribed=false
        }
        subTopicDTO.setVisibility(String.valueOf(topic.visibility))
        subTopicDTO.setCreatedUserName(topic.createdBy.username)
        subTopicDTO.setCreatedUserId(topic.createdBy.id)
        subTopicDTO.setPhoto(topic.createdBy.photo)
        return subTopicDTO
    }

    def fetchUsers(Long topicId) {
        List<Subscription> subs = Subscription.findAllByTopic(Topic.load(topicId))

        List<UsersDTO> usersDTOList = new ArrayList<UsersDTO>()
        for(Subscription it: subs){
            UsersDTO usersDTO = new UsersDTO()
            usersDTO.setUserId(String.valueOf(it.user.id))
            usersDTO.setUserName(it.user.username)
            usersDTO.setFirstName(it.user.firstName)
            usersDTO.setLastName(it.user.lastName)
            usersDTO.setCountTopics(Topic.countByCreatedBy(it.user))
            usersDTO.setCountSubcriptions(Subscription.countByUser(it.user))
            usersDTO.setPhoto(it.user.photo)
            usersDTOList.add(usersDTO)
        }
        return  usersDTOList
    }

    def fetchTopicPosts(Long topicId, Long userId, int max, int offset) {
        List<TopicPostsDTO> topicPostsDTOList = new ArrayList<TopicPostsDTO>()
        List<Resource> resourceList = Resource.findAllByTopic(Topic.load(topicId),[max: max,offset: offset, sort: "dateCreated", order: "desc"])
        for (Resource it : resourceList) {
            TopicPostsDTO dto = new TopicPostsDTO()
            dto.setType(it.domainClass.toString())
            dto.setResId(it.id)
            dto.setDesc(it.description)
            if(dto.type.contains("LinkResource")){
                dto.setUrl(((LinkResource)it).url)
            }
           else if(dto.type.contains("DocumentResource")){
                dto.setFilePath(((DocumentResource)it).filePath)
            }
            ReadingItem readingItem = ReadingItem.findByUserAndResource(User.load(userId), it)
            if (readingItem && readingItem.isRead) {
                dto.setRead(true)
            } else {
                dto.setRead(false)
            }
            dto.setPhoto(it.createdBy.photo)
            dto.createdUserId= it.createdBy.id
            topicPostsDTOList.add(dto)
        }
        return  topicPostsDTOList
    }

    def fetchTopicPostsCount(Long topicId) {
        int count = Resource.countByTopic(Topic.load(topicId))
        return count
    }

    private static void  setDocProperties(long topicId, long userId, ArrayList<TopicPostsDTO> topicPostsDTOList) {
        List<DocumentResource> docResourceList = DocumentResource.findAllByTopic(Topic.load(topicId))
        for (DocumentResource it : docResourceList) {
            TopicPostsDTO dto = new TopicPostsDTO()
            dto.setType(it.domainClass.toString())
            dto.setResId(it.id)
            dto.setDesc(it.description)
            dto.setFilePath(it.filePath)
            ReadingItem readingItem = ReadingItem.findByUserAndResource(User.load(userId), it)
            if (readingItem && readingItem.isRead) {
                dto.setRead(true)
            } else {
                dto.setRead(false)
            }
            topicPostsDTOList.add(dto)
        }
    }

    private static void  setLinkProperties(long topicId, long userId, ArrayList<TopicPostsDTO> topicPostsDTOList) {
        List<LinkResource> linkResourceList = LinkResource.findAllByTopic(Topic.load(topicId))
        for (LinkResource it : linkResourceList) {
            TopicPostsDTO dto = new TopicPostsDTO()
            dto.setType(it.domainClass.toString())
            dto.setResId(it.id)
            dto.setDesc(it.description)
            dto.setUrl(it.url)
            ReadingItem readingItem = ReadingItem.findByUserAndResource(User.load(userId), it)
            if (readingItem && readingItem.isRead) {
                dto.setRead(true)
            } else {
                dto.setRead(false)
            }
            topicPostsDTOList.add(dto)
        }
    }

    List<SubTopicDTO> fetchViewAllSub(Long userId, Boolean admin, Long offset,Long max){
        List<SubTopicDTO> subTopicDTOList = new ArrayList<SubTopicDTO>()
        if(admin){
            List<Topic> topicList = Topic.findAll("from Topic as tp order by tp.name",[max:max, offset: offset])
            topicList.each {
                subTopicDTOList = setTopicValues(userId,it,subTopicDTOList)
            }
        }else{
            List<Subscription> subscriptionList = Subscription.findAllByUser(User.load(userId),[max:max,sort:"topic.name", offset: offset])
            subscriptionList.each {
                Topic topic = it.topic
                subTopicDTOList = setTopicValues(userId,topic,subTopicDTOList)
            }
        }
        return subTopicDTOList
    }

    private List<SubTopicDTO>  setTopicValues(Long userId,Topic topic, List<SubTopicDTO> subTopicDTOList) {
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
        subTopicDTO.setPhoto(topic.createdBy.photo)
        subTopicDTOList.add(subTopicDTO)
        subTopicDTOList
    }

    def fetchViewAllCount(Long userId, Boolean admin){
        Long subscriptionListCount = admin ? Topic.count() : Subscription.countByUser(User.load(userId))
        return subscriptionListCount
    }

    Boolean sendInvitation(Integer userId, String emailUser, Long topicId,String appUrl) {
        emailUser=emailUser.trim()
        User user = User.findByEmail(emailUser)
        User invitedBy =User.load(userId)
        Topic topic = Topic.load(topicId)
        if(user){
            String authKey = org.apache.commons.lang.RandomStringUtils.random(15, true, true)
            Invitation invitation = Invitation.findOrCreateByUserAndTopic(user,topic)
            invitation.authKey=authKey
            invitation.save(flush: true)
            mailService.sendMail {
                to emailUser
                subject "Link Sharing Subscription Invitation"
                body "Hi,\n\nGreetings!\n\nYou have been invited by ${invitedBy.firstName} to subscribe to Topic: ${topic.name}.\n" +
                        "\nClick on following link to subscribe to this topic.\n\n" +
                        "Link: ${appUrl}/topic/subscribeInvitation?userId=${user.id}&topicId=${topicId}&authKey=${authKey}\n" +
                        "\nBest Regards,\nTeam LinkSharing"
            }
            return true
        }
        else{
            return false
        }

    }

    def subscribeInvitation(Long userId, Long topicId, String authKey){
        User user = User.load(userId)
        Invitation invitation = Invitation.findByUserAndTopicAndAuthKey(user,Topic.load(topicId),authKey)
        if(invitation){
            Subscription subscription = Subscription.findByUserAndTopic(user,Topic.load(topicId))
            if(!subscription){
                subscription= new Subscription(user: user,topic: Topic.load(topicId),seriousness: Subscription.Seriousness.CASUAL)
                subscription.save(flush: true)
            }
            invitation.delete(flush: true)
            return user
        }
        else{
            return false
        }
    }


}
