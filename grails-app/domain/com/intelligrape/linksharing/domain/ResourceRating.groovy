package com.intelligrape.linksharing.domain

class ResourceRating {

    Resource resource
    User user
    Float score

    static belongsTo = [user: User, resource: Resource]
    static constraints = {
    }

}
