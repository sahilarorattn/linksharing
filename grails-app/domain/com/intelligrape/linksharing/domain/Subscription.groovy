package com.intelligrape.linksharing.domain

class Subscription {

    Topic topic
    User user
    enum Seriousness {
        CASUAL(1), SERIOUS(2), VERY_SERIOUS(3)
        int value;

        Seriousness(int val) {
            value = val;
        }

        public static Seriousness getSeriousness(int val) {
            switch (val) {
                case 1:
                    return CASUAL
                    break;
                case 2:
                    return SERIOUS
                    break;
                case 3:
                    return VERY_SERIOUS
                    break;
            }
        }
    }
    Seriousness seriousness
    Date dateCreated

    static constraints = {
    }

    static belongsTo = [topic: Topic, user: User]
}
