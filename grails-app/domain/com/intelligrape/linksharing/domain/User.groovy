package com.intelligrape.linksharing.domain

class User {
    String email
    String username
    String password
    String firstName
    String lastName
    String photo
    Boolean active
    Boolean admin
    Date dateCreated
    Date lastUpdated

    static hasMany = [topics:Topic, subscriptions:Subscription,invitations:Invitation]
    static constraints = {
        email email: true, unique: true, nullable: false, blank: false
        username unique: true,nullable: false, blank: false
        password  nullable: false, blank: false
        firstName nullable: false, blank: false
        lastName nullable: false, blank: false
        photo nullable: true
    }
}
