package dto

import com.intelligrape.linksharing.domain.Subscription
import com.intelligrape.linksharing.domain.Topic

/**
 * Created by ttnd on 22/1/16.
 */
class HomeDTO {
    String userName
    Long userId
    String fullName
    String firstName
    String lastName
    String photo
    Long subsCount
    List<Topic.Visibility> visibility
    List<Subscription.Seriousness> seriousness
    Integer topicsCreatedCount
    Map<Long, String> topicSub
    Boolean admin

}
