import com.intelligrape.linksharing.domain.DocumentResource
import com.intelligrape.linksharing.domain.LinkResource
import com.intelligrape.linksharing.domain.ReadingItem
import com.intelligrape.linksharing.domain.Resource
import com.intelligrape.linksharing.domain.Subscription
import com.intelligrape.linksharing.domain.Topic
import com.intelligrape.linksharing.domain.User

class BootStrap {

    def init = { servletContext ->
        if (User.count() == 0L) {
            initApplication();
        }

    }

    private void initApplication() {
        def (User user1, User user2, User user3) = createUser()

        Topic topic1 = createTopics(user1, "Java", Topic.Visibility.PUBLIC)

        Topic topic2 = createTopics(user1, "SQL", Topic.Visibility.PUBLIC)
        Topic topic3 = createTopics(user2, ".net", Topic.Visibility.PUBLIC)
        // Topic topic4 = createTopics(user2,"Grails",Topic.Visibility.PUBLIC)


        Resource dr1 = new DocumentResource(filePath: "/usr/local", description: "This is a demo Document resource1..", createdBy: user1, topic: topic1)
        Resource dr2 = new DocumentResource(filePath: "/usr/local/src", description: "This is a demo Document resource2..", createdBy: user2, topic: topic1)
        Resource dr3 = new DocumentResource(filePath: "/usr/local/src", description: "This is a demo Document resource3..", createdBy: user3, topic: topic1)
        Resource dr4 = new DocumentResource(filePath: "/usr/local/src", description: "This is a demo Document resource4..", createdBy: user3, topic: topic1)

        Resource dr5 = new LinkResource(url: "/usr/local/src", description: "This is a demo Link resource5..", createdBy: user2, topic: topic2)
        Resource dr6 = new LinkResource(url: "/usr/local/src", description: "This is a demo Link resource6..", createdBy: user2, topic: topic2)
        Resource dr7 = new LinkResource(url: "/usr/local/src", description: "This is a demo Link resource7..", createdBy: user3, topic: topic2)
        Resource dr8 = new DocumentResource(filePath: "/usr/local/src", description: "This is a demo Document resource8..", createdBy: user3, topic: topic2)

        Resource dr9 = new LinkResource(url: "/usr/local/src", description: "This is a demo Link resource9..", createdBy: user1, topic: topic3)
        Resource dr10 = new DocumentResource(filePath: "/usr/local/src", description: "This is a demo Document resource10..", createdBy: user1, topic: topic3)

        dr1.save(flush: true, failOnError: true)
        dr2.save(flush: true, failOnError: true)
        dr3.save(flush: true, failOnError: true)
        dr4.save(flush: true, failOnError: true)
        dr5.save(flush: true, failOnError: true)
        dr6.save(flush: true, failOnError: true)
        dr7.save(flush: true, failOnError: true)
        dr8.save(flush: true, failOnError: true)
        dr9.save(flush: true, failOnError: true)
        dr10.save(flush: true, failOnError: true)

        ReadingItem read1 = new ReadingItem(resource: dr1, user: user1, isRead: true)
        ReadingItem read2 = new ReadingItem(resource: dr2, user: user1, isRead: true)
        ReadingItem read3 = new ReadingItem(resource: dr3, user: user1, isRead: true)

        ReadingItem read4 = new ReadingItem(resource: dr4, user: user2, isRead: true)
        ReadingItem read5 = new ReadingItem(resource: dr5, user: user2, isRead: true)
        ReadingItem read6 = new ReadingItem(resource: dr6, user: user2, isRead: true)

        ReadingItem read7 = new ReadingItem(resource: dr7, user: user3, isRead: true)
        ReadingItem read8 = new ReadingItem(resource: dr8, user: user3, isRead: true)
        ReadingItem read9 = new ReadingItem(resource: dr9, user: user3, isRead: true)

        read1.save(flush: true, failOnError: true)
        read2.save(flush: true, failOnError: true)
        read3.save(flush: true, failOnError: true)
        read4.save(flush: true, failOnError: true)
        read5.save(flush: true, failOnError: true)
        read6.save(flush: true, failOnError: true)
        read7.save(flush: true, failOnError: true)
        read8.save(flush: true, failOnError: true)
        read9.save(flush: true, failOnError: true)
    }

    private Topic createTopics(User user, String name, Topic.Visibility vsi) {

        Topic topic = new Topic([name: name, createdBy: user, visibility: vsi])
        topic.save(flush: true, failOnError: true)

        Subscription sub = new Subscription([topic: topic, user: user, seriousness: Subscription.Seriousness.SERIOUS])
        sub.save(flush: true, failOnError: true)

        return topic
    }

    private List createUser() {
        User admin = new User([admin: true, email: "sahil.arora@tothenew.com", username: "admin", password: "admin", firstName: "admin", lastName: "admin", active: true])
        User user2 = new User([admin: false, email: "arora@tothenew.com", username: "arora", password: "sahil", firstName: "asd", lastName: "asdds", active: true])
        User user3 = new User([admin: false, email: "sahil@tothenew.com", username: "sahil", password: "sahil", firstName: "ytyt", lastName: "yty", active: true])

        admin.save(flush: true, failOnError: true)
        user2.save(flush: true, failOnError: true)
        user3.save(flush: true, failOnError: true)
        [admin, user2, user3]
    }
    def destroy = {
    }
}
