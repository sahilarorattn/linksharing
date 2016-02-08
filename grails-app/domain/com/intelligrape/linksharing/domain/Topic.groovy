package com.intelligrape.linksharing.domain


class Topic {

    String name
    User createdBy
    Date dateCreated
    Date lastUpdated
    enum Visibility{
        PRIVATE(1),
        PUBLIC(2)
        int value;
        Visibility(int value) {
            this.value = value;
        }
        public static Visibility getVisibility(int val) {
            if(val == 1) {
                return  PRIVATE
            } else {
                return PUBLIC
            }
        }

    }
    Visibility visibility
    static constraints = {
    }
    static belongsTo = [createdBy: User]
    static hasMany = [subscriptions:Subscription, resources: Resource,invitations:Invitation]
}
