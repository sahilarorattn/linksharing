package com.intelligrape.linksharing.domain

abstract class Resource {

    String description
    User createdBy
    Topic topic
    Date dateCreated
    Date lastUpdated

    static belongsTo = [topic: Topic, createdBy: User]
    static hasMany = [readingItems: ReadingItem]
    static constraints = {
    }
}
