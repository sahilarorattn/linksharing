package com.intelligrape.linksharing.domain

class Invitation {

    User user
    Topic topic
    String authKey

    static belongsTo = [topic: Topic, user: User]

    static constraints = {
    }
}
